//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 29.12.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfiguration = UISceneConfiguration(
            name: "Main",
            sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
    
    // MARK: - For debugging
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            #if DEBUG
            if CommandLine.arguments.contains("-clearAuth") {
                OAuth2TokenStorage.shared.removeToken()
                print("🗑️ Токен очищен для UI-тестов")
            }
            #endif
            
            return true
        }
}

