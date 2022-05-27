//
//  LoginViewTests.swift
//  WhoppahTests
//
//  Created by Dennis Ippel on 02/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import XCTest
import ComposableArchitecture
import WhoppahUI
import Combine

@testable import Testing_Debug

class LoginViewTests: WhoppahTestBase {
    lazy var localizationSuccessClient: WhoppahUI.LocalizationClient<LoginView.Model> = {
        .init {
            return Effect(value: LoginView.Model.mock)
                .setFailureType(to: WhoppahUI.LocalizationClientError.self)
                .eraseToEffect()
        }
    }()
    
    lazy var localizationFailureClient: WhoppahUI.LocalizationClient<LoginView.Model> = {
        .init {
            return Fail(outputType: LoginView.Model.self,
                        failure: WhoppahUI.LocalizationClientError.couldNotLoad)
                .eraseToEffect()
        }
    }()

    lazy var trackingClient: WhoppahUI.TrackingClient<LoginView.TrackingAction> = {
        .init { trackingAction in
            return .none
        }
    }()
    
    lazy var outboundActionClient: WhoppahUI.OutboundActionClient<LoginView.OutboundAction, Effect<LoginView.Action, Never>> = {
        .init { [weak self] outboundAction in
            return .none.eraseToEffect()
        }
    }()
    
    lazy var defaultEnvironment: LoginView.Environment =  { LoginView.Environment(
        localizationClient: localizationSuccessClient,
        trackingClient: trackingClient,
        outboundActionClient: outboundActionClient,
        mainQueue: scheduler.eraseToAnyScheduler())
    }()

    func testLocalizationClientSuccess() {
        let environment = LoginView.Environment(
            localizationClient: localizationSuccessClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            mainQueue: scheduler.eraseToAnyScheduler())

        let model = LoginView.Model.mock
        
        let testStore = TestStore(initialState:
                                    LoginView.ViewState.initial,
                                  reducer: LoginView.Reducer().reducer,
                                  environment: environment)
        
        testStore.send(.loadContent) {
            $0.loadingState = .loading
        }
        
        advance()
        testStore.receive(.didFinishLoadingContent(.success(model))) {
            $0.model = model
            $0.loadingState = .finished
        }
    }
    
    func testLocalizationClientFailure() {
        let environment = LoginView.Environment(
            localizationClient: localizationFailureClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            mainQueue: scheduler.eraseToAnyScheduler())

        let error = WhoppahUI.LocalizationClientError.couldNotLoad
        
        let testStore = TestStore(initialState:
                                    LoginView.ViewState.initial,
                                  reducer: LoginView.Reducer().reducer,
                                  environment: environment)
        
        testStore.send(.loadContent) {
            $0.loadingState = .loading
        }
        advance()
        testStore.receive(.didFinishLoadingContent(.failure(error))) {
            $0.loadingState = .failed
        }
    }
    
    func testSignInButtonStates() {
        let environment = defaultEnvironment
        let success = Result<String, Error>.success("")
        let failure = Result<String, Error>.failure(TestError.mockError)
        
        let testStore = TestStore(initialState:
                                    LoginView.ViewState.initial,
                                  reducer: LoginView.Reducer().reducer,
                                  environment: environment)
        
        // didTapSignIn
        
        testStore.send(.outboundAction(.didTapSignIn(email: "", password: ""))) {
            $0.mainButtonState = .inProgress
        }
        advance()
        
        testStore.send(.authorizationResponse(success)) {
            $0.mainButtonState = .default
        }
        advance()
        
        testStore.send(.outboundAction(.didTapSignIn(email: "", password: ""))) {
            $0.mainButtonState = .inProgress
        }
        advance()
        
        testStore.send(.authorizationResponse(failure)) {
            $0.authenticationFailedMessageIsVisible = true
            $0.mainButtonState = .default
        }
        advance()
        
        // didTapSendPasswordResetLink
        
        testStore.send(.outboundAction(.didTapSendPasswordResetLink(email: ""))) {
            $0.mainButtonState = .inProgress
            $0.authenticationFailedMessageIsVisible = false
        }
        advance()
        
        testStore.send(.authorizationResponse(success)) {
            $0.authenticationFailedMessageIsVisible = false
            $0.mainButtonState = .default
        }
        advance()
        
        testStore.send(.outboundAction(.didTapSendPasswordResetLink(email: ""))) {
            $0.mainButtonState = .inProgress
        }
        advance()
        
        testStore.send(.authorizationResponse(failure)) {
            $0.authenticationFailedMessageIsVisible = true
            $0.mainButtonState = .default
        }
        advance()
        
        // didTapLoginWithMagicCode
        
        testStore.send(.outboundAction(.didTapLoginWithMagicCode(code: "", email: "", cookie: ""))) {
            $0.mainButtonState = .inProgress
            $0.authenticationFailedMessageIsVisible = false
        }
        advance()
        
        testStore.send(.loginWithMagicLinkResponse(success)) {
            $0.authenticationFailedMessageIsVisible = false
            $0.mainButtonState = .default
        }
        advance()
        
        testStore.send(.outboundAction(.didTapLoginWithMagicCode(code: "", email: "", cookie: ""))) {
            $0.mainButtonState = .inProgress
        }
        advance()
        
        testStore.send(.loginWithMagicLinkResponse(failure)) {
            $0.authenticationFailedMessageIsVisible = false
            $0.magicLinkInvalidMessageIsVisible = true
            $0.mainButtonState = .default
        }
        advance()
    }
    
    func testMagicLinkSuccessResponse() {
        let environment = defaultEnvironment
        let mockToken = UUID().uuidString
        let success = Result<String, Error>.success(mockToken)
        
        let testStore = TestStore(initialState:
                                    LoginView.ViewState.initial,
                                  reducer: LoginView.Reducer().reducer,
                                  environment: environment)

        testStore.send(.requestMagicLinkTokenResponse(success)) {
            $0.magicLinkCookie = mockToken
        }
        advance()
    }
    
    func testMagicLinkFailureResponse() {
        let environment = defaultEnvironment
        let failure = Result<String, Error>.failure(TestError.mockError)
        
        let testStore = TestStore(initialState:
                                    LoginView.ViewState.initial,
                                  reducer: LoginView.Reducer().reducer,
                                  environment: environment)

        testStore.send(.requestMagicLinkTokenResponse(failure))
        advance()
    }
}
