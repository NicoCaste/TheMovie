//
//  MovieSubscribedCollectionViewCell.swift
//  TheMovie
//
//  Created by nicolas castello on 27/08/2022.
//

import UIKit

class MovieSubscribedCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = UIImageView()
    
    func populate(image: UIImage?) {
        setImageView(image: image)
    }
    
    //MARK: - ImageView
    func setImageView(image: UIImage?) {
        guard let image = image else { return }
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        layoutImageView()
    }
    
    func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
