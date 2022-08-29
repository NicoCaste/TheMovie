//
//  WebServiceProtocol.swift
//  TheMovie
//
//  Created by nicolas castello on 23/08/2022.
//

import Foundation
enum HttpMethod: String {
    case get
    case post
}

protocol WebService {
    func post(_ urlString: String, parameters:  Parameters, completion: @escaping(Result<Data, Error>) -> Void)
    func get(_ urlString: String, parameters:  Parameters, completion: @escaping(Result<Data, Error>) -> Void)
}

struct Parameters: Codable {
    var page: Int?
    var query: String?
}

