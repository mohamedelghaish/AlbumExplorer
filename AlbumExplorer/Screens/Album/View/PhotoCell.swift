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
    
    override func awakeFromNib() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
    }
    
    
    func configure(with photo: Photo) {
            let url = URL(string: photo.url)
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
}
