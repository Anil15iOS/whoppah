//
//  ContactInfoCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 16/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class ContactInfoCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc: ContactInfoViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        vc.viewModel = ContactInfoViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func editAddress(data: AddressCellEdit, delegate: AddEditAddressViewControllerDelegate) {
        let addressVC = AddEditAddressViewController()
        addressVC.address = data.address
        addressVC.delegate = delegate
        addressVC.isDeleteButtonHidden = !data.canDelete
        navigationController.pushViewController(addressVC, animated: true)
    }

    func addAddress(delegate: AddEditAddressViewControllerDelegate) {
        let addressVC = AddEditAddressViewController()
        addressVC.delegate = delegate
        addressVC.isDeleteButtonHidden = true
        navigationController.pushViewController(addressVC, animated: true)
    }
}
