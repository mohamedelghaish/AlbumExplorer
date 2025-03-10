//
//  ImageViewerViewController.swift
//  AlbumExplorer
//
//  Created by Mohamed Kotb Saied Kotb on 10/03/2025.
//

import UIKit
import Kingfisher

class ImageViewerViewController: UIViewController, UIScrollViewDelegate {
    
    private let imageUrl: URL
    private let imageView = UIImageView()
    private let scrollView = UIScrollView()

    init(imageUrl: URL) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .black
        
        
        scrollView.frame = view.bounds
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: imageUrl)
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            scrollView.addGestureRecognizer(doubleTapGesture)
        
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: 20, y: 50, width: 60, height: 30)
        view.addSubview(closeButton)
        
        
        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Share", for: .normal)
        shareButton.tintColor = .white
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        shareButton.frame = CGRect(x: view.frame.width - 80, y: 50, width: 60, height: 30)
        view.addSubview(shareButton)
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let zoomScale = scrollView.zoomScale == 1.0 ? 2.5 : 1.0
        let touchPoint = gesture.location(in: imageView)

        let zoomRect = CGRect(
            x: touchPoint.x - (scrollView.frame.size.width / zoomScale) / 2,
            y: touchPoint.y - (scrollView.frame.size.height / zoomScale) / 2,
            width: scrollView.frame.size.width / zoomScale,
            height: scrollView.frame.size.height / zoomScale
        )

        scrollView.zoom(to: zoomRect, animated: true)
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func shareTapped() {
        let activityVC = UIActivityViewController(activityItems: [imageUrl], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
