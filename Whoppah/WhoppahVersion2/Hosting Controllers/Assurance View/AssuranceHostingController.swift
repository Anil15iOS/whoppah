//
//  AssuranceHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 11/11/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit
import SwiftUI
import WhoppahUI
import ComposableArchitecture
import FirebaseRemoteConfig
import Resolver

class AssuranceHostingController: WhoppahUIHostingController<HowWhoppahWorks,
                                  HowWhoppahWorks.Model,
                                  HowWhoppahWorks.ViewState,
                                  HowWhoppahWorks.Action,
                                  HowWhoppahWorks.OutboundAction,
                                  HowWhoppahWorks.TrackingAction> {

    var coordinator: AssuranceCoordinator?
    
    @Injected private var eventTracking: EventTrackingService
    
    override init() {
        super.init()
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> HowWhoppahWorks {
        let environment = HowWhoppahWorks.Environment(localizationClient: localizationClient,
                                                      trackingClient: trackingClient,
                                                      outboundActionClient: outboundActionClient,
                                                      mainQueue: .main)

        let reducer = HowWhoppahWorks.Reducer().reducer

        let store: Store<HowWhoppahWorks.ViewState, HowWhoppahWorks.Action> =
            .init(initialState: .initial,
                  reducer: reducer,
                  environment: environment)

        return .init(store: store)
    }
    
    ///
    /// ⚡️Handles outbound actions
    ///
    /// - Parameter outboundAction: An outbound action
    /// - Returns: An effect
    ///
    override func handle(outboundAction: HowWhoppahWorks.OutboundAction) -> Effect<HowWhoppahWorks.Action, Never> {
        switch outboundAction {
        case .exitHowWhoppahWorks:
            coordinator?.goBack()
            return .none.eraseToEffect()
        case .bookCourier:
            coordinator?.goBack()
            coordinator?.goBack(animated: false)
            coordinator?.goToBookCourier()
            return .none.eraseToEffect()
        }
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: HowWhoppahWorks.TrackingAction) -> Effect<Void, Never> {
        switch action {
        case .didExit:
            eventTracking.usp.backClicked()
        default:
            break
        }
        return .none.eraseToEffect()
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<HowWhoppahWorks.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(HowWhoppahWorks.Model.self) else {
            return .none
        }
        return Effect(value: localizedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
