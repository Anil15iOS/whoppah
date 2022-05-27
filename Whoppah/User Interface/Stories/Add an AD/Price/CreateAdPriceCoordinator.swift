//
//  CreateAdPriceCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 22/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

protocol CreateAdPriceCoordinator: CreateAdBaseCoordinator {
    func start()
    func next()
}

class CreateAdPriceCoordinatorImpl: CreateAdPriceCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let mode: CreateAdStepMode

    required init(navigationController: UINavigationController, mode: CreateAdStepMode) {
        self.navigationController = navigationController
        self.mode = mode
    }

    func start() {
        let vc = CreateAdPriceViewController()
        vc.viewModel = CreateAdPriceViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func next() {
        switch mode {
        case .flow:
            let coordinator = CreateAdShippingCoordinatorImpl(navigationController: navigationController, mode: .flow)
            coordinator.start()
        case .pop:
            navigationController.popViewController(animated: true)
        case .dismiss:
            dismiss()
        }
    }
}
