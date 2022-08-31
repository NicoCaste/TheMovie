//
//  MovieDetailViewController.swift
//  TheMovie
//
//  Created by nicolas castello on 26/08/2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    lazy var backImageTarget: UIImageView = UIImageView()
    lazy var imageView: UIImageView = UIImageView()
    lazy var movieTitleLabel: UILabel = UILabel()
    lazy var releaseDateLabel: UILabel = UILabel()
    lazy var subscribeButton: UIButton = UIButton()
    lazy var detailTitleLabel: UILabel = UILabel()
    lazy var detailDescriptionLabel: UILabel = UILabel()
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var contentView: UIView = UIView()
    lazy var filterColorView: UIView = UIView()
    lazy var contentViewBackground: UIImageView = UIImageView()
    
    var movie: MovieWithImage
    var viewModel: MovieDetailViewModel?
    var notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        viewModel = MovieDetailViewModel()
        setScrollView()
        setContentView()
        setCustomBackButton()
        setImageView()
        setMovieTitleLabel()
        setReleaseDateLabel()
        setSubscribeButton()
        setDetailTitleLabel()
        setDetailDescriptionLabel()
    }
    
    init(movie: MovieWithImage) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum SubscribedTitle: String {
        case subscribed = "subscribed"
        case unSubscribe = "subscribe"
    }
    
    // MARK: - MovieImage
    func setMovieImage() {
        let imageName = movie.movie?.posterPath ?? ""
        let url = ApiCallerHelper.getUrlForImage(imageName: imageName)
        setImageIn(iView: imageView, url: url, grayImage: false) { [weak self] image in
            self?.movie.posterImage = image
            guard let color = image.averageColor else { return }
            self?.setColorFilterView(color: color.withAlphaComponent(0.8))
        }
    }
    
    // MARK: - closeView
    @objc func closeView(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - subscribeFilms
    @objc func subscribeFilms() {
        let subscribed = movie.movie?.subscribed ?? false
        movie.movie?.subscribed = !subscribed
        subscribeButton.setTitle(SubscribedTitle.unSubscribe.rawValue.localized(), for: .normal)
        setSubscribeButton()
        
        guard let movieSubscribe = movie.movie else { return }
        let userInfo: [String : Any] = [NewSubscribe.movieSubscribes.rawValue : movieSubscribe,
                        NewSubscribe.addMovie.rawValue: !subscribed]
        
        NotificationCenter.default.post(name: NSNotification.Name.newSubscribe, object: nil, userInfo: userInfo)
    }
    
    // MARK: - SubscribeButtonContent
    func setSubscribeButtonContent() {
        guard let subscribed = movie.movie?.subscribed else {
            subscribeButton.setTitleColor(.white, for: .normal)
            subscribeButton.backgroundColor = .clear
            subscribeButton.setTitle(SubscribedTitle.unSubscribe.rawValue.localized(), for: .normal)
            return
        }
        
        let color = (subscribed) ? filterColorView.backgroundColor : .white
        let title = (subscribed) ? SubscribedTitle.subscribed.rawValue.localized(): SubscribedTitle.unSubscribe.rawValue.localized()
        
        subscribeButton.setTitleColor(color, for: .normal)
        subscribeButton.backgroundColor = (subscribed) ? .white : .clear
        subscribeButton.setTitle(title, for: .normal)
    }

    //MARK: - SetImageInView
    func setImageIn(iView: UIImageView, url: String, grayImage: Bool, completion: @escaping ((UIImage)-> Void)) {
        viewModel?.getImageBy(url: url, completion: { data in
            guard let imageData = UIImage(data: data) else { return }
            let image = (grayImage) ? imageData.grayscale() : imageData
            DispatchQueue.main.async {
                iView.image = image
                completion(image)
            }
        })
    }
}

