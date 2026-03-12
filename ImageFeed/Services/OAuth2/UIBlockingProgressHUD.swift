//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 13.02.2026.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.colorHUD = .darkBackground
        ProgressHUD.colorBackground = .clear
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
