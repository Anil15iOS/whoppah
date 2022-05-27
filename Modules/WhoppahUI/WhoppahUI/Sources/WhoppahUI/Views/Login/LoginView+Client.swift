//  
//  LoginView+Client.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import ComposableArchitecture
import Combine

public extension LoginView {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<LoginView.TrackingAction> { action in
        switch action {
        default:
            return .none.eraseToEffect()
        }
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<LoginView.OutboundAction, Effect<LoginView.Action, Never>> { action in
            .none.eraseToEffect()
    }
}
