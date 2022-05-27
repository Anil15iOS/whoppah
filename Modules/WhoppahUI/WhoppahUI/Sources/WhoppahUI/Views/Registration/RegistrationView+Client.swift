//  
//  RegistrationView+Client.swift
//  WhoppahUIIntegrationTest
//
//  Created by Dennis Ippel on 17/01/2022.
//

import ComposableArchitecture
import Combine

public extension RegistrationView {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<RegistrationView.TrackingAction> { action in
            .none.eraseToEffect()
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<RegistrationView.OutboundAction, Effect<RegistrationView.Action, Never>> { action in
        switch action {
        case .didSubmitUsername:
            return Just(true)
                .setFailureType(to: Error.self)
                .catchToEffect(RegistrationView.Action.emailAvailabilityResponse)
        default:
            return .none.eraseToEffect()
        }
    }
}
