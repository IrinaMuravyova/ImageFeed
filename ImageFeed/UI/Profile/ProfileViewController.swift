//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 04.01.2026.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(with profile: Profile)
    func updateAvatar(with url: URL?)
    func showLogoutAlert()
    func dismissView()
}

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController {
    // MARK: - UI
    private(set) lazy var profilePhotoImageView: UIImageView = {
        let image = UIImage(named: "profile_photo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var nickLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .nickName
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit") ?? UIImage(),
            target: self,
            action: #selector(logoutButtonTapped)
        )
        button.tintColor = .profileLogoutButton
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Private properties
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - For better testing
    private(set) var presenter: ProfilePresenterProtocol?
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    // MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        if presenter == nil {
            presenter = ProfileViewPresenter()
            presenter?.view = self
        }
        presenter?.viewDidLoad()
    }
}

// MARK: - Private functions
extension ProfileViewController {
    private func setupView() {
        view.backgroundColor = .darkBackground
        
        view.addSubview(profilePhotoImageView)
        view.addSubview(nameLabel)
        view.addSubview(nickLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Profile photo
            profilePhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profilePhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // Logout button
            logoutButton.centerYAnchor.constraint(equalTo: profilePhotoImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Name
            nameLabel.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Nick
            nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nickLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    // MARK: - Actions
    @objc func logoutButtonTapped() {
        presenter?.logoutButtonTapped()
    }
}

// MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfileDetails(with profile: Profile) {
        nameLabel.text = profile.name.isEmpty
            ? " "
            : profile.name
        nickLabel.text = profile.loginName.isEmpty
            ? "@неизвестный_пользователь"
            : profile.loginName
        descriptionLabel.text = (profile.bio?.isEmpty ?? true)
            ? "Профиль не заполнен"
            : profile.bio
    }
    
    func updateAvatar(with url: URL?) {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        
        profilePhotoImageView.kf.indicatorType = .activity
        profilePhotoImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]
        )
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Выход из аккаунта",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(
            UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
                self?.presenter?.logoutButtonTapped()
            }
        )
        
        present(alert, animated: true)
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