//MARK: ConfigViews
extension MovieDetailViewController {
    //MARK: - Set ScrollView
    func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        layoutScrollView()
    }
    
    //MARK: - Set ContentView
    func setContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        setBackgroundImage()
        layoutContentView()
    }
    
    //MARK: - Set ImageView
    func setImageView() {
        setMovieImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        layoutImageView()
    }
    
    //MARK: - Set BackgroundImage
    func setBackgroundImage() {
        contentViewBackground.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentViewBackground)
        self.view.sendSubviewToBack(contentViewBackground)
        
        contentViewBackground.contentMode =  .scaleAspectFill
        contentViewBackground.clipsToBounds = true
        
        if let image = movie.image?.grayscale() {
            contentViewBackground.image = image
        } else {
            let url = ApiCallerHelper.getUrlForImage(imageName:  movie.movie?.backdropPath ?? "")
            setImageIn(iView: contentViewBackground, url: url, grayImage: true) {[weak self] image in
                self?.movie.image = image
            }
        }
        layoutBackgroundImage()
    }
    
    //MARK: - Set ColorFilterView
    func setColorFilterView(color: UIColor) {
        filterColorView .translatesAutoresizingMaskIntoConstraints = false
        contentViewBackground.addSubview(filterColorView)
        filterColorView .backgroundColor = color
        setSubscribeButtonContent()
        layoutFilterColorView()
    }
    
    //MARK: - Set CustomBackButton
    func setCustomBackButton() {
        backImageTarget.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backImageTarget)
        let image: UIImage = UIImage(systemName: "arrow.backward.circle.fill") ?? UIImage()
        backImageTarget.image = image
        backImageTarget.tintColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeView(tapGestureRecognizer:)))
        backImageTarget.isUserInteractionEnabled = true
        backImageTarget.addGestureRecognizer(tapGesture)
        layoutCustomBackButton()
    }
    
    //MARK: - Set MovieTitleLabel
    func setMovieTitleLabel() {
        movieTitleLabel.text = movie.movie?.title ?? ""
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieTitleLabel)
        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.textColor = .white
        movieTitleLabel.textAlignment = .center
        movieTitleLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 24)
        layoutMovieTitleLabel()
    }
    
    //MARK: - ReleaseDateLabel
    func setReleaseDateLabel() {
        releaseDateLabel.text = movie.movie?.releaseDate?.getDateFormatString(format: .year)
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.textColor = .white
        releaseDateLabel.textAlignment = .center
        releaseDateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(20)
        layoutReleaseDateLabel()
    }
    
    //MARK: - SubscribeButton
    func setSubscribeButton() {
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subscribeButton)
        setSubscribeButtonContent()
        subscribeButton.titleLabel?.font = UIFont(name: "Noto Sans Myanmar Bold", size: 20)
        subscribeButton.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        subscribeButton.layer.cornerRadius = 45/2
        subscribeButton.layer.borderWidth = 2
        subscribeButton.addTarget(self, action: #selector(subscribeFilms), for: .touchUpInside)
        layoutSubscribeButton()
    }
    
    //MARK: - DetailTitleLabel
    func setDetailTitleLabel() {
        detailTitleLabel.text = "Overview".uppercased()
        detailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailTitleLabel)
        detailTitleLabel.textColor = .black
        detailTitleLabel.textAlignment = .left
        detailTitleLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 18)
        layoutDetailTitleLabel()
    }
    
    // MARK: - DetailDescriptionLabel
    func setDetailDescriptionLabel() {
        detailDescriptionLabel.text = movie.movie?.overview ?? ""
        detailDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailDescriptionLabel)
        detailDescriptionLabel.textColor = .white
        detailDescriptionLabel.textAlignment = .left
        detailDescriptionLabel.numberOfLines = 0
        detailDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .body).withSize(18)
        layoutDetailDescriptionLabel()
    }
}


//MARK: Layout
extension MovieDetailViewController {
    // MARK: - Layout ScrollView
    func layoutScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Layout ContentView
    func layoutContentView() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    // MARK: Layout ImageView
    func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 43),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 273),
            imageView.widthAnchor.constraint(equalToConstant: 182)
        ])
    }
    
    //MARK: - Layout BackgroundImage
    func layoutBackgroundImage() {
        NSLayoutConstraint.activate([
            contentViewBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentViewBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentViewBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentViewBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // MARK: - Layout FilterColorView
    func layoutFilterColorView() {
        NSLayoutConstraint.activate([
            filterColorView.leadingAnchor.constraint(equalTo: contentViewBackground.leadingAnchor),
            filterColorView.trailingAnchor.constraint(equalTo: contentViewBackground.trailingAnchor),
            filterColorView.topAnchor.constraint(equalTo: contentViewBackground.topAnchor),
            filterColorView.bottomAnchor.constraint(equalTo: contentViewBackground.bottomAnchor)
        ])
    }
    
    // MARK: - Layout MovieTitleLabel
    func layoutMovieTitleLabel() {
        NSLayoutConstraint.activate([
            movieTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 23),
            movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35)
        ])
    }
    
    // MARK: - Layout ReleaseDateLabel
    func layoutReleaseDateLabel() {
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 2),
            releaseDateLabel.centerXAnchor.constraint(equalTo: movieTitleLabel.centerXAnchor)
        ])
    }
    
    // MARK: - Layout SubscribeButton
    func layoutSubscribeButton() {
        NSLayoutConstraint.activate([
            subscribeButton.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
            subscribeButton.centerXAnchor.constraint(equalTo: releaseDateLabel.centerXAnchor),
            subscribeButton.heightAnchor.constraint(equalToConstant: 45),
            subscribeButton.widthAnchor.constraint(equalToConstant: 195)
        ])
    }
    
    // MARK: - Layout DetailTitleLabel
    func layoutDetailTitleLabel() {
        NSLayoutConstraint.activate([
            detailTitleLabel.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 45),
            detailTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Layout DetailDescriptionLabel
    func layoutDetailDescriptionLabel() {
        NSLayoutConstraint.activate([
            detailDescriptionLabel.topAnchor.constraint(equalTo: detailTitleLabel.bottomAnchor, constant: 10),
            detailDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Layout CustomBackButton
    func layoutCustomBackButton() {
        NSLayoutConstraint.activate([
            backImageTarget.heightAnchor.constraint(equalToConstant: 28),
            backImageTarget.widthAnchor.constraint(equalToConstant: 28),
            backImageTarget.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            backImageTarget.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 25)
        ])
    }
}
