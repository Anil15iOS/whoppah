//
//  CreateAdDetailsCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 21/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import Resolver

protocol CreateAdDetailsCoordinator: CreateAdBaseCoordinator {
    func start()
    func next()
    func selectAttribute(inputs: AdAttributeSelectionViewModel.UIInputs,
                         repo: AdAttributeRepository,
                         selectedAttributes: [AdAttribute],
                         delegate: AdAttributeSelectionViewControllerDelegate)
}

class CreateAdDetailsCoordinatorImpl: CreateAdDetailsCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    @Injected private var cache: CacheService
    let mode: CreateAdStepMode

    required init(navigationController: UINavigationController, mode: CreateAdStepMode) {
        self.navigationController = navigationController
        self.mode = mode
    }

    func start() {
        let vc = CreateAdDetailsViewController()
        vc.viewModel = CreateAdDetailsViewModel(coordinator: self,
                                                brandRepo: cache.brandRepo!,
                                                artistRepo: cache.artistRepo!,
                                                materialRepo: cache.materialRepo!)
        navigationController.pushViewController(vc, animated: true)
    }

    func next() {
        switch mode {
        case .flow:
            let coordinator = CreateAdPriceCoordinatorImpl(navigationController: navigationController, mode: .flow)
            coordinator.start()
        case .pop:
            navigationController.popViewController(animated: true)
        case .dismiss:
            dismiss()
        }
    }

    func selectAttribute(inputs: AdAttributeSelectionViewModel.UIInputs,
                         repo: AdAttributeRepository,
                         selectedAttributes: [AdAttribute],
                         delegate: AdAttributeSelectionViewControllerDelegate) {
        let nav = WhoppahNavigationController()
        nav.modalPresentationStyle = UIDevice.current.userInterfaceIdiom != .pad ? .fullScreen : .formSheet
        let coordinator = AdAttributeSelectionCoordinator(navigationController: nav)
        coordinator.start(repo: repo, inputs: inputs, selectedAttributes: selectedAttributes, delegate: delegate)
        guard let top = navigationController.topViewController else { return }
        top.present(nav, animated: true, completion: nil)
    }
}
