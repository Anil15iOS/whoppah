//
//  CreateAdVideoCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 17/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import OpalImagePicker
import WhoppahCore

protocol CreateAdVideoCoordinator: CreateAdBaseCoordinator {
    func start()
    func next()
    func openCameraScreen(onClose: (() -> Void)?)
}

class CreateAdVideoCoordinatorImpl: CreateAdVideoCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let mode: CreateAdStepMode

    required init(navigationController: UINavigationController, mode: CreateAdStepMode) {
        self.navigationController = navigationController
        self.mode = mode
    }

    func start() {
        let vc = CreateAdVideoViewController()
        vc.viewModel = CreateAdVideoViewModel(coordinator: self)
        navigationController.pushViewController(viewController: vc, animated: true, completion: nil)
    }

    func next() {
            switch mode {
            case .flow:
                let coordinator = CreateAdDetailsCoordinatorImpl(navigationController: navigationController, mode: .flow)
                coordinator.start()
            case .pop:
                navigationController.popViewController(animated: true)
            case .dismiss:
                dismiss()
            }
    }

    func openCameraScreen(onClose: (() -> Void)?) {
        let nav = WhoppahNavigationController()
        nav.isNavigationBarHidden = true
        nav.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
        let coordinator = CreateAdCameraCoordinatorImpl(navigationController: nav, mode: .video)
        coordinator.start(onClose: onClose)
        guard let top = navigationController.topViewController else { return }
        top.present(nav, animated: true, completion: nil)
    }
}
