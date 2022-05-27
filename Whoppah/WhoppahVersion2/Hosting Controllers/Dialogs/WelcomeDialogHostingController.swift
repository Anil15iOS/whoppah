//
//  WelcomeDialogHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 15/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import SwiftUI
import WhoppahUI
import ComposableArchitecture
import Resolver

class WelcomeDialogHostingController: WhoppahUIHostingController<WelcomeToWhoppahDialog,
                                      WelcomeToWhoppahDialogModel,
                                      WelcomeToWhoppahDialog.ViewState,
                                      WelcomeToWhoppahDialog.Action,
                                      WelcomeToWhoppahDialog.OutboundAction,
                                      WelcomeToWhoppahDialog.TrackingAction> {
    
    @Injected private var eventTracking: EventTrackingService
    
    private weak var presentingVC: UIViewController?
    private let isNewUser: Bool
    private let existingEmailAddress: String
    
    init(presentingViewController: UIViewController,
         isNewUser: Bool,
         existingEmailAddress: String = "") {
        self.presentingVC = presentingViewController
        self.isNewUser = isNewUser
        self.existingEmailAddress = existingEmailAddress
        
        super.init()
        
        modalTransitionStyle = .crossDissolve
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> WelcomeToWhoppahDialog {
        let reducer = WelcomeToWhoppahDialog.Reducer().reducer

        let environment = WelcomeToWhoppahDialog.Environment(localizationClient: localizationClient,
                                                             trackingClient: trackingClient,
                                                             outboundActionClient: outboundActionClient,
                                                             mainQueue: .main)

        let store: Store<WelcomeToWhoppahDialog.ViewState, WelcomeToWhoppahDialog.Action> =
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
    override func handle(outboundAction: WelcomeToWhoppahDialog.OutboundAction) -> Effect<WelcomeToWhoppahDialog.Action, Never> {
        switch outboundAction {
        case .didTapCreateAdButton:
            dismiss(animated: true) {
                Navigator().navigate(route: Navigator.Route.createAd)
            }
        case .didTapDiscoverDesignButton:
            dismiss(animated: true) {
                Navigator().navigate(route: Navigator.Route.search(input: .init()))
            }
        case .didTapCloseButton:
            dismiss(animated: false, completion: nil)
        }
        return .none.eraseToEffect()
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: WelcomeToWhoppahDialog.TrackingAction) -> Effect<Void, Never> {
        switch action {
        case .didTapCreateAdButton:
            eventTracking.createAd.trackCreateFirstAd()
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
    override func fetchLocalizedModel() -> Effect<WelcomeToWhoppahDialogModel, WhoppahUI.LocalizationClientError> {
        if isNewUser {
            guard let localizedModel = LocalizationService().localise(WelcomeToWhoppahDialog.NewUserModel.self) else {
                return .none
            }

            return Effect(value: localizedModel)
                .setFailureType(to: WhoppahUI.LocalizationClientError.self)
                .eraseToEffect()
        } else {
            guard var localizedModel = LocalizationService().localise(WelcomeToWhoppahDialog.ExistingSocialUserModel.self) else {
                return .none
            }

            localizedModel.description = localizedModel.descriptionWithEmail(existingEmailAddress)

            return Effect(value: localizedModel)
                .setFailureType(to: WhoppahUI.LocalizationClientError.self)
                .eraseToEffect()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
}
