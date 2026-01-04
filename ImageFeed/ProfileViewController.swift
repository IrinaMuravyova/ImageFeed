//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 04.01.2026.
//

import UIKit

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    // MARK: - IBActions
    @IBOutlet weak var logoutButton: UIButton!
}
