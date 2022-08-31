//
//  AlamofireWebService.swift
//  TheMovie
//
//  Created by nicolas castello on 26/08/2022.
//

import Foundation
import Alamofire

final class AlamofireWebService: WebService {
    private let apiKey: String = ApiKeyManager.getMovieDBApiKey() ?? ""
    
    func get(_ urlString: String, parameters: Parameters, completion: @escaping (Result<Data, Error>) -> Void) {
        //I dont Know why bearerToken dosen't work in the api. in theory the api support it -> https://developers.themoviedb.org/3/getting-started/authentication
      //  let headers: HTTPHeaders = [.authorization(bearerToken: apiKey), .contentType("application/json")]
        let url = urlString + "?api_key=" + apiKey
        AF.request(url, parameters: parameters).responseData { response in
           
            if let data = response.value {
                if response.response?.statusCode == 200 {
                    completion(.success(data))
                }
            } else if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.failure(TheMovieError.unexpected(code: 0)))
            }
        }
    }
    
    func post(_ urlString: String, parameters: Parameters, completion: @escaping (Result<Data, Error>) -> Void) {
        let encoder = JSONEncoder() // create encoder to encode your request parameters to Data
        guard let data = try? encoder.encode(parameters),
              let url = URL(string: urlString)
        else { return }
        
        var urlRequest = URLRequest(url: url)
        let headers: HTTPHeaders = [.authorization(bearerToken: apiKey), .contentType("application/json")]
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        urlRequest.headers = headers
        urlRequest.httpMethod = "POST"
        
        AF.request(urlRequest).responseData { response in
            if let data = response.value {
                completion(.success(data))
            } else if let error = response.error {
                completion(.failure(error))
            } else {
                print("error desconocido")
            }
        }
    }
}


enum TheMovieError: Error {
    // Throw when an invalid password is entered
    case invalidPassword
    // Throw when an expected resource is not found
    case notFound
    // Throw in all other cases
    case unexpected(code: Int)
}
