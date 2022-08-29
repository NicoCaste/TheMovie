//
//  HomeViewModel.swift
//  TheMovie
//
//  Created by nicolas castello on 26/08/2022.
//

import Foundation

enum NewSubscribe: String {
    case movieSubscribes
    case addMovie
}

enum FoundMovies: String {
    case foundMovie
}

class HomeViewModel: BaseViewModel {
    var movieList: MovieList?
    var genderList: [Genre?] = []
    let key = NewSubscribe.movieSubscribes.rawValue
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(addOrRemoveSubscribe), name: NSNotification.Name.newSubscribe, object: nil)
        getGenreList() 
    }
    
    func getGenreList() {
        callApi.getGendersForFilms(completion: { result in
            switch result {
            case .success(let gendreList):
                self.genderList = gendreList.genres ?? []
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getListMovies(page: Int, completion: @escaping(MovieList) -> Void) {
        let parameters = Parameters(page: page)
        callApi.getDiscoveryMovies(parameters: parameters, completion: { result in
            switch result {
            case .success(let movieList):
                completion(movieList)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getGendreBy(id: Int?) -> String {
        let gender: Genre? = genderList.first(where: { gendre in
            gendre?.id == id
        }) ?? nil
        
        return gender?.name ?? ""
    }
    
    @objc func addOrRemoveSubscribe(notification: Notification) {
        guard let movieSubscribe = notification.userInfo?[NewSubscribe.movieSubscribes.rawValue] as? Movie,
              let addMovie = notification.userInfo?[NewSubscribe.addMovie.rawValue] as? Bool
        else { return }
        
        if addMovie {
            addSubscribe(movie: movieSubscribe)
        } else {
            removeSubscribe(movie: movieSubscribe)
        }
    }
    
    func addSubscribe(movie: Movie) {
        var selectedMovies: [Movie?] = []
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            guard let movies = try? PropertyListDecoder().decode([Movie].self, from: data) else { return }
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()
            selectedMovies = movies
        }
        
        selectedMovies.append(movie)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(selectedMovies), forKey: key)
        UserDefaults.standard.synchronize()
        
        let userInfo: [String : Any] = [NewSubscribe.movieSubscribes.rawValue : movie]
        NotificationCenter.default.post(name: NSNotification.Name.updateMovieSelected, object: nil, userInfo: userInfo)
    }
    
    func removeSubscribe(movie: Movie) {
        var moviesSubscribed: [Movie?] = []
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            guard let movies = try? PropertyListDecoder().decode([Movie].self, from: data) else { return }
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()
            moviesSubscribed = movies
        }
        let findMovie = moviesSubscribed.firstIndex(where: { $0?.id == movie.id })
        if let findMovie = findMovie {
            moviesSubscribed.remove(at: findMovie)
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(moviesSubscribed), forKey: key)
        UserDefaults.standard.synchronize()
        
        let userInfo: [String : Any] = [NewSubscribe.movieSubscribes.rawValue : movie]

        NotificationCenter.default.post(name: NSNotification.Name.updateMovieUnSubscribe, object: nil, userInfo: userInfo)
    }
    
    func findMoviesSubscribed() -> [Movie?]? {
        var moviesSubscribed: [Movie?]?
        UserDefaults.standard.synchronize()
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            moviesSubscribed = try? PropertyListDecoder().decode([Movie].self, from: data)
        }
        
        return moviesSubscribed
        
    }
}
