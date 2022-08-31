
//
//  FilmListView.swift
//  TheMovie
//
//  Created by nicolas castello on 24/08/2022.
//

import Foundation
import UIKit

protocol FilmlistViewProtocol: NSObjectProtocol {
    func getFilmList(page: Int, completion:@escaping(MovieList) -> Void)
    func setMoviesSubscribed(completion: @escaping ([Movie?]) -> Void)
    func getGendreBy(id: Int?) -> String
    func getImageBy(url: String, completion:@escaping(Data) -> Void)
    func goToMovieDetail(movie: MovieWithImage)
    func readyToShow()
}

enum FilmsSections: String {
    case SUSCRIPTAS
    case TODAS
}

class FilmListView: UIView, UITableViewDelegate, UITableViewDataSource {
    lazy var tableView: UITableView = UITableView()
    let notificationCenter = NotificationCenter.default
    var filmListSections: [String] = [FilmsSections.TODAS.rawValue]
    var allMovies: [MovieWithImage?] = []
    var currentMovies: [MovieWithImage?] = []
    var moviesSubscribed: [MovieWithImage] = []
    var delegate: FilmlistViewProtocol?
    var lastMovie: Movie?
    var firstLoad: Bool = true
    var nextPage: Int = 1
    var indexPaths: [IndexPath] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        tableView.backgroundColor = .black
        setTableView()
        //setActivityIndicator()
        notificationCenter.addObserver(self, selector: #selector(foundMoviesForInput), name: NSNotification.Name.foundMovies, object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateMoviesSubscribe), name: NSNotification.Name.updateMovieSelected, object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateMovieUnSubscribe), name: NSNotification.Name.updateMovieUnSubscribe, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationCenter.removeObserver(self, name: NSNotification.Name.updateMovieSelected, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.updateMovieUnSubscribe, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.foundMovies, object: nil)
    }
    
