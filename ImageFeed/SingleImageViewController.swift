//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Irina Muravyeva on 04.01.2026.
//

import UIKit

class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            guard let image = image else {
                assertionFailure("Can't rescale and center without image")
                return
            }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image)
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = image else {
            assertionFailure("Can't rescale and center without image")
            return
        }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image)
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
    @IBAction func didTapShareButton() {
        guard let image else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func scrollViewDidEndZooming(
        _ scrollView: UIScrollView,
        with view: UIView?,
        atScale scale: CGFloat
    ) {
        scrollView.contentInset = .zero
        updateContentInset()
    }
    
    // MARK: - Private functions
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
