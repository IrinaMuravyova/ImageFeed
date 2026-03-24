//
//  ImagesListServiceMock.swift
//  ImageFeedUnitTests
//
//  Created by Irina Muravyeva on 24.03.2026.
//

import Foundation
@testable import ImageFeed

class ImagesListServiceMock: ImagesListService {
    var mockPhotos: [Photo] = []
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    
    override func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    override func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
        completion(.success(()))
    }
}
