//
//  MainAppCoordinator.swift
//  TheMovie
//
//  Created by nicolas castello on 23/08/2022.
//

import Foundation
import UIKit

class MainAppCoordinator: MainProtocolCoordinator {
    func goToMovieDetail(movie: Movie?) {
        print("gorodo trolor ")
    }
    
    var childCoordinators = [MainProtocolCoordinator]()
    var navigationController: UINavigationController
    var menuOpened = false
    var rootView: UIViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let viewController = rootView else { return }
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func goToHome() {
        self.navigationController.popToRootViewController(animated: true)
    }

    func goToBack() {
        self.navigationController.popViewController(animated: false)
    }
    
    func getRootView() -> UIViewController {
        let viewController = HomeViewController()
        viewController.coordinator = self
        rootView = viewController
        return rootView!
    }
}
