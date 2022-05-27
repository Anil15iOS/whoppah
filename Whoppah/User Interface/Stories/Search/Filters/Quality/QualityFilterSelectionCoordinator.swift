//
//  QualityFilterSelectionCoordinator.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import WhoppahDataStore

class QualityFilterSelectionCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(selectedQuality: GraphQL.ProductQuality?, completion: @escaping ((GraphQL.ProductQuality) -> Void)) {
        let vc = QualityFilterSelectionViewController(nibName: nil, bundle: nil)
        vc.viewModel = QualityFilterSelectionViewModel(coordinator: self, selectedQuality: selectedQuality, completion: completion)
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
