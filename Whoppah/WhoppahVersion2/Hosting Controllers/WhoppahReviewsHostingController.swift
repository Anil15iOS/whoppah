//
//  WhoppahReviewsHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 09/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit
import WhoppahUI
import SwiftUI
import ComposableArchitecture

class WhoppahReviewsHostingController: WhoppahUIHostingController<WhoppahReviews,
                                       WhoppahReviews.Model,
                                       WhoppahReviews.ViewState,
                                       WhoppahReviews.Action,
                                       WhoppahReviews.OutboundAction,
                                       WhoppahReviews.TrackingAction> {
    override init() {
        super.init()
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> WhoppahReviews {
        let environment = WhoppahReviews.Environment(localizationClient: localizationClient,
                                                   trackingClient: trackingClient,
                                                   outboundActionClient: outboundActionClient,
                                                   mainQueue: .main)

        let reducer = WhoppahReviews.Reducer().reducer

        let store: Store<WhoppahReviews.ViewState, WhoppahReviews.Action> =
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
    override func handle(outboundAction: WhoppahReviews.OutboundAction) -> Effect<WhoppahReviews.Action, Never> {
        return .none.eraseToEffect()
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: WhoppahReviews.TrackingAction) -> Effect<Void, Never> {
        return .none.eraseToEffect()
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<WhoppahReviews.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(WhoppahReviews.Model.self) else {
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
