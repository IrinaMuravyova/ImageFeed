//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 04.01.2026.
//

import UIKit

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController {
    // MARK: - Constants
    var profilePhotoImageView: UIImageView?
    var nameLabel: UILabel?
    var nickLabel: UILabel?
    var descriptionLabel: UILabel?
    var logoutButton: UIButton?
    
    // MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBackground
        
        addProfilePhoto()
        addName()
        addNick()
        addDescription()
        addLogoutButton()
        addLayoutConstraints()
    }
}

// MARK: - Private functions
extension ProfileViewController {
    private func addProfilePhoto() {
        let image = UIImage(named: "profile_photo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        self.profilePhotoImageView = imageView
    }
    
    private func addName() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        self.nameLabel = nameLabel
    }
    
    private func addNick() {
        let nickLabel = UILabel()
        nickLabel.text = "@ekaterina_nov"
        nickLabel.textColor = .nickName
        nickLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nickLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nickLabel)
        self.nickLabel = nickLabel
    }
    
    private func addDescription() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel
    }

    private func addLogoutButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "Exit") ?? UIImage(),
            target: self,
            action: #selector(logoutButtonTapped)
        )
        logoutButton.tintColor = .profileLogoutButton
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        self.logoutButton = logoutButton
    }
    
    private func addLayoutConstraints() {
        guard let profilePhotoImageView = profilePhotoImageView else { return }
        NSLayoutConstraint.activate([
            profilePhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profilePhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        guard let nameLabel = self.nameLabel else { return }
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        guard let nickLabel = self.nickLabel else { return }
        NSLayoutConstraint.activate([
            nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nickLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        guard let descriptionLabel = self.descriptionLabel else { return }
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        guard let logoutButton = self.logoutButton else { return }
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: profilePhotoImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func logoutButtonTapped() {
        self.dismiss(animated: true , completion: nil)
    }
}
