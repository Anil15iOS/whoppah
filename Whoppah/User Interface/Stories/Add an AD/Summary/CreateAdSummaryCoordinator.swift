//
//  CreateAnAdSummaryCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 24/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

protocol CreateAdSummaryCoordinator: CreateAdBaseCoordinator {
    func onAdCreateFinished(productImage: UIImage, adID: UUID, mode: AdCreationResult)
    func start()
    func next()
    func editPhotos()
    func editVideo()
    func editDescription()
    func editDetails()
    func editPrice()
    func editShipping()
}

class CreateAdSummaryCoordinatorImpl: CreateAdSummaryCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let mode: CreateAdStepMode

    required init(navigationController: UINavigationController, mode: CreateAdStepMode) {
        self.navigationController = navigationController
        self.mode = mode
    }

    func start() {
        let vc = CreateAdSummaryViewController()
        vc.viewModel = CreateAdSummaryViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func next() {}

    func editDescription() {
        let coordinator = CreateAdDescriptionCoordinatorImpl(navigationController: navigationController, mode: .pop)
        coordinator.start()
    }

    func editDetails() {
        let coordinator = CreateAdDetailsCoordinatorImpl(navigationController: navigationController, mode: .pop)
        coordinator.start()
    }

    func editPrice() {
        let coordinator = CreateAdPriceCoordinatorImpl(navigationController: navigationController, mode: .pop)
        coordinator.start()
    }

    func editPhotos() {
        let coordinator = CreateAdSelectPhotosCoordinatorImpl(navigationController: navigationController, mode: .pop)
        coordinator.start()
    }

    func editVideo() {
        let coordinator = CreateAdVideoCoordinatorImpl(navigationController: navigationController, mode: .pop)
        coordinator.start()
    }

    func editShipping() {
        let coordinator = CreateAdShippingCoordinatorImpl(navigationController: navigationController, mode: .pop)
        coordinator.start()
    }

    func onAdCreateFinished(productImage: UIImage, adID: UUID, mode: AdCreationResult) {
        let processingVC: CreateAdFinishedViewController = UIStoryboard(storyboard: .addAnAD).instantiateViewController()
        processingVC.productImage = productImage
        processingVC.adID = adID
        processingVC.mode = mode
        let nav = WhoppahNavigationController(rootViewController: processingVC)
        guard let top = navigationController.topViewController, let tabs = top.getTabsVC() else { return }
        top.dismiss(animated: true) {
            self.navigationController.viewControllers.removeAll()
            tabs.present(nav, animated: true, completion: nil)
        }
    }
}
