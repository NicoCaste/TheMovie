//
//  CoordinatorProtocol.swift
//  TheMovie
//
//  Created by nicolas castello on 23/08/2022.
//

import Foundation
import UIKit

protocol MainProtocolCoordinator {
    var childCoordinators: [MainProtocolCoordinator] { get set }
    var navigationController: UINavigationController { get set }
    func goToMovieDetail(movie: Movie?)
    func start()
}
