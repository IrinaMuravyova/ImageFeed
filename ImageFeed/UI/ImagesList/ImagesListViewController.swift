//
//  ViewController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 29.12.2025.
//

import UIKit
import Kingfisher

// MARK: - ImagesListViewController
final class ImagesListViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let imagesListService = ImagesListService.shared

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        imagesListService.fetchPhotosNextPage()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            let photo = photos[indexPath.row]
            if let url = URL(string: photo.largeImageURL) {
                viewController.imageURL = url
            }
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    // MARK: - Private Methods
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    @objc private func updateTableViewAnimated() {
        let oldCount = photos.count
        photos = imagesListService.photos
        let newCount = photos.count
        
        guard newCount > oldCount else {
            tableView.reloadData()
            return
        }
        
        let indexPaths = (oldCount..<newCount).map {
            IndexPath(row: $0, section: 0)
        }
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Error casting the cell to the ImagesListCell type")
            return UITableViewCell()
        }
        imageListCell.delegate = self
        
        imageListCell.selectionStyle = .none
        imageListCell.likeButton.isHidden = true
        imageListCell.photoDate.isHidden = true
        
        let photo = photos[indexPath.row]
        let placeholderImage = UIImage(resource: .stub)
  
        if let url = URL(string: photo.thumbImageURL) {
            imageListCell.feedImageView.kf.indicatorType = .activity
            
            setupPlaceholder(for: imageListCell.feedImageView)

            imageListCell.feedImageView.kf.setImage(
                with: url,
                placeholder: placeholderImage,
                options: [
                    .transition(.fade(0.25))]
            ){ [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    imageListCell.likeButton.isHidden = false
                    imageListCell.photoDate.isHidden = false
                    
                    imageListCell.setIsLiked(photo.isLiked)
                    
                    if let date = photo.createdAt {
                        imageListCell.photoDate.text = self.dateFormatter.string(from: date)
                    } else {
                        imageListCell.photoDate.text = ""
                    }
                    
                case .failure:
                    print("Failed to load image for cell at indexPath: \(indexPath)")
                }
            }
        } else {
            imageListCell.feedImageView.image = placeholderImage
            setupPlaceholder(for: imageListCell.feedImageView)
        }
        
        return imageListCell
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    private func setupPlaceholder(for imageView: UIImageView) {
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.whiteAlpha50
        imageView.clipsToBounds = true
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let screenWidth = tableView.bounds.width
        let value = photo.size.width / screenWidth
        return photo.size.height / value
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {

    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        let newLikeState = !photo.isLiked
        imagesListService.changeLike(photoId: photo.id, isLike: newLikeState) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert(error)
                print(error)
            }
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
