//
//  ImagesListViewTests.swift
//  ImageFeedUnitTests
//
//  Created by Irina Muravyeva on 24.03.2026.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewControllerTests: XCTestCase {
    
    // MARK: - Properties
    var sut: ImagesListViewController!
    var mockTableView: TableViewMock!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        sut = ImagesListViewController()
        
        mockTableView = TableViewMock(frame: CGRect(x: 0, y: 0, width: 320, height: 600), style: .plain)
        
        sut.setValue(mockTableView, forKey: "tableView")
        
        mockTableView.dataSource = sut
        mockTableView.delegate = sut
        
        mockTableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        
        _ = sut.view
    }
    
    override func tearDown() {
        NotificationCenter.default.removeObserver(sut)
        
        sut = nil
        mockTableView = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    func testViewControllerInitialization() {
        // Then
        XCTAssertNotNil(sut, "ViewController should be initialized")
        XCTAssertNotNil(sut.photos, "Photos array should be initialized")
        XCTAssertEqual(sut.photos.count, 0, "Photos array should be empty initially")
    }
    
    // MARK: - TableView Tests
    func testTableViewNumberOfRows_WithEmptyPhotos() {
        // Given
        sut.photos = []
        
        // When
        let numberOfRows = sut.tableView(mockTableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, 0, "Number of rows should be 0 when photos are empty")
    }
    
    func testTableViewNumberOfRows_WithPhotos() {
        // Given
        let photo = createMockPhoto()
        sut.photos = [photo, photo]
        
        // When
        let numberOfRows = sut.tableView(mockTableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, 2, "Number of rows should match photos count")
    }
        
    // MARK: - Helper Methods
    private func createMockPhoto() -> Photo {
        return Photo(
            id: "test_id",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: nil,
            thumbImageURL: "https://example.com/thumb.jpg",
            largeImageURL: "https://example.com/large.jpg",
            isLiked: false
        )
    }
}
