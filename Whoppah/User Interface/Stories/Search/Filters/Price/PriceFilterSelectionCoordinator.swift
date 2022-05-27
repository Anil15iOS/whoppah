//
//  PriceFilterSelectionCoordinator.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore

class PriceFilterSelectionCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(minPrice: Money?, maxPrice: Money?, completion: @escaping (((minPrice: Money?, maxPrice: Money?)) -> Void)) {
        let vc = PriceFilterSelectionViewController(nibName: nil, bundle: nil)
        vc.viewModel = PriceFilterSelectionViewModel(coordinator: self, minPrice: minPrice, maxPrice: maxPrice, completion: completion)
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
