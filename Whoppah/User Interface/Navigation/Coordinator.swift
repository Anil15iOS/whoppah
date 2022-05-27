//
//  Coordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 14/06/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func showError(_ error: Error)
}

extension Coordinator {
    func showError(_ error: Error) {
        guard let top = navigationController.topViewController else { return }
        top.showError(error)
    }

    func showError(_ error: String) {
        guard let top = navigationController.topViewController else { return }
        top.showErrorDialog(message: error)
    }
}
