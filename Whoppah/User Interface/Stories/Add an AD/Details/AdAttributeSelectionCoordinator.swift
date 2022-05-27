//
//  AttributeSelectionCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 17/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class AdAttributeSelectionCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(repo: AdAttributeRepository,
               inputs: AdAttributeSelectionViewModel.UIInputs,
               selectedAttributes: [AdAttribute],
               delegate: AdAttributeSelectionViewControllerDelegate) {
        let vc: AdAttributeSelectionViewController = UIStoryboard(storyboard: .addAnAD).instantiateViewController()
        vc.delegate = delegate
        vc.viewModel = AdAttributeSelectionViewModel(coordinator: self,
                                                     selectedAttributes: selectedAttributes,
                                                     repo: repo,
                                                     uiInputs: inputs)
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        if navigationController.viewControllers.count <= 1 {
            guard let top = navigationController.topViewController else { return }
            top.dismiss(animated: true, completion: {
                self.navigationController.viewControllers.removeAll()
            })
        } else {
            navigationController.popViewController(animated: true)
        }
    }
}
