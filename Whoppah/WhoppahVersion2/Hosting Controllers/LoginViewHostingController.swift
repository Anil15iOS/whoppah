//
//  LoginViewHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 24/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import UIKit
import WhoppahUI
import SwiftUI
import ComposableArchitecture
import Resolver
import WhoppahCoreNext
import WhoppahModel
import WhoppahRepository
import Combine

class LoginViewHostingController: WhoppahUIHostingController<LoginView,
                                  LoginView.Model,
                                  LoginView.ViewState,
                                  LoginView.Action,
                                  LoginView.OutboundAction,
                                  LoginView.TrackingAction> {

    @LazyInjected private var userProvider: UserProviding
    @LazyInjected private var userRepository: UserRepository
    @LazyInjected private var authenticationStore: AuthenticationStoring
    @LazyInjected private var eventTracking: EventTrackingService
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    private weak var presentingVC: UIViewController?
    private let initialView: LoginView.NavigationView
    
    init(initialView: LoginView.NavigationView = .none,
         presentingViewController: UIViewController? = nil) {
        self.presentingVC = presentingViewController
        self.initialView = initialView
        
        super.init()
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> LoginView {
        let reducer = LoginView.Reducer().reducer

        let environment = LoginView.Environment(localizationClient: localizationClient,
                                                trackingClient: trackingClient,
                                                outboundActionClient: outboundActionClient,
                                                mainQueue: .main)

        let store: Store<LoginView.ViewState, LoginView.Action> =
            .init(initialState: .initial,
                  reducer: reducer,
                  environment: environment)

        return .init(store: store, initialView: initialView)
    }
    
    ///
    /// ⚡️Handles outbound actions
    ///
    /// - Parameter outboundAction: An outbound action
    /// - Returns: An effect
    ///
    override func handle(outboundAction: LoginView.OutboundAction) -> Effect<LoginView.Action, Never> {
        switch outboundAction {
        case .didTapSignInOption(let id):
            switch id {
            case .magicLink:
                break
            case .facebook:
                return self.authenticationStore
                    .signInAuthenticator(ofType: FacebookAuthenticator.self)!
                    .authorize(authMode: .signIn, merchantType: nil)
                    .map({ accessToken in
                        return accessToken.token
                    })
                    .eraseToEffect()
                    .catchToEffect(LoginView.Action.authorizationResponse)
            case .google:
                return self.authenticationStore
                    .signInAuthenticator(ofType: GoogleAuthenticator.self)!
                    .setPresentingViewController(self)
                    .authorize(authMode: .signIn, merchantType: nil)
                    .map({ accessToken in
                        return accessToken.token
                    })
                    .eraseToEffect()
                    .catchToEffect(LoginView.Action.authorizationResponse)
            case .apple:
                return self.authenticationStore
                    .signInAuthenticator(ofType: AppleAuthenticator.self)!
                    .authorize(authMode: .signIn, merchantType: nil)
                    .map({ accessToken in
                        return accessToken.token
                    })
                    .eraseToEffect()
                    .catchToEffect(LoginView.Action.authorizationResponse)
            }
        case .didTapSignIn(let email, let password):
            return self.authenticationStore
                .signInAuthenticator(ofType: EmailPasswordAuthenticator.self)!
                .signIn(email: email, password: password)
                .map({ accessToken in
                    return accessToken.token
                })
                .eraseToEffect()
                .catchToEffect(LoginView.Action.authorizationResponse)
        case .didTapSendPasswordResetLink(let email):
            return self.userProvider
                .resetPassword(email: email)
                .eraseToEffect()
                .catchToEffect(LoginView.Action.didSendForgotPasswordEmail)
        case .didTapSendMagicLinkCode(let email):
            return self.authenticationStore
                .signInAuthenticator(ofType: MagicLinkAuthenticator.self)!
                .requestEmailToken(emailAddress: email)
                .eraseToEffect()
                .catchToEffect(LoginView.Action.requestMagicLinkTokenResponse)
        case .didTapLoginWithMagicCode(let code, let email, let cookie):
            return self.authenticationStore
                .signInAuthenticator(ofType: MagicLinkAuthenticator.self)!
                .authorize(withEmail: email, token: code, cookie: cookie)
                .map({ accessToken in
                    return accessToken.token
                })
                .eraseToEffect()
                .catchToEffect(LoginView.Action.loginWithMagicLinkResponse)
        case .dismissView:
            self.dismiss(animated: true, completion: nil)
        case .didTapSignInAgain:
            self.dismiss(animated: true) { [weak self] in
                _ = self?.authenticationStore.signOutAll()
            }
        default:
            break
        }
        return .none.eraseToEffect()
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: LoginView.TrackingAction) -> Effect<Void, Never> {
        switch action {
        case .didLoginSuccessfully:
            guard let user = userProvider.currentUser,
                  let authenticationMethod = userProvider.authenticationMethod
            else { return .none.eraseToEffect() }

            eventTracking.trackLogIn(authMethod: authenticationMethod,
                                           email: user.email,
                                           userID: user.id.uuidString,
                                           dataJoined: user.dateJoined.iso8601Text())
            return .none.eraseToEffect()
        default:
            return .none.eraseToEffect()
        }
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<LoginView.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(LoginView.Model.self) else {
            return .none
        }
        return Effect(value: localizedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }

    private func checkIfEmailExists(email: String) -> Effect<RegistrationView.Action, Never> {
        return self.userRepository
            .checkIfEmailExists(email: email)
            .map { result -> Bool in
                switch result {
                case .unavailable, .banned: return false
                case .available: return true
                }
            }
            .eraseToEffect()
            .receive(on: RunLoop.main)
            .catchToEffect(RegistrationView.Action.emailAvailabilityResponse)
    }

}
