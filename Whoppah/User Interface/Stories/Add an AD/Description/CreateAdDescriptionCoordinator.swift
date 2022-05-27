//
//  CreateAdDescriptionViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 15/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

struct CreateAdDialog {
    static func showSaveDialog(navigationController: UINavigationController,
                               onSave: @escaping (() -> Void),
                               onDiscard: @escaping (() -> Void),
                               onResume: @escaping (() -> Void)) {
        guard let top = navigationController.topViewController else { return }

        let alertController = UIAlertController(title: nil,
                                                message: R.string.localizable.createAdCancelDialogTitle(),
                                                preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.barButtonItem = top.navigationItem.rightBarButtonItem

        let action = UIAlertAction(title: R.string.localizable.createAdCancelDialogSave(), style: .default, handler: { _ in
            onSave()
        })
        alertController.addAction(action)

        let delete = UIAlertAction(title: R.string.localizable.createAdCancelDialogDelete(), style: .destructive, handler: { _ in
            onDiscard()
        })
        alertController.addAction(delete)

        let quitAction = UIAlertAction(title: R.string.localizable.createAdCancelDialogReturnToAd(), style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
            onResume()
        }
        alertController.addAction(quitAction)

        top.present(alertController, animated: true, completion: nil)
    }
}

protocol CreateAdDescriptionCoordinator: CreateAdBaseCoordinator {
    func start()
    func next()
}

class CreateAdDescriptionCoordinatorImpl: CreateAdDescriptionCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let mode: CreateAdStepMode
    required init(navigationController: UINavigationController, mode: CreateAdStepMode) {
        self.navigationController = navigationController
        self.mode = mode
    }

    func start() {
        let vc = CreateAdDescriptionViewController()
        vc.viewModel = CreateAdDescriptionViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func next() {
        switch mode {
        case .flow:
            let coordinator = CreateAdSelectPhotosCoordinatorImpl(navigationController: navigationController, mode: .flow)
            coordinator.start()
        case .pop:
            navigationController.popViewController(animated: true)
        case .dismiss:
            dismiss()
        }
    }
}
