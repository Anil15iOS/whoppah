//
//  CreateOnboardingViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 14/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import Resolver

class CreateAdOnboardingViewModel {
    private let coordinator: CreateAdOnboardingCoordinator
    @Injected var adCreator: ADCreator
    @Injected var eventTracking: EventTrackingService

    init(coordinator: CreateAdOnboardingCoordinator) {
        self.coordinator = coordinator
    }

    func createAd() {
        adCreator.startCreating()
        coordinator.startCreateAd()
    }

    func showTips() {
        coordinator.showTips(viewModel: self)
    }

    func showTip(index: Int) {
        switch index {
        case 0:
            eventTracking.createAd.trackTipsPage1()
        case 1:
            eventTracking.createAd.trackTipsPage2()
        default:
            break
        }
    }

    func dismiss() {
        coordinator.dismiss()
        eventTracking.createAd.trackTipsAbandon()
    }
}
