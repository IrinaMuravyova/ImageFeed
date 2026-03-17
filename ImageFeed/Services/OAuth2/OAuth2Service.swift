//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 31.01.2026.
//

import Foundation

final class OAuth2Service {
    // MARK: - Public Properties
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private let urlSession = URLSession.shared
    private let dataStorage = OAuth2TokenStorage.shared
    
    private(set) var authToken: String? {
        get {
            dataStorage.token
        }
        set {
            dataStorage.token = newValue
        }
    }
    
    // MARK: - Private Initials
    private init() {}
    
    func fetchOAuthToken(
        _ code: String,
        handler: @escaping (Result<String, Error>) -> Void) {
            assert(Thread.isMainThread)
            
            guard lastCode != code else {
                handler(.failure(NetworkError.invalidRequest))
                return
            }
            
            task?.cancel()
            lastCode = code
            
            guard let request = makeOAuthTokenRequest(code: code) else {
                DispatchQueue.main.async {
                    handler(.failure(NetworkError.invalidRequest))
                }
                return
            }

            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                
                UIBlockingProgressHUD.dismiss()
                
                guard let self else { return }
                
                self.task = nil
                self.lastCode = nil
                
                switch result {
                case .success(let data):
                    let authToken = data.accessToken
                    self.authToken = authToken
                    handler(.success(authToken))
                case .failure(let error):
                    print("[fetchOAuthToken]: Ошибка запроса: \(error.localizedDescription)")
                    self.handleFailure(error: error, completion: handler)
                }
            }
            
            self.task = task
            task.resume()
    }
    
    // MARK: - Private functions
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]

        guard let authTokenUrl = urlComponents.url else {
            return nil
        }

        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
    
    private func handleSuccessfulResponse(
            data: Data,
            completion: @escaping (Result<String, Error>) -> Void
        ) {
            do {
                let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                
                let bearerToken = tokenResponse.accessToken
                OAuth2TokenStorage.shared.token = bearerToken
                completion(.success(bearerToken))
            
            } catch let decodingError {
                completion(.failure(NetworkError.decodingError(decodingError)))
            }
        }
        
    private func handleFailure(
        error: Error,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .httpStatusCode(let statusCode):
                print("[OAuth2Service] Ошибка сервера: HTTP статус \(statusCode)")
            case .urlRequestError(let urlError):
                print("[OAuth2Service] Сетевая ошибка запроса: \(urlError.localizedDescription)")
            case .urlSessionError:
                print("[OAuth2Service] Ошибка URLSession")
            case .decodingError(let decodingError):
                print("[OAuth2Service] Ошибка декодирования: \(decodingError.localizedDescription)")
            default:
                print("[OAuth2Service] Неизвестная сетевая ошибка: \(error.localizedDescription)")
            }
        } else {
            print("[OAuth2Service] Общая ошибка: \(error.localizedDescription)")
        }
        
        completion(.failure(error))
    }
}

// MARK: - Network Client
extension OAuth2Service {
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let body = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(body))
                }
                catch {
                    
                    completion(.failure(NetworkError.decodingError(error)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
