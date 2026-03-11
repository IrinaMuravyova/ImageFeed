//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 05.02.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Properties
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - View Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token: token)
//            switchToTabBarController()
        } else {
            performSegue(
                withIdentifier: showAuthenticationScreenSegueIdentifier,
                sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - Auth Navigation
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.isModalInPresentation = true
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
        
        guard let token = storage.token else {
            return
        }
        
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }

            switch result {
            case let .success(profile):
                profileImageService.fetchProfileImageURL(
                    username: profile.username) { _ in }
                self.switchToTabBarController()

            case let .failure(error):
                print(error)
                break
            }
        }
    }
    
    private func switchToTabBarController() {
        let window = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        guard let window = window
        else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        guard let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController else {
            assertionFailure("Failed to instantiate TabBarViewController")
            return
        }
            
        setupTabBarAppearance(tabBarController.tabBar)
        window.rootViewController = tabBarController
    }
    
    private func setupTabBarAppearance(_ tabBar: UITabBar) {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .darkBackground
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
            
        } else {
            tabBar.barTintColor = .darkBackground
            tabBar.isTranslucent = false
        }
    }

    private func fixTabBarAppearance(_ tabBar: UITabBar) {
        tabBar.setNeedsLayout()
        tabBar.layoutIfNeeded()
        
        if #available(iOS 15.0, *) {
            DispatchQueue.main.async {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .darkBackground
                
                tabBar.standardAppearance = appearance
                tabBar.scrollEdgeAppearance = appearance
            }
        }
    }
}

