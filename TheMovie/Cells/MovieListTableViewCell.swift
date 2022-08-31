//
//  MovieListTableViewCell.swift
//  TheMovie
//
//  Created by nicolas castello on 26/08/2022.
//

import UIKit

protocol MovieCardProtocol {
    func getImage(id: Int?, imageName: String?, section: FilmsSections, completion: @escaping (UIImage?) -> Void)
}

class MovieListTableViewCell: UITableViewCell {
    lazy var greyView: UIView = UIView()
    lazy var movieImageView: UIImageView = UIImageView()
    lazy var movieTitleLabel: UILabel = UILabel()
    lazy var movieCategorieView: UIView = UIView()
    lazy var movieCategorieLabel: UILabel = UILabel()
    var movie: MovieWithImage?
    var delegate: MovieCardProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(movie: MovieWithImage?) {
        self.backgroundColor = .black
        self.movie = movie
        setMovieImage()
        setGreyView()
        setTitleConfig()
        setCategoryImageView()
        setCateogryName()
    }
    
    func setMovieImage() {
        if let image = movie?.image {
            setMovieImage(image: image)
        } else {
            delegate?.getImage(id: movie?.movie?.id, imageName: movie?.movie?.backdropPath, section: .TODAS, completion: { [weak self] movieImage in
                self?.setMovieImage(image: movieImage)
            })
        }
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieImageView)
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 7
        layoutMovieImageView()
    }
    
    func setMovieImage(image: UIImage?) {
        guard let image = image else { return }
        DispatchQueue.main.async {
            self.movieImageView.image = image
        }
    }
    
    func setGreyView() {
        //gray sight is put on to help read on white backgrounds
        greyView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.addSubview(greyView)
        greyView.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        greyView.layer.masksToBounds = true
        greyView.layer.cornerRadius = 7
        layoutGreyView()
    }
    
    func setTitleConfig() {
        let title = movie?.movie?.title ?? ""
        movieTitleLabel.text = title.capitalized
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieTitleLabel)
        movieTitleLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 24)
        movieTitleLabel.textColor = .white
        movieTitleLabel.textAlignment = .left
        layoutMovieTitleLabel()
    }
    
    func setCategoryImageView() {
        movieCategorieView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieCategorieView)
        movieCategorieView.layer.masksToBounds = true
        movieCategorieView.layer.cornerRadius = 4
        movieCategorieView.backgroundColor = .init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        layoutMovieCategorieView()
    }
    
    func setCateogryName() {
        let category = movie?.movie?.gender ?? ""
        movieCategorieLabel.text = category.uppercased()
        movieCategorieLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieCategorieLabel)
        movieCategorieLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 14)
        movieCategorieLabel.textColor = .white
        movieCategorieLabel.textAlignment = .center
        layoutMovieCategorieLabel()

    }
}

// MARK: Layout
extension MovieListTableViewCell {
    
    //MARK: - Layout MovieImageView
    func layoutMovieImageView() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    //MARK: - Layout GreyView
    func layoutGreyView() {
        NSLayoutConstraint.activate([
            greyView.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor),
            greyView.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor),
            greyView.topAnchor.constraint(equalTo: movieImageView.topAnchor),
            greyView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor)
        ])
    }
    //MARK: - Layout MovieTitleLabel
    func layoutMovieTitleLabel() {
        NSLayoutConstraint.activate([
            movieTitleLabel.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 15),
            movieTitleLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -15),
            movieTitleLabel.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -15)
        ])
    }
    
    //MARK: - Layout MovieCategorieView
    func layoutMovieCategorieView() {
        NSLayoutConstraint.activate([
            movieCategorieView.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -10),
            movieCategorieView.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 10),
        ])
    }
    
    //MARK: - Layout MovieCategorieLabel
    func layoutMovieCategorieLabel() {
        NSLayoutConstraint.activate([
            movieCategorieLabel.topAnchor.constraint(equalTo: movieCategorieView.topAnchor, constant: 5),
            movieCategorieLabel.bottomAnchor.constraint(equalTo: movieCategorieView.bottomAnchor),
            movieCategorieLabel.leadingAnchor.constraint(equalTo: movieCategorieView.leadingAnchor, constant: 5),
            movieCategorieLabel.trailingAnchor.constraint(equalTo: movieCategorieView.trailingAnchor, constant: -5)
        ])
    }
}
