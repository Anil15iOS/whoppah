//
//  DistanceFilterSelectionCoordinator.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import WhoppahCore

class DistanceFilterSelectionCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(address: LegacyAddressInput?, radiusKm: Int, completion: @escaping (((address: LegacyAddressInput?, radiusKm: Int)) -> Void)) {
        let vc = DistanceFilterSelectionViewController(nibName: nil, bundle: nil)
        vc.viewModel = DistanceFilterSelectionViewModel(coordinator: self,
                                                        address: address,
                                                        radiusKm: radiusKm,
                                                        completion: completion)
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
