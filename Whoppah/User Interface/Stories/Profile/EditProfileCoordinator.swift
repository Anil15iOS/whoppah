//
//  EditProfileCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 17/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class EditProfileCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(merchant: LegacyMerchant) {
        let vc: EditProfileViewController = UIStoryboard.storyboard(storyboard: .profile).instantiateViewController()
        let viewModel = EditProfileViewModel(coordinator: self,
                                             merchant: merchant)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
