//
//  ProfilePresenterMock.swift
//  ImageFeedUnitTests
//
//  Created by Irina Muravyeva on 20.03.2026.
//

import ImageFeed
import Foundation

// MARK: - Mock Presenter
final class ProfilePresenterMock: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var logoutButtonTappedCalled = false
    var updateAvatarCalled = false
    var updateProfileDetailsCalled = false
    var lastProfile: Profile?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logoutButtonTapped() {
        logoutButtonTappedCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func updateProfileDetails(with profile: Profile) {
        updateProfileDetailsCalled = true
        lastProfile = profile
    }
}
