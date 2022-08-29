//
//  HomeViewController.swift
//  TheMovie
//
//  Created by nicolas castello on 23/08/2022.
//

import UIKit

class HomeViewController: UIViewController, FilmlistViewProtocol, SearchMovieViewProtocol {
    var coordinator: MainProtocolCoordinator?
    lazy var header: HeaderView = HeaderView(frame: self.view.frame)
    lazy var searchView: SearchMovieView = SearchMovieView(frame: self.view.frame)
    lazy var filmList: FilmListView = FilmListView(frame: self.view.frame)
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setHeader()
        setFilmList()
        viewModel = HomeViewModel()
        configDismissBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setSearchView() {
        searchView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchView)
        searchView.delegate = self
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func setHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(header)
        header.goToSearch = goToSearchMovies
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func setFilmList() {
        filmList.delegate = self
        filmList.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(filmList)
        
        NSLayoutConstraint.activate([
            filmList.topAnchor.constraint(equalTo: header.bottomAnchor),
            filmList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            filmList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            filmList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    // MARK: - FilmListDelegate
    func getFilmList(page: Int, completion: @escaping (MovieList) -> Void) {
        viewModel?.getListMovies(page: page, completion: { movieList in
            completion(movieList)
        })
    }
    
    func getGendreBy(id: Int?) -> String {
        guard let gender = viewModel?.getGendreBy(id: id) else { return "" }
        return gender 
    }
    
    func getImageBy(url: String, completion: @escaping (Data) -> Void) {
        viewModel?.getImageBy(url: url, completion: { data in
            completion(data)
        })
    }
    
    func goToMovieDetail(movie: MovieWithImage) {
        self.navigationController?.pushViewController(MovieDetailViewController(movie: movie), animated: true)
    }
    
    func goToSearchMovies() {
        DispatchQueue.main.async {
            self.header.removeFromSuperview()
            self.setSearchView()
            self.filmList.topAnchor.constraint(equalTo: self.searchView.bottomAnchor).isActive = true
            self.view.layoutSubviews()
        }
    }
    
    func setMoviesSubscribed(completion: @escaping ([Movie?]) -> Void) {
        guard let moviesSelected = viewModel?.findMoviesSubscribed() else { return }
        completion(moviesSelected)
    }
    
    func closeSearchMovieView() {
        DispatchQueue.main.async {
            self.searchView.removeFromSuperview()
            self.setHeader()
            self.filmList.topAnchor.constraint(equalTo: self.header.bottomAnchor).isActive = true
            self.view.layoutSubviews()
        }
    }
}
