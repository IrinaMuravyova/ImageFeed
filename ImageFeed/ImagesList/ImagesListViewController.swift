//
//  ViewController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 29.12.2025.
//

import UIKit

// MARK: - ImagesListViewController
final class ImagesListViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let photosName: [String] = Array(0...19).map(String.init)
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Private Methods
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = String(indexPath.row)
        
        guard let photo = UIImage(named: imageName) else {
            print("Photo with name \(imageName) not found")
            return
        }
        
        cell.feedImageView.image = photo
        cell.photoDate.text = dateFormatter.string(from: Date())
        cell.likeButton.imageView?.image = indexPath.row % 2 == 0 ?
            UIImage(named: "Active") :
            UIImage(named: "NoActive")
        
        cell.selectionStyle = .none
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Error casting the cell to the ImagesListCell type")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = UIImage(named: String(indexPath.row))
        let screenWidth = tableView.bounds.width
        
        if let imageWidth = photo?.size.width,
           let imageHeight = photo?.size.height {
            let value = imageWidth / screenWidth
            return imageHeight / value
        } else {
            return 200
        }
        
    }
}
