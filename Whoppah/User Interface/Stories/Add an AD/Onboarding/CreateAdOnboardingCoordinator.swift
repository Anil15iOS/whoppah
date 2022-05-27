//
//  CreateAdOnboardingCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 14/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import Resolver
import WhoppahCore

protocol CreateAdOnboardingCoordinator: Coordinator {
    init(navigationController: UINavigationController)

    func start()
    func dismiss()

    func startCreateAd()
    func showTips(viewModel: CreateAdOnboardingViewModel)
}

class CreateAdOnboardingCoordinatorImpl: CreateAdOnboardingCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    @Injected private var eventTracking: EventTrackingService

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = CreateAdHowItWorksViewController()
        vc.viewModel = CreateAdOnboardingViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func startCreateAd() {
        let coordinator = CreateAdCategorySelectionCoordinatorImpl(navigationController: navigationController, mode: .flow)
        coordinator.start()
        eventTracking.createAd.trackStartCreatingAd()
    }

    func showTips(viewModel: CreateAdOnboardingViewModel) {
        let vc = CreateAdOnboardingViewController()
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        guard let top = navigationController.topViewController else { return }
        eventTracking.createAd.trackCancelAdCreation()
        top.dismiss(animated: true, completion: nil)
    }
}
