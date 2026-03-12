//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 12.03.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_no_active"),
            selectedImage: UIImage(named: "tab_editorial_active")
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_no_active"),
            selectedImage: UIImage(named: "tab_profile_active")
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
