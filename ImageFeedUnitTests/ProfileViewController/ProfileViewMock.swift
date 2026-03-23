//
//  ProfileViewMock.swift
//  ImageFeedUnitTests
//
//  Created by Irina Muravyeva on 20.03.2026.
//
import ImageFeed
import Foundation

// MARK: - Mock View
final class ProfileViewMock: ProfileViewControllerProtocol {
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var lastProfile: Profile?
    var lastAvatarURL: String?
    var showLogoutAlertCalled = false
    var logoutCompletion: (() -> Void)?
    
    func updateProfileDetails(with profile: Profile) {
        updateProfileDetailsCalled = true
        lastProfile = profile
    }
    
    func updateAvatar(with url: URL?) {
        updateAvatarCalled = true
        lastAvatarURL = url?.absoluteString
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
    
    func dismissView() {
        // Implementation for test
    }
}