    // MARK: - Get Film List
    func getFilmList(page: Int) {
        delegate?.getFilmList(page: page, completion: { [weak self] movieList in
            guard let self = self,
                  let results = movieList.results
            else { return }
            
            self.nextPage += 1
            self.setMovieList(results: results)
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else { return }
                if self.nextPage <= 2 {
                    self.getFilmList(page: self.nextPage)
                }
            }
        })
    }
    
    // MARK: - Found Movies
    @objc func foundMoviesForInput(nofication: Notification) {
        if currentMovies.isEmpty {
            currentMovies = allMovies
        }
        allMovies = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        guard let films = nofication.userInfo?[FoundMovies.foundMovie.rawValue] as? MovieList
        else {
            allMovies = currentMovies
            tableView.reloadData()
            return
        }
        setMovieList(results: films.results ?? [])
    }
    
    // MARK: - Set Movie List
    func setMovieList(results: [Movie]) {
        for movie in results {
            var newMovie = movie
            newMovie.subscribed = checkandUpdateSubscriptionStatusFor(movie: newMovie)
            allMovies.append(MovieWithImage(movie: newMovie))
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            for movie in self.allMovies {
                guard let movie = movie else { return }
                self.setMovieImage(movie: movie, section: .TODAS)
            }
        }
    }
    
    // MARK: - Set Movie Subscribed
    func setMoviesSubscribed() {
        delegate?.setMoviesSubscribed(completion: { [weak self] movies in
            guard let self = self else { return }
            for movie in movies {
                guard let movie = movie else { return }
                var movieSubscribed = movie
                movieSubscribed.subscribed = true
                self.moviesSubscribed.append(MovieWithImage(movie:movieSubscribed))
            }
            
            self.addSubscribeSection()
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                for movie in self.moviesSubscribed {
                    self.setMovieImage(movie: movie, section: .SUSCRIPTAS)
                }
            }
        })
    }
    
    // MARK: - Change Subscription
    func changeSubscriptionStatusFor(movie: Movie, to subscribed: Bool) {
        if let index = allMovies.firstIndex(where: { film in
            film?.movie?.id == movie.id
        }) {
            allMovies[index]?.movie?.subscribed = subscribed
        }
    }
    
    // MARK: - Check Subscription
    func checkandUpdateSubscriptionStatusFor(movie: Movie) -> Bool {
        var isSubscribed = false
        if moviesSubscribed.contains(where: { film in
            film.movie?.id == movie.id
        }) {
            isSubscribed = true
        }
        
        return isSubscribed
    }
    
    // MARK: - Update Subscriptions
    @objc func updateMoviesSubscribe(notification: Notification) {
        guard let movie = notification.userInfo?[NewSubscribe.movieSubscribes.rawValue] as? Movie else { return }
        addSubscribeSection()
        var movieSubscribed = movie
        movieSubscribed.subscribed = true
        changeSubscriptionStatusFor(movie: movie, to: true)
        moviesSubscribed.append(MovieWithImage(movie: movieSubscribed))
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            for movie in self.moviesSubscribed {
                self.setMovieImage(movie: movie, section: .SUSCRIPTAS)
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Update UnSubscribes
    @objc func updateMovieUnSubscribe(notification: Notification) {
        guard let movie = notification.userInfo?[NewSubscribe.movieSubscribes.rawValue] as? Movie else { return }
        
        if let index = moviesSubscribed.firstIndex(where:{ movieSubscribe in
            movieSubscribe.movie?.id == movie.id
        }) {
            moviesSubscribed.remove(at: index)
        }
        
        if moviesSubscribed.isEmpty {
            removeSubscribeSection()
        }
        
        changeSubscriptionStatusFor(movie: movie, to: false)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Add Subs Section
    func addSubscribeSection() {
        if !filmListSections.contains(FilmsSections.SUSCRIPTAS.rawValue) {
            filmListSections.insert(FilmsSections.SUSCRIPTAS.rawValue, at: 0)
        }
    }
    
    // MARK: - Remove Subs Section
    func removeSubscribeSection() {
        if let index = filmListSections.firstIndex(of: FilmsSections.SUSCRIPTAS.rawValue) {
            filmListSections.remove(at: index)
        }
    }
    
    // MARK: - SetMovieImage
    func setMovieImage(movie: MovieWithImage, section: FilmsSections) {
        if movie.image == nil {
            let imageName = movie.movie?.backdropPath
            let url = ApiCallerHelper.getUrlForImage(imageName: imageName ?? "")
            DispatchQueue.global(qos: .userInitiated).async {
                self.delegate?.getImageBy(url: url) { dataImage in
                    guard let image = UIImage(data: dataImage),
                          let id = movie.movie?.id
                    else { return }
                    self.saveMovieImage(image: image, id: id , section: section)
                }
            }
        }
    }
    
    func saveMovieImage(image: UIImage, id: Int, section: FilmsSections) {
        switch section {
        case .SUSCRIPTAS:
            guard let index = moviesSubscribed.firstIndex(where: { movie in
                movie.movie?.id == id
            }) else { return }
            moviesSubscribed[index].image = image
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .TODAS:
            guard let index = allMovies.firstIndex(where: { movie in
                movie?.movie?.id == id
            }) else { return }
            if index < allMovies.count {
                allMovies[index]?.image = image.grayscale()
                if index == allMovies.count / 2 {
                    DispatchQueue.main.async {
                        self.delegate?.readyToShow()
                        self.tableView.reloadData()
                    }
                }                }
        }
    }
}

// MARK: - TableView Delegate
extension FilmListView {
    
    // MARK: - Number Of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        filmListSections.count
    }
    
    // MARK: - Header View
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .lightGray
        }
    }
    
    // MARK: - Header Name
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        filmListSections[section]
    }
    
    // MARK: - Number Of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if firstLoad {
            setMoviesSubscribed()
            getFilmList(page: 1)
            firstLoad = false
        }
        
        if filmListSections[section] == FilmsSections.SUSCRIPTAS.rawValue {
            return 1
        } else if filmListSections[section] == FilmsSections.TODAS.rawValue {
            return allMovies.count
        }
        
        return 0
    }
    
    // MARK: - Cell For Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = UITableViewCell()
        emptyCell.backgroundColor = .darkGray
        
        if filmListSections[indexPath.section] == FilmsSections.SUSCRIPTAS.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSubscribedTableViewCell") as? MovieSubscribedTableViewCell
            cell?.populate(movies: moviesSubscribed)
            cell?.collectionView?.delegate = self
            cell?.collectionView?.dataSource = self
            return cell ?? emptyCell
        }
        
        if filmListSections[indexPath.section] == FilmsSections.TODAS.rawValue {
            var movieWithImage: MovieWithImage? = allMovies[indexPath.row]
            let gender = movieWithImage?.movie?.genreIds?.first
            let genderName = delegate?.getGendreBy(id: gender)
            movieWithImage?.movie?.gender = genderName
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell") as? MovieListTableViewCell
            cell?.delegate = self
            cell?.populate(movie: movieWithImage)
            
            return cell ?? emptyCell
        }
        return emptyCell
    }
    
    // MARK: - Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieSelected = allMovies[indexPath.row] else { return }
        delegate?.goToMovieDetail(movie: movieSelected)
    }
}

// MARK: - Movie List Delegate
extension FilmListView: MovieCardProtocol {
    
    // MARK: - getImage
    func getImage(id: Int?, imageName: String?, section: FilmsSections, completion: @escaping (UIImage?) -> Void) {
        guard let imageName = imageName,
              let id = id
        else { return }
        let url = ApiCallerHelper.getUrlForImage(imageName: imageName)
        DispatchQueue.global(qos: .userInitiated).async {
            self.delegate?.getImageBy(url: url) { dataImage in
                guard let image = UIImage(data: dataImage) else { return }
                self.saveMovieImage(image: image, id: id, section: section)
                completion(image.grayscale())
            }
        }
    }
}

// MARK: - Config Views
extension FilmListView {
    // MARK: - TableView
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: "MovieListTableViewCell")
        tableView.register(MovieSubscribedTableViewCell.self, forCellReuseIdentifier: "MovieSubscribedTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        layoutTableView()
    }
}

// MARK: - Collection View Delegate
extension FilmListView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Number Of Items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.reloadData()
        return moviesSubscribed.count
    }
    
    // MARK: - Cell For Item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieSubscribedCollectionViewCell", for: indexPath) as? MovieSubscribedCollectionViewCell
        let image = moviesSubscribed[indexPath.row].image
        cell?.populate(image: image)
        return cell ?? UICollectionViewCell()
    }
    
    // MARK: - did Select Item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieSelected = moviesSubscribed[indexPath.row]
        delegate?.goToMovieDetail(movie: movieSelected)
    }
}

// MARK: - Layout
extension FilmListView {
    // MARK: - TableView
    func layoutTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
