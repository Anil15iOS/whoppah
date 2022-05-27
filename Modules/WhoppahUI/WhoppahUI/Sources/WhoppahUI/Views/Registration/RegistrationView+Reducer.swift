//  
//  RegistrationView+Reducer.swift
//  WhoppahUIIntegrationTest
//
//  Created by Dennis Ippel on 17/01/2022.
//

import ComposableArchitecture
import Combine

public extension RegistrationView {
    struct Reducer {
        public init() {}
        
        public let reducer = ComposableArchitecture.Reducer<ViewState, Action, Environment> { state, action, environment in
            switch action {
            case .loadContent:
                return environment.localizationClient.fetch()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(RegistrationView.Action.didFinishLoadingContent)
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
                case .didChooseSignUpType(let type):
                    state.signUpType = type
                    state.registrationFailedMessageIsVisible = false
                    state.didRaiseError = false
                default:
                    break
                }
                return environment.outboundActionClient.perform(action)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect()
            case .emailAvailabilityResponse(let result):
                switch result {
                case .failure(let error):
                    state.registrationFailedMessageIsVisible = true
                    state.didRaiseError = true
                    _ = environment.outboundActionClient.perform(OutboundAction.didRaiseError(error: error))
                    return environment.outboundActionClient.perform(OutboundAction.registrationDidFail)
                case .success(let emailAddressIsAvailable):
                    if emailAddressIsAvailable {
                        state.emailAddressIsAvailable = true
                    } else {
                        state.emailAddressIsAvailable = false
                        state.registrationFailedMessageIsVisible = true
                        state.didRaiseError = true
                    }
                    return .none
                }
            case .registrationResponse(let result):
                switch result {
                case .failure(let error):
                    state.registrationFailedMessageIsVisible = true
                    state.didRaiseError = true
                    _ = environment.outboundActionClient.perform(OutboundAction.didRaiseError(error: error))
                    return environment.outboundActionClient.perform(OutboundAction.registrationDidFail)
                case .success:
                    return environment.outboundActionClient.perform(OutboundAction.registrationDidSucceed)
                }
            case .signInResponse(let result):
                switch result {
                case .failure(let error):
                    state.isUserLoggedIn = false
                    state.didRaiseError = true
                    return environment.outboundActionClient.perform(OutboundAction.openLoginView)
                case .success:
                    state.isUserLoggedIn = true
                    
                    if state.signUpType == .individual {
                        return environment.outboundActionClient.perform(OutboundAction.openWelcomeView)
                    }
                    
                    return .none
                }
            case .updateMerchantResponse(let result):
                switch result {
                case .failure(let error):
                    state.didRaiseError = true
                    return environment.outboundActionClient.perform(OutboundAction.didRaiseError(error: error))
                case .success:
                    return environment.outboundActionClient.perform(OutboundAction.openWelcomeView)
                }
            case .socialRegistrationResponse(let result):
                switch result {
                case .failure(let error):
                    state.isUserLoggedIn = false
                    state.didRaiseError = true
                    return environment.outboundActionClient.perform(OutboundAction.didRaiseError(error: error))
                case .success:
                    state.isUserLoggedIn = true
                    _ = environment.trackingClient.track(.signUpSuccess)
                    return .none
                }
            case .updatePhoneNumberResponse(let result):
                switch result {
                case .failure(let error):
                    state.didRaiseError = true
                    return environment.outboundActionClient.perform(OutboundAction.didRaiseError(error: error))
                case .success:
                    _ = environment.trackingClient.track(.signUpSuccess)
                    return environment.outboundActionClient.perform(OutboundAction.openWelcomeView)
                }
            }
        }
    }
}
