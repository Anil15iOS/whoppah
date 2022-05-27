//
//  HelpCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 04/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

protocol HelpCoordinator: Coordinator {
    func dismiss()
}

class HelpCoordinatorImpl: HelpCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(withConfig config: HelpConfig) {
        let vc = HelpViewController()
        let vm = HelpViewModel(coordinator: self, config: config)
        vc.viewModel = vm
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        if navigationController.viewControllers.count == 1 {
            navigationController.dismiss(animated: true, completion: {
                self.navigationController.viewControllers.removeAll()
            })
        } else {
            navigationController.popViewController(animated: true)
        }
    }
}
