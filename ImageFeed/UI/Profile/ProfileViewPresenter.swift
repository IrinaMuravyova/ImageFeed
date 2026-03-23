//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 23.03.2026.
//

import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func logoutButtonTapped()
    func updateAvatar()
    func updateProfileDetails(with profile: Profile)
}

class ProfileViewPresenter: ProfilePresenterProtocol {
    
    // MARK: - Properties
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let profileLogoutService: ProfileLogoutService
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Initialization
    init(
        profileService: ProfileService = ProfileService.shared,
        profileImageService: ProfileImageService = ProfileImageService.shared,
        profileLogoutService: ProfileLogoutService = ProfileLogoutService.shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
        
        setupObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - ProfilePresenterProtocol
    func viewDidLoad() {
        if let profile = profileService.profile {
            updateProfileDetails(with: profile)
        }
        updateAvatar()
    }
    
    func logoutButtonTapped() {
        view?.showLogoutAlert()
        profileLogoutService.logout()
        view?.dismissView()
    }
    
    func updateAvatar() {
        guard let avatarURLString = profileImageService.avatarURL,
              let avatarURL = URL(string: avatarURLString) else {
            view?.updateAvatar(with: nil)
            return
        }
        
        view?.updateAvatar(with: avatarURL)
    }
    
    func updateProfileDetails(with profile: Profile) {
        view?.updateProfileDetails(with: profile)
    }
    
    // MARK: - Private Methods
    private func setupObservers() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateAvatar()
            }
    }
    
    private func removeObservers() {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
            profileImageServiceObserver = nil
        }
    }
}
