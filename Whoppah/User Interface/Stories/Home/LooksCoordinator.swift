//
//  LooksCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 25/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore
import WhoppahModel

class LooksCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(repository: LooksRepository) {
        let looksVC: LooksViewController = UIStoryboard.storyboard(storyboard: .home).instantiateViewController()
        let viewModel = LooksViewModel(repository: repository,
                                       coordinator: self)
        looksVC.viewModel = viewModel
        looksVC.coordinator = self
        navigationController.pushViewController(looksVC, animated: true)
    }

    func openSearch(text: String? = nil, sortType: GraphQL.SearchSort = .created, sortOrder: GraphQL.Ordering = .desc) {
        let input = SearchProductsInput(query: text,
                                        sort: sortType.toWhoppahModel,
                                        order: sortOrder.toWhoppahModel)
        Navigator().navigate(route: Navigator.Route.search(input: input))
    }

    func openSearchByPhoto() {
        Navigator().navigate(route: Navigator.Route.searchByPhoto)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
