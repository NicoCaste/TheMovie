//
//  HeaderView.swift
//  TheMovie
//
//  Created by nicolas castello on 24/08/2022.
//

import Foundation
import UIKit

class HeaderView: UIView {
    lazy var headerTitleLabel: UILabel = UILabel()
    lazy var magnifyinglassImage: UIImageView = UIImageView()
    var goToSearch: (()-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setMagnifyinglassImage()
        self.setHeaderTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setMagnifyinglassImage() {
        magnifyinglassImage.translatesAutoresizingMaskIntoConstraints = false
        guard let image = UIImage(systemName: "magnifyingglass") else { return }
        magnifyinglassImage.image = image
        magnifyinglassImage.tintColor = .white
        self.addSubview(magnifyinglassImage)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToSearchView))
        magnifyinglassImage.isUserInteractionEnabled = true
        magnifyinglassImage.addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            magnifyinglassImage.heightAnchor.constraint(equalToConstant: 20),
            magnifyinglassImage.widthAnchor.constraint(equalToConstant: 22),
            magnifyinglassImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            magnifyinglassImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            magnifyinglassImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])
    }
    
    func setHeaderTitleLabel() {
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.text = "TV Show Reminder"
        self.addSubview(headerTitleLabel)
        
        headerTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        headerTitleLabel.textColor = .white
        headerTitleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            headerTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: magnifyinglassImage.centerYAnchor)
        ])
    }
    
    @objc func goToSearchView() {
        goToSearch?()
    }
}
