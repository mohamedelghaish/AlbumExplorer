//
//  PhotoCell.swift
//  AlbumExplorer
//
//  Created by Mohamed Kotb Saied Kotb on 10/03/2025.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    private var imageUrl: URL?
    override func awakeFromNib() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGesture)
    }
    
    func convertPlaceholderUrl(_ url: String) -> String {
        if url.contains("via.placeholder.com"),
           let colorCode = url.components(separatedBy: "/").last {
            return "https://dummyimage.com/600/\(colorCode)/white"
        }
        return url
    }

    func configure(with photo: Photo) {
        let updatedUrlString = convertPlaceholderUrl(photo.url)
        print(updatedUrlString)
        if let url = URL(string: updatedUrlString) {
            self.imageUrl = url
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"),
                                  options: [
                                          .forceRefresh,
                                          .cacheOriginalImage
                                      ]
            )
        }
    }

    @objc private func imageTapped() {
        guard let imageUrl = imageUrl else { return }
        
        // Find the parent view controller to present the image viewer
        if let parentVC = self.findViewController() {
            let imageViewerVC = ImageViewerViewController(imageUrl: imageUrl)
            parentVC.present(imageViewerVC, animated: true)
        }
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let vc = responder as? UIViewController {
                return vc
            }
            nextResponder = responder.next
        }
        return nil
    }
}
