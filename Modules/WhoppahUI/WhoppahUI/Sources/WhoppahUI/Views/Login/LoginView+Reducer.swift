//  
//  LoginView+Reducer.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import ComposableArchitecture

public extension LoginView {
    struct Reducer {
        public init() {}
        
        public let reducer = ComposableArchitecture.Reducer<ViewState, Action, Environment> { state, action, environment in
            switch action {
            case .loadContent:
                guard state.loadingState == .initial else { return .none }
                state.loadingState = .loading
                return environment.localizationClient.fetch()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(LoginView.Action.didFinishLoadingContent)
            case .didFinishLoadingContent(.success(let model)):
                state.model = model
                state.loadingState = .finished
                return .none
            case .didFinishLoadingContent(.failure(_)):
                state.loadingState = .failed
                return .none
            case .trackingAction(let action):
                _ = environment.trackingClient.track(action)
                return .none
            case .outboundAction(let action):
                switch action {
                case .didTapSignIn,
                        .didTapSendPasswordResetLink,
                        .didTapLoginWithMagicCode:
                    state.authenticationFailedMessageIsVisible = false
                    state.mainButtonState = .inProgress
                default:
                    state.mainButtonState = .default
                }
                return environment.outboundActionClient.perform(action)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect()
            case .authorizationResponse(let result):
                state.mainButtonState = .default
                switch result {
                case .success(let authToken):
                    state.authenticationFailedMessageIsVisible = false
                    _ = environment.trackingClient.track(.didLoginSuccessfully)
                    return environment.outboundActionClient.perform(OutboundAction.dismissView)
                case .failure(let error):
                    state.authenticationFailedMessageIsVisible = true
                    return .none
                }
            case .requestMagicLinkTokenResponse(let result):
                state.mainButtonState = .default
                switch result {
                case .success(let cookie):
                    state.magicLinkCookie = cookie
                    return .none
                case .failure(let error):
                    return .none
                }
            case .loginWithMagicLinkResponse(let result):
                state.mainButtonState = .default
                state.authenticationFailedMessageIsVisible = false
                switch result {
                case .success(let authToken):
                    state.magicLinkInvalidMessageIsVisible = false
                    _ = environment.trackingClient.track(.didLoginSuccessfully)
                    return environment.outboundActionClient.perform(OutboundAction.dismissView)
                case .failure(let error):
                    state.magicLinkInvalidMessageIsVisible = true
                    return .none
                }
            case .didSendForgotPasswordEmail(let result):
                state.mainButtonState = .default
                return .none
            }
        }
    }
}
