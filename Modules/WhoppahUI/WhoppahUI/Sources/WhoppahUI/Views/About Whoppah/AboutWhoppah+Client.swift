//  
//  AboutWhoppah+Client.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import ComposableArchitecture
import Combine

public extension AboutWhoppah {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<AboutWhoppah.TrackingAction> { action in
        switch action {
        default:
            return .none.eraseToEffect()
        }
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<AboutWhoppah.OutboundAction, Effect<AboutWhoppah.Action, Never>> { action in
            .none.eraseToEffect()
    }
}
