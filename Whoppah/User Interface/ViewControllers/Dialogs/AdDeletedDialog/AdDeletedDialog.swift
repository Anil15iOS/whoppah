//
//  AdDeletedDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 01/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import Resolver

class AdDeletedDialog: BaseDialog {
    @Injected private var eventTracking: EventTrackingService

    @IBAction func placeAd(_: UIButton) {
        dismiss(animated: true) { [weak self] in
            guard let tabsVC = self?.getTabsVC() else { return }
            let nav = WhoppahNavigationController()
            nav.isNavigationBarHidden = true
            nav.isModalInPresentation = true
            if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
            let coordinator = CreateAdOnboardingCoordinatorImpl(navigationController: nav)
            coordinator.start()
            tabsVC.present(nav, animated: true, completion: nil)
            self?.eventTracking.createAd.trackCreateAnotherAdInDelete()
        }
    }
}
