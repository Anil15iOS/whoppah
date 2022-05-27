//
//  AboutWhoppahHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 09/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit
import WhoppahUI
import SwiftUI
import ComposableArchitecture

class AboutWhoppahHostingController: WhoppahUIHostingController<AboutWhoppah,
                                     AboutWhoppah.Model,
                                     AboutWhoppah.ViewState,
                                     AboutWhoppah.Action,
                                     AboutWhoppah.OutboundAction,
                                     AboutWhoppah.TrackingAction> {
    override init() {
        super.init()
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> AboutWhoppah {
        let environment = AboutWhoppah.Environment(localizationClient: localizationClient,
                                                   trackingClient: trackingClient,
                                                   outboundActionClient: outboundActionClient,
                                                   mainQueue: .main)

        let reducer = AboutWhoppah.Reducer().reducer

        let store: Store<AboutWhoppah.ViewState, AboutWhoppah.Action> =
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
    override func handle(outboundAction: AboutWhoppah.OutboundAction) -> Effect<AboutWhoppah.Action, Never> {
        switch outboundAction {
        case .mailToSupportTapped(let emailAddress):
            if let url = URL(string: "mailto:\(emailAddress)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return .none.eraseToEffect()
        }
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: AboutWhoppah.TrackingAction) -> Effect<Void, Never> {
        return .none.eraseToEffect()
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<AboutWhoppah.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(AboutWhoppah.Model.self) else {
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
