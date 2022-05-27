//
//  FavoritesCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

class FavoritesCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(withNavBar: Bool) {
        let favoritesVC: FavoritesViewController = UIStoryboard.storyboard(storyboard: .favorites).instantiateViewController()
        let favoritesRepo = FavoritesRepositoryImpl()
        favoritesVC.viewModel = FavoritesViewModel(coordinator: self, repo: favoritesRepo)
        favoritesVC.withNavBar = withNavBar
        navigationController.pushViewController(favoritesVC, animated: withNavBar)
    }

    func openAd(_ viewModel: AdViewModel) {
        Navigator().navigate(route: Navigator.Route.ad(id: viewModel.product.id))
    }
}
