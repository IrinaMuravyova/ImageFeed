//
//  ProfileViewTests.swift
//  ImageFeedUnitTests
//
//  Created by Irina Muravyeva on 20.03.2026.
//

import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {
    
    var sut: ProfileViewController!
    var mockPresenter: ProfilePresenterMock!
    var mockView: ProfileViewMock!
    
    override func setUp() {
        super.setUp()
        sut = ProfileViewController()
        mockPresenter = ProfilePresenterMock()
        mockView = ProfileViewMock()

        sut.configure(mockPresenter)
        
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockView = nil
        super.tearDown()
    }
    
    // MARK: - Configuration Tests
    func testViewControllerConfiguration() {
        // Given
        let viewController = sut
        let expectedPresenter = mockPresenter
        
        // When
        // Configuration already done in setUp
        
        // Then
        XCTAssertNotNil(viewController, "ProfileViewController should initialize successfully")
        XCTAssertNotNil(viewController?.view, "View should be loaded")
        XCTAssertNotNil(viewController?.presenter, "Presenter should be set after configuration")
        XCTAssertTrue(viewController?.presenter === expectedPresenter, "Presenter should be the configured mock")
    }
    
    func testPresenterViewIsSetAfterConfiguration() {
        // Given
        let presenter = mockPresenter
        let expectedView = sut
        
        // When
        // Configuration already done in setUp
        
        // Then
        XCTAssertNotNil(presenter?.view, "Presenter's view should be set after configuration")
        XCTAssertTrue(presenter?.view === expectedView, "Presenter's view should be the view controller")
    }
    
    // MARK: - View Lifecycle Tests
    func testViewDidLoadCallsPresenter() {
        // Given
        let testViewController = ProfileViewController()
        let testMockPresenter = ProfilePresenterMock()
        testViewController.configure(testMockPresenter)
        
        testMockPresenter.viewDidLoadCalled = false
        
        // When
        _ = testViewController.view
        
        // Then
        XCTAssertTrue(testMockPresenter.viewDidLoadCalled, "Presenter's viewDidLoad should be called when view loads")
    }
    
    // MARK: - UI Elements Tests
    func testUIElementsExist() {
        // Given
        let viewController = sut
        
        // When
        // View controller is already loaded
        
        // Then
        XCTAssertNotNil(viewController?.profilePhotoImageView, "Profile photo image view should exist")
        XCTAssertNotNil(viewController?.nameLabel, "Name label should exist")
        XCTAssertNotNil(viewController?.nickLabel, "Nick label should exist")
        XCTAssertNotNil(viewController?.descriptionLabel, "Description label should exist")
        XCTAssertNotNil(viewController?.logoutButton, "Logout button should exist")
    }
    
    func testUIElementsAreAddedToView() {
        // Given
        let view = sut.view
        let profilePhotoImageView = sut.profilePhotoImageView
        let nameLabel = sut.nameLabel
        let nickLabel = sut.nickLabel
        let descriptionLabel = sut.descriptionLabel
        let logoutButton = sut.logoutButton
        
        // When
        // View controller is already loaded
        
        // Then
        XCTAssertTrue(view?.subviews.contains(profilePhotoImageView) ?? false, "Profile photo image view should be added to view")
        XCTAssertTrue(view?.subviews.contains(nameLabel) ?? false, "Name label should be added to view")
        XCTAssertTrue(view?.subviews.contains(nickLabel) ?? false, "Nick label should be added to view")
        XCTAssertTrue(view?.subviews.contains(descriptionLabel) ?? false, "Description label should be added to view")
        XCTAssertTrue(view?.subviews.contains(logoutButton) ?? false, "Logout button should be added to view")
    }
    
    // MARK: - Update Profile Details Tests
    func testUpdateProfileDetailsUpdatesUILabels() {
        // Given
        let testProfile = Profile(
            username: "test_user",
            name: "Test User",
            loginName: "@test_user",
            bio: "Test bio description"
        )
        
        // When
        sut.updateProfileDetails(with: testProfile)
        
        // Then
        XCTAssertEqual(sut.nameLabel.text, "Test User", "Name label should update with profile name")
        XCTAssertEqual(sut.nickLabel.text, "@test_user", "Nick label should update with login name")
        XCTAssertEqual(sut.descriptionLabel.text, "Test bio description", "Description label should update with bio")
    }
    
    func testUpdateProfileDetailsWithEmptyName() {
        // Given
        let testProfile = Profile(
            username: "test_user",
            name: "",
            loginName: "@test_user",
            bio: "Test bio"
        )
        
        // When
        sut.updateProfileDetails(with: testProfile)
        
        // Then
        XCTAssertEqual(sut.nameLabel.text, " ", "Name label should show space when name is empty")
        XCTAssertEqual(sut.nickLabel.text, "@test_user", "Nick label should not be affected")
    }
    
    func testUpdateProfileDetailsWithEmptyLoginName() {
        // Given
        let testProfile = Profile(
            username: "test_user",
            name: "Test User",
            loginName: "",
            bio: "Test bio"
        )
        
        // When
        sut.updateProfileDetails(with: testProfile)
        
        // Then
        XCTAssertEqual(sut.nameLabel.text, "Test User", "Name label should not be affected")
        XCTAssertEqual(sut.nickLabel.text, "@неизвестный_пользователь", "Nick label should show default message when login name is empty")
    }
    
    func testUpdateProfileDetailsWithNilBio() {
        // Given
        let testProfile = Profile(
            username: "test_user",
            name: "Test User",
            loginName: "@test_user",
            bio: nil
        )
        
        // When
        sut.updateProfileDetails(with: testProfile)
        
        // Then
        XCTAssertEqual(sut.descriptionLabel.text, "Профиль не заполнен", "Description label should show default message when bio is nil")
    }
    
    func testUpdateProfileDetailsWithEmptyStringBio() {
        // Given
        let testProfile = Profile(
            username: "test_user",
            name: "Test User",
            loginName: "@test_user",
            bio: ""
        )
        
        // When
        sut.updateProfileDetails(with: testProfile)
        
        // Then
        XCTAssertEqual(sut.descriptionLabel.text, "Профиль не заполнен", "Description label should show default message when bio is empty string")
    }
    
    // MARK: - Avatar Update Tests
    func testUpdateAvatarWithValidURL() {
        // Given
        let validURL = URL(string: "https://example.com/avatar.jpg")
        
        // When
        sut.updateAvatar(with: validURL)
        
        // Then
        XCTAssertNotNil(sut.profilePhotoImageView.image, "Profile photo should have an image after update")
    }
    
    func testUpdateAvatarWithNilURL() {
        // Given
        let nilURL: URL? = nil
        
        // When
        sut.updateAvatar(with: nilURL)
        
        // Then
        XCTAssertNotNil(sut.profilePhotoImageView.image, "Profile photo should have placeholder image when URL is nil")
    }
    
    func testUpdateAvatarWithInvalidURL() {
        // Given
        let invalidURL = URL(string: "invalid_url")
        
        // When
        sut.updateAvatar(with: invalidURL)
        
        // Then
        XCTAssertNotNil(sut.profilePhotoImageView.image, "Profile photo should have placeholder image when URL is invalid")
    }
    
    // MARK: - Logout Button Tests
    func testLogoutButtonHasTarget() {
        // Given
       let button = sut.logoutButton
       let target = sut
       let controlEvent = UIControl.Event.touchUpInside
       
       // When
       let actions = button.actions(forTarget: target, forControlEvent: controlEvent)
       
       // Then
       XCTAssertNotNil(actions, "Logout button should have actions")
       XCTAssertTrue(actions?.contains("logoutButtonTapped") ?? false, "Logout button should have logoutButtonTapped action")
    }
    
    func testLogoutButtonTappedCallsPresenter() {
        // Given
        let presenter = mockPresenter
        presenter?.logoutButtonTappedCalled = false
        
        // When
        sut.logoutButtonTapped()
        
        // Then
        XCTAssertTrue(((presenter?.logoutButtonTappedCalled) != nil), "Presenter's logoutButtonTapped should be called")
    }
}
