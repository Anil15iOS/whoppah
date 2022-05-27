//
//  ContextualSignupDialogHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 11/01/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import WhoppahUI
import ComposableArchitecture

class ContextualSignupDialogHostingController: WhoppahUIHostingController<ContextualSignupDialog,
                                               ContextualSignupDialog.Model,
                                               ContextualSignupDialog.ViewState,
                                               ContextualSignupDialog.Action,
                                               ContextualSignupDialog.OutboundAction,
                                               ContextualSignupDialog.TrackingAction> {
    
    private weak var presentingVC: UIViewController?
    private let modelTitle: String
    private let modelDescription: String
    
    init(presentingViewController: UIViewController, title: String, description: String) {
        self.presentingVC = presentingViewController
        self.modelTitle = title
        self.modelDescription = description
        
        super.init()
        
        modalTransitionStyle = .crossDissolve
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> ContextualSignupDialog {
        let reducer = ContextualSignupDialog.Reducer().reducer

        let environment = ContextualSignupDialog.Environment(localizationClient: localizationClient,
                                                             trackingClient: trackingClient,
                                                             outboundActionClient: outboundActionClient,
                                                             mainQueue: .main)

        let store: Store<ContextualSignupDialog.ViewState, ContextualSignupDialog.Action> =
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
    override func handle(outboundAction: ContextualSignupDialog.OutboundAction) -> Effect<ContextualSignupDialog.Action, Never> {
        switch outboundAction {
        case .didTapLogInButton:
            self.dismiss(animated: true) { [weak self] in
                let hostingController = LoginViewHostingController()
                hostingController.isModalInPresentation = true
                if UIDevice.current.userInterfaceIdiom != .pad { hostingController.modalPresentationStyle = .fullScreen }

                self?.presentingVC?.present(hostingController, animated: true, completion: nil)
            }
        case .didTapRegisterButton:
            self.dismiss(animated: true) { [weak self] in
                guard let presentingVC = self?.presentingVC else { return }

                let hostingController = RegistrationViewHostingController(presentingViewController: presentingVC)

                hostingController.isModalInPresentation = true
                if UIDevice.current.userInterfaceIdiom != .pad { hostingController.modalPresentationStyle = .fullScreen }

                presentingVC.present(hostingController, animated: true, completion: nil)
            }
        case .didTapCloseButton:
            self.dismiss(animated: false, completion: nil)
        }
        return .none.eraseToEffect()
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<ContextualSignupDialog.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(ContextualSignupDialog.Model.self) else {
            return .none
        }

        let updatedModel = ContextualSignupDialog.Model(title: modelTitle,
                                                        description: modelDescription,
                                                        loginButtonTitle: localizedModel.loginButtonTitle,
                                                        registerButtonTitle: localizedModel.registerButtonTitle)

        return Effect(value: updatedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: ContextualSignupDialog.TrackingAction) -> Effect<Void, Never> {
        return .none.eraseToEffect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
}
