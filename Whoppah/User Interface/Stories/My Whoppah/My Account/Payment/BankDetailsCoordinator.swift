//
//  EditBankDetailsCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 28/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import Resolver

class BankDetailsCoordinator: Coordinator {
    @Injected private var userService: WhoppahCore.LegacyUserService
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    typealias BankCompleted = (Bool) -> Void
    private var completed: BankCompleted?

    init(navigationController: UINavigationController, completed: BankCompleted? = nil) {
        self.navigationController = navigationController
        self.completed = completed
    }

    func start() {
        if hasValidBank() {
            viewDetails()
        } else {
            editDetails()
        }
    }

    func editDetails() {
        let vc: EditBankDetailsViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        let viewModel = BankDetailsViewModel(coordinator: self, maskIban: false)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    func viewDetails() {
        let vc: ViewBankDetailsViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        let viewModel = BankDetailsViewModel(coordinator: self, maskIban: true)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
        completed?(hasValidBank())
    }

    private func hasValidBank() -> Bool {
        guard let bank = userService.current?.mainMerchant.bank else { return false }
        return bank.isValid()
    }
}
