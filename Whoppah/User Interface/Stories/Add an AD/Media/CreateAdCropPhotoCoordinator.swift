//
//  CreateAdCropPhotoCoordinator.swift
//  Whoppah
//
//  Created by Jose Camallonga on 23/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

class CreateAdCropPhotoCoordinator {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    private let photoIndex: Int

    init(navigationController: UINavigationController, photoIndex: Int) {
        self.navigationController = navigationController
        self.photoIndex = photoIndex
        childCoordinators = []
    }

    func start() {
        let vc = CreateAdCropPhotoViewController()
        vc.viewModel = CreateAdCropPhotoViewModel(coordinator: self, photoIndex: photoIndex)
        let nav = WhoppahNavigationController(rootViewController: vc)
        nav.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
        guard let top = navigationController.topViewController else { return }
        top.present(nav, animated: true, completion: nil)
    }

    func dismiss() {
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
    }
}
