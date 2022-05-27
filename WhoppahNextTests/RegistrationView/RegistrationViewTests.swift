//
//  RegistrationViewTests.swift
//  WhoppahNextTests
//
//  Created by Dennis Ippel on 03/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import XCTest
import ComposableArchitecture
import WhoppahUI
import Combine

@testable import Testing_Debug

class RegistrationViewTests: WhoppahTestBase {
    lazy var localizationSuccessClient: WhoppahUI.LocalizationClient<RegistrationView.Model> = {
        .init {
            return Effect(value: RegistrationView.Model.mock)
                .setFailureType(to: WhoppahUI.LocalizationClientError.self)
                .eraseToEffect()
        }
    }()
    
    lazy var localizationFailureClient: WhoppahUI.LocalizationClient<RegistrationView.Model> = {
        .init {
            return Fail(outputType: RegistrationView.Model.self,
                        failure: WhoppahUI.LocalizationClientError.couldNotLoad)
                .eraseToEffect()
        }
    }()

    lazy var trackingClient: WhoppahUI.TrackingClient<RegistrationView.TrackingAction> = {
        .init { trackingAction in
            return .none
        }
    }()
    
    lazy var outboundActionClient: WhoppahUI.OutboundActionClient<RegistrationView.OutboundAction, Effect<RegistrationView.Action, Never>> = {
        .init { [weak self] outboundAction in
            return .none.eraseToEffect()
        }
    }()
    
    lazy var defaultEnvironment: RegistrationView.Environment =  { RegistrationView.Environment(
        localizationClient: localizationSuccessClient,
        trackingClient: trackingClient,
        outboundActionClient: outboundActionClient,
        mainQueue: scheduler.eraseToAnyScheduler())
    }()
    
    func testLocalizationClientSuccess() {
        let environment = RegistrationView.Environment(
            localizationClient: localizationSuccessClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            mainQueue: scheduler.eraseToAnyScheduler())

        let model = RegistrationView.Model.mock
        
        let testStore = TestStore(initialState:
                                    RegistrationView.ViewState.initial,
                                  reducer: RegistrationView.Reducer().reducer,
                                  environment: environment)
        
        testStore.send(.loadContent)
        
        advance()
        testStore.receive(.didFinishLoadingContent(.success(model))) {
            $0.model = model
            $0.loadingState = .finished
        }
    }
    
    func testLocalizationClientFailure() {
        let environment = RegistrationView.Environment(
            localizationClient: localizationFailureClient,
            trackingClient: trackingClient,
            outboundActionClient: outboundActionClient,
            mainQueue: scheduler.eraseToAnyScheduler())

        let error = WhoppahUI.LocalizationClientError.couldNotLoad
        
        let testStore = TestStore(initialState:
                                    RegistrationView.ViewState.initial,
                                  reducer: RegistrationView.Reducer().reducer,
                                  environment: environment)
        
        testStore.send(.loadContent)
        advance()
        testStore.receive(.didFinishLoadingContent(.failure(error))) {
            $0.loadingState = .failed
        }
    }
}
