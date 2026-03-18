//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 16.03.2026.
//

import Foundation
internal import CoreGraphics

enum UnsplashError: Error {
    case invalidURL
    case invalidToken
    case invalidResponse
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
}

final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var isLoading = false
    
    private let isoDateFormatter = ISO8601DateFormatter()
    
    func fetchPhotosNextPage() {
        if isLoading { return }
        isLoading = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        let urlString = "https://api.unsplash.com/photos?page=\(nextPage)&per_page=10"
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuth2TokenStorage.shared.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        
        let task = URLSession.shared.dataTask(
            with: request
        ) { [weak self] data, response, error in
            guard let self = self else { return }
            
            defer { self.isLoading = false }
            
            if let error = error {
                print("Network error:", error)
                return
            }
            
            guard let data = data else { return }
            
            let urlString = "https://api.unsplash.com/photos?page=\(nextPage)&per_page=10"
            
            do {
                let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                
                let newPhotos = photoResults.map { result -> Photo in
                    let date = result.createdAt.flatMap { self.isoDateFormatter.date(from: $0) }
                    
                    return Photo(
                        id: result.id,
                        size: CGSize(width: result.width, height: result.height),
                        createdAt: date,
                        welcomeDescription: result.description,
                        thumbImageURL: result.urls.small,
                        largeImageURL: result.urls.full,
                        isLiked: result.likedByUser
                    )
                }
                
                DispatchQueue.main.async {
                    
                    let oldCount = self.photos.count
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    self.isLoading = false
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
            } catch {
                print("Decoding error: ", error)
            }
        }
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(UnsplashError.invalidToken))
            return
        }
        
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            completion(.failure(UnsplashError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            guard let self else { return }
            
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(UnsplashError.invalidResponse))
                }
                return
            }
            
            DispatchQueue.main.async {
                self.updatePhotoLike(photoId: photoId, isLiked: isLike)
                completion(.success(()))
            }
        }
        
        task.resume()
    }
    
    private func updatePhotoLike(photoId: String, isLiked: Bool) {
        guard let index = photos.firstIndex(where: { $0.id == photoId }) else { return }
        
        let photo = photos[index]
        
        photos[index] = Photo(
            id: photo.id,
            size: photo.size,
            createdAt: photo.createdAt,
            welcomeDescription: photo.welcomeDescription,
            thumbImageURL: photo.thumbImageURL,
            largeImageURL: photo.largeImageURL,
            isLiked: isLiked
        )
        
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }
    
    func reset() {
        photos.removeAll()
    }
}
