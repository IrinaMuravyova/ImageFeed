//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 04.01.2026.
//
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    // MARK: - Constants
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            updateImage()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    private var imageURL: URL?
    
    // MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateImage()
        setupScrollView()
        
        if let url = imageURL {
         setImage(from: url)
        }
    }
    
    // MARK: - IBActions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
    @IBAction private func didTapShareButton() {
        guard let image else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Public functions
    func scrollViewDidEndZooming(
        _ scrollView: UIScrollView,
        with view: UIView?,
        atScale scale: CGFloat
    ) {
        scrollView.contentInset = .zero
        updateContentInset()
    }
    
    func setImage(from url: URL) {
        imageURL = url
        
//        imageView.kf.indicatorType = .activity
//        imageView.kf.setImage(
//            with: url,
//            placeholder: UIImage(named: "Stub"),
//            options: [.transition(.fade(0.3))]
//        )
    }

    // MARK: - Private functions
    private func setupScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
    }
    
    private func updateImage() {
        guard let image else { return }

        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image)
    }
    
    // MARK: - Zoom handling
    private func rescaleAndCenterImageInScrollView(_ image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layer.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let widthScale = visibleRectSize.width / image.size.width
        let heightScale = visibleRectSize.height / image.size.height
        
        let theoreticalScale = min(widthScale, heightScale)
        let scale = min(maxZoomScale, max(minZoomScale, theoreticalScale))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func updateContentInset() {
        let boundsSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize

        let verticalInset = max((boundsSize.height - contentSize.height) / 2, 0)
        let horizontalInset = max((boundsSize.width - contentSize.width) / 2, 0)

        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
