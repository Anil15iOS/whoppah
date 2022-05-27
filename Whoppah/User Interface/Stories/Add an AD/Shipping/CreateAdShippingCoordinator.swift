//
//  CreateAdShippingCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 22/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

protocol CreateAdShippingCoordinator: CreateAdBaseCoordinator {
    func start()
    func next()
}

class CreateAdShippingCoordinatorImpl: CreateAdShippingCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let mode: CreateAdStepMode

    required init(navigationController: UINavigationController, mode: CreateAdStepMode) {
        self.navigationController = navigationController
        self.mode = mode
    }

    func start() {
        let vc = CreateAdShippingViewController()
        vc.viewModel = CreateAdShippingViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func next() {
        switch mode {
        case .flow:
            let coordinator = CreateAdSummaryCoordinatorImpl(navigationController: navigationController, mode: .flow)
            coordinator.start()
        case .pop:
            navigationController.popViewController(animated: true)
        case .dismiss:
            dismiss()
        }
    }
}
