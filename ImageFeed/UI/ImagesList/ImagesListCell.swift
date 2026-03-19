//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 29.12.2025.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var gradientView: GradientView!

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var photoDate: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: ImagesListCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right:  16)
        contentView.frame = contentView.frame.inset(by: padding)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedImageView.kf.cancelDownloadTask()
        
        likeButton.isHidden = true
        photoDate.isHidden = true
        
        feedImageView.image = nil
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imagesListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked
            ? UIImage(resource: .active)
            : UIImage(resource: .noActive)
        
        likeButton.setImage(likeImage, for: .normal)                   
    }
}
