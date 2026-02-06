//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 05.02.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let storage = OAuth2TokenStorage.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if storage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(
                withIdentifier: showAuthenticationScreenSegueIdentifier,
                sender: nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

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

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
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

