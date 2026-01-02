//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 29.12.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var gradientView: GradientView!
    
    @IBOutlet  weak var feedImageView: UIImageView!
    @IBOutlet weak var photoDate: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        contentView.frame = contentView.frame.inset(by: padding)
    }
}
