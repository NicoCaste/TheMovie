//
//  NSNotificationExtension.swift
//  TheMovie
//
//  Created by nicolas castello on 27/08/2022.
//

import Foundation

extension NSNotification.Name {
    static var newSubscribe: NSNotification.Name {
        return .init(rawValue: "newSubscribe")
    }
    
    static var updateMovieSelected: NSNotification.Name {
        return .init(rawValue: "updateMovieSelected")
    }
    
    static var updateMovieUnSubscribe: NSNotification.Name {
        return .init(rawValue: "updateMovieUnSubscribe")
    }
    
    static var foundMovies: NSNotification.Name {
        return .init(rawValue: "foundMovies")
    }
}
