//
//  Movie.swift
//

import Foundation
import UIKit

struct Movie: Codable, Hashable {
    let id: Int?
    let overview: String?
    let releaseDate: String?
    let title: String?
    let backdropPath: String?
    let posterPath: String?
    let genreIds: [Int]?
    var gender: String?
    var subscribed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id,overview,title, gender, subscribed
        case releaseDate = "release_date"
        case  backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
    }
}

struct MovieWithImage: Equatable {
    var movie: Movie?
    var image: UIImage?
    var posterImage: UIImage?
}

