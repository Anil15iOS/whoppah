//
//  CheckEmailDialogCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 07/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class CheckEmailDialogCoordinator {
    weak var viewController: UIViewController?
    var viewModel: RegistrationViewModel?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func start(title: String, message: String, completion: (() -> Void)?) {
        let clients = EmailClient.allCases.filter { $0.exists() }
        guard let firstClient = clients.first else { completion?(); return }
        if clients.count > 1 {
            let vc = getController(title: title, message: message, completion)
            guard let top = viewController else { return }
            top.present(vc, animated: true, completion: nil)
        } else {
            firstClient.open { _ in
                completion?()
            }
        }
    }

    private func getController(title: String, message: String, _ completion: (() -> Void)?) -> UIViewController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        for client in EmailClient.allCases {
            guard client.exists() else { continue }
            let action = UIAlertAction(title: client.title, style: .default, handler: { _ in
                client.open()
                alertController.dismiss(animated: true, completion: completion)
            })
            alertController.addAction(action)
        }
        let quitAction = UIAlertAction(title: R.string.localizable.commonCancel(), style: .destructive) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(quitAction)
        return alertController
    }
}
