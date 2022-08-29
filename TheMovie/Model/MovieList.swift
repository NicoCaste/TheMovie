//
//  MovieList.swift
//

import Foundation

struct MovieList: Decodable {
    let results: [Movie]?
    let page: Int?
}
