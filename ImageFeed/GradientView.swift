//
//  Extension + UIView.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 02.01.2026.
//

import UIKit

final class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func setupGradient() {
        guard let darkColor = UIColor(named: "DarkBackground") else {
            print("Color DarkBackground didn't found at Assets.xcassets")
            gradientLayer.colors = [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.5).cgColor
            ]
            return
        }
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            darkColor.withAlphaComponent(0.5).cgColor
        ]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
