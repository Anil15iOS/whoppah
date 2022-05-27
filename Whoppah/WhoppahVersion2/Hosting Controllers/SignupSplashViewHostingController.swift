//
//  SignupSplashViewHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 06/01/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import SwiftUI
import WhoppahUI
import ComposableArchitecture

class SignupSplashViewHostingController: WhoppahUIHostingController<SignupSplashView,
                                         SignupSplashView.Model,
                                         SignupSplashView.ViewState,
                                         SignupSplashView.Action,
                                         SignupSplashView.OutboundAction,
                                         SignupSplashView.TrackingAction> {
    
    private weak var presentingVC: UIViewController?
    
    init(presentingViewController: UIViewController) {
        super.init()
        self.presentingVC = presentingViewController
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> SignupSplashView {
        let environment = SignupSplashView.Environment(localizationClient: localizationClient,
                                                       trackingClient: trackingClient,
                                                       outboundActionClient: outboundActionClient,
                                                       mainQueue: .main)
        
        let reducer = SignupSplashView.Reducer().reducer

        let store: Store<SignupSplashView.ViewState, SignupSplashView.Action> =
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
    override func handle(outboundAction: SignupSplashView.OutboundAction) -> Effect<SignupSplashView.Action, Never> {
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
        case .didTapGuestButton:
            self.dismiss(animated: true, completion: nil)
        }
        return .none.eraseToEffect()
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: SignupSplashView.TrackingAction) -> Effect<Void, Never> {
        return .none.eraseToEffect()
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<SignupSplashView.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(SignupSplashView.Model.self) else {
            return .none
        }
        return Effect(value: localizedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
}
