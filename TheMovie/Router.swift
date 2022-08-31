//
//  Router.swift
//  TheMovie
//
//  Created by nicolas castello on 30/08/2022.
//

import Foundation
import UIKit

final class Router {
    static func goToRootView(navigation: UINavigationController) {
        let viewController = HomeViewController()
        navigation.pushViewController(viewController, animated: true)
    }
    
    static func showErrorView(navigation: UINavigationController, message: ErrorMessage) {
        let errorView = ErrorViewController()
        errorView.errorMessage = message
        navigation.pushViewController(errorView, animated: true)
    }
    
    static func goToMovieDetail(navigation: UINavigationController, movie: MovieWithImage) {
        navigation.pushViewController(MovieDetailViewController(movie: movie), animated: true)
    }
}
