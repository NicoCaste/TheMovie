//
//  SearchMovieViewController.swift
//  TheMovie
//
//  Created by nicolas castello on 28/08/2022.
//

import UIKit

protocol SearchMovieViewProtocol {
    func closeSearchMovieView()
}

class SearchMovieView: UIView {
    lazy var textField: UITextField = UITextField()
    lazy var clearInputButton: UIButton = UIButton()
    lazy var closeButton: UIButton = UIButton()
    var viewModel: SearchViewModel?
    var keyboardActive: Bool = false
    var animatedCharacter: [Bool]?
    var firstLoad = true
    var errorLoad: Bool = false
    var delegate: SearchMovieViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setSearchView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSearchView() {
        viewModel = SearchViewModel()
        setCloseButton()
        setCharactersTextField()
        setClearInputButton()
    }
    
    func setCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        closeButton.setTitle("Cancel", for: .normal)
        closeButton.addTarget(self, action: #selector(closeSearchView), for: .touchUpInside)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            closeButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    //MARK: - SetNewArtistsTextField
    func setCharactersTextField() {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        textField.font = UIFont(name: "Noto Sans Myanmar Bold", size: 14)
        let text = " search".capitalized
        let str = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor :UIColor.gray])
        textField.attributedPlaceholder = str
        textField.textColor = .white
        textField.backgroundColor = .darkGray
        setSearchCharacterIcon()
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant:  -10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 28).isActive = true
        textField.layer.cornerRadius = 5
    }
    
    @objc func textFieldDidChange(_ textField: UITextField ) {
        guard let textFieldtext = textField.text else {return}
        viewModel?.findMovieFor(title: textFieldtext)
    }
    
    func setClearInputButton() {
        clearInputButton.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(clearInputButton)
        clearInputButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        clearInputButton.tintColor = .lightGray
        clearInputButton.addTarget(self, action: #selector(clearInput), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            clearInputButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            clearInputButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -10),
            clearInputButton.heightAnchor.constraint(equalToConstant: 20),
            clearInputButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc func clearInput() {
        textField.attributedText = nil
        NotificationCenter.default.post(name: NSNotification.Name.foundMovies, object: nil, userInfo: nil)
    }

    func setSearchCharacterIcon() {
        let magnifyInGlass: UIImageView = UIImageView()
        magnifyInGlass.image = UIImage(systemName: "magnifyingglass")
        textField.leftView = magnifyInGlass
        textField.leftViewMode = .always
        magnifyInGlass.tintColor = .gray
        magnifyInGlass.heightAnchor.constraint(equalToConstant: 20).isActive = true
        magnifyInGlass.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func closeSearchView() {
        delegate?.closeSearchMovieView()
    }
}
