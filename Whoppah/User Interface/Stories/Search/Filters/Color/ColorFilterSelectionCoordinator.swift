//
//  ColorFilterSelectionCoordinator.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import UIKit

class ColorFilterSelectionCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(colors: [FilterAttribute], selected: [FilterAttribute], completion: @escaping (([FilterAttribute]) -> Void)) {
        let vc = ColorFilterSelectionViewController(nibName: nil, bundle: nil)
        vc.viewModel = ColorFilterSelectionViewModel(coordinator: self, colors: colors, selected: selected, completion: completion)
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
