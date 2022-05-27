//
//  AssuranceCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 16/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit
import FirebaseRemoteConfig

class AssuranceCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewControlller = AssuranceHostingController()
        viewControlller.coordinator = self

        navigationController.pushViewController(viewControlller, animated: true)
    }

    func goBack(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    func goToBookCourier() {
        let config = RemoteConfig.remoteConfig()
        let value = config.configValue(forKey: "book_courier_product_id")
        
        guard let adId = value.stringValue,
              let uuid = UUID(uuidString: adId)
        else { return }
        
        let coordinator = AdDetailsCoordinator(navigationController: navigationController)
        coordinator.start(adID: uuid)
    }

    func goToHelp(withConfig config: HelpConfig) {
        let coordinator = HelpCoordinatorImpl(navigationController: navigationController)
        coordinator.start(withConfig: config)
    }
}
