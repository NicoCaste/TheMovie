//
//  ApiKeyManager.swift
//  TheMovie
//
//  Created by nicolas castello on 26/08/2022.
//

import Foundation

final class ApiKeyManager {
    static func getMovieDBApiKey() -> String? {
         return  Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    }
}
