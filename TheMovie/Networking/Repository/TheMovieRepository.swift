//
//  TheMovieRepository.swift
//  TheMovie
//
//  Created by nicolas castello on 26/08/2022.
//

import Foundation

final class TheMovieApiRepository {
    var webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func getDiscoveryMovies(parameters: Parameters, completion:@escaping(Result<MovieList, Error>) -> Void) {
        let url = ApiCallerHelper.getUrlForDiscoveryMovies()
        
        webService.get(url, parameters: parameters, completion: { result in
            switch result {
            case .success(let data):
                do {
                    let movieList = try JSONDecoder().decode(MovieList.self, from: data)
                    completion(.success(movieList))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func getGendersForFilms(completion: @escaping(Result<GenreList, Error>) -> Void) {
        let url = ApiCallerHelper.getUrlForGenderList()
        webService.get(url, parameters: Parameters(), completion: { result in
            switch result {
            case .success(let data):
                do {
                    let genderList = try JSONDecoder().decode(GenreList.self, from: data)
                    completion(.success(genderList))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func getDataForImage(url: String, completion: @escaping(Result<Data, Error>) -> Void) {
        webService.get(url, parameters: Parameters(), completion: { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(url)
                completion(.failure(error))
            }
        })
    }
    
    func findMovies(parameters: Parameters, completion:@escaping(Result<MovieList, Error>) -> Void) {
        let url = ApiCallerHelper.getUrlForSearchQuery()
        webService.get(url, parameters: parameters, completion: { result in
            switch result {
            case .success(let data):
                do {
                    let movieList = try JSONDecoder().decode(MovieList.self, from: data)
                    completion(.success(movieList))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
