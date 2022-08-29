//
//  ApiCaller.swift
//  TheMovie
//
//  Created by nicolas castello on 26/08/2022.
//

import Foundation

class ApiCallerHelper {
    enum CallerUrl: String {
        case theMovieApi = "https://api.themoviedb.org/3/"
        case getImage = "https://image.tmdb.org/t/p/original"
    }

    static private func makeURL(for baseUrl: CallerUrl, url: String) -> String {
        return baseUrl.rawValue + url
    }
    
    static func getUrlForDiscoveryMovies() -> String {
        makeURL(for: .theMovieApi, url: "discover/movie")
    }
    
    static func getUrlForImage(imageName: String) -> String {
        makeURL(for: .getImage, url: imageName)
    }
    
    static func getUrlForGenderList() -> String {
        makeURL(for: .theMovieApi, url: "genre/movie/list")
    }
    
    static func getUrlForSearchQuery() -> String {
        makeURL(for: .theMovieApi, url: "search/movie")
    }
}
