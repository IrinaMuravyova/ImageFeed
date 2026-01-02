//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 29.12.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var feedImageView: UIImageView!
    @IBOutlet private weak var gradientView: GradientView!
}
