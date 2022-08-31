//
//  HomeViewController.swift
//  TheMovie
//
//  Created by nicolas castello on 23/08/2022.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var header: HeaderView = HeaderView(frame: self.view.frame)
    lazy var searchView: SearchMovieView = SearchMovieView(frame: self.view.frame)
    lazy var filmList: FilmListView = FilmListView(frame: self.view.frame)
    var activityIndicator: UIActivityIndicatorView?
    
    lazy var coverImageView: UIImageView = UIImageView()
    var viewModel: HomeViewModel?
    var notificationCenter: NotificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.setHidesBackButton(true, animated: true)
        setHeader()
        setFilmList()
        viewModel = HomeViewModel()
        configDismissBoard()
        setCoverImageView()
        setActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationCenter.addObserver(self, selector: #selector(showErrorView(_:)), name: NSNotification.Name.showErrorView, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewWillDisappear(animated)
        notificationCenter.removeObserver(self, name: NSNotification.Name.showErrorView, object: nil)
    }
    
    // MARK: - Set SearchView
    func setSearchView() {
        searchView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchView)
        searchView.delegate = self
        layoutSearchView()
    }
    
    // MARK: - Set Header
    func setHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(header)
        header.goToSearch = goToSearchMovies
        layoutHeader()
    }
    
    // MARK: - Set FilmList
    func setFilmList() {
        filmList.delegate = self
        filmList.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(filmList)
        layoutFilmList()
    }
        
    // MARK: - Go To SearchMovies
    func goToSearchMovies() {
        DispatchQueue.main.async {
            self.header.removeFromSuperview()
            self.setSearchView()
            self.filmList.topAnchor.constraint(equalTo: self.searchView.bottomAnchor).isActive = true
            self.view.layoutSubviews()
        }
    }
    
    func setCoverImageView() {
        coverImageView.image = UIImage(named: "movieNight")
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(coverImageView)
        coverImageView.contentMode = .scaleAspectFill
        layoutCoverImageView()
    }
    
    // MARK: - SetActivityIndicator
    func setActivityIndicator() {
        let x = (view.frame.minX + self.view.frame.maxX) / 2
        let y = (view.frame.minY + self.view.frame.maxY) / 2
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .systemPink
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    // MARK: - StopActivity
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.coverImageView.isHidden = true
            self.header.isHidden = false
            self.filmList.isHidden = false
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
        }
    }
    
    //MARK: - ShowErrorView
    @objc func showErrorView(_ error: Notification) {
        guard let errorMessage = error.userInfo?["errorMessage"] as? ErrorMessage,
              let navigation = self.navigationController else { return }
        Router.showErrorView(navigation: navigation, message: errorMessage)
    }
}

// MARK: - FilmList Delegate
extension HomeViewController: FilmlistViewProtocol {
    // MARK: - ReadyToShow
    func readyToShow() {
        stopActivityIndicator()
    }
    
    // MARK: - Set Movies Subscribed
    func setMoviesSubscribed(completion: @escaping ([Movie?]) -> Void) {
        guard let moviesSelected = viewModel?.findMoviesSubscribed() else { return }
        completion(moviesSelected)
    }
    
    // MARK: - FilmListDelegate
    func getFilmList(page: Int, completion: @escaping (MovieList) -> Void) {
        viewModel?.getListMovies(page: page, completion: { movieList in
            completion(movieList)
        })
    }
    
    // MARK: - Get GendreBy
    func getGendreBy(id: Int?) -> String {
        guard let gender = viewModel?.getGendreBy(id: id) else { return "" }
        return gender
    }
    
    // MARK: - Get Image By
    func getImageBy(url: String, completion: @escaping (Data) -> Void) {
        viewModel?.getImageBy(url: url, completion: { data in
            completion(data)
        })
    }
    
    // MARK: - Go to MovieDetail
    func goToMovieDetail(movie: MovieWithImage) {
        guard let navigationController = navigationController else { return }
        Router.goToMovieDetail(navigation: navigationController, movie: movie)
    }
}

//MARK: SearchMovieView Delegate
extension HomeViewController: SearchMovieViewProtocol {
    // MARK: - Close SearchMovieView
    func closeSearchMovieView() {
        DispatchQueue.main.async {
            self.searchView.removeFromSuperview()
            self.setHeader()
            self.filmList.topAnchor.constraint(equalTo: self.header.bottomAnchor).isActive = true
            self.view.layoutSubviews()
        }
    }
}

// MARK: - Layout
extension HomeViewController {
    
    // MARK: - Layout SearchView
    func layoutSearchView() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    // MARK: - Layout Header
    func layoutHeader() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    // MARK: - Layout FilmList
    func layoutFilmList() {
        NSLayoutConstraint.activate([
            filmList.topAnchor.constraint(equalTo: header.bottomAnchor),
            filmList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            filmList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            filmList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func layoutCoverImageView() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
