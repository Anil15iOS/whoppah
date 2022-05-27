//
//  MyWhoppahCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 17/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class MyWhoppahCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc: MyWhoppahViewController = UIStoryboard.storyboard(storyboard: .myWhoppah).instantiateViewController()
        vc.viewModel = MyWhoppahViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func showPublicProfile() {
        let coordinator = PublicProfileCoordinator(navigationController: navigationController)
        coordinator.start()
    }

    func showEditProfile(merchant: LegacyMerchant) {
        let coordinator = EditProfileCoordinator(navigationController: navigationController)
        coordinator.start(merchant: merchant)
    }
}
