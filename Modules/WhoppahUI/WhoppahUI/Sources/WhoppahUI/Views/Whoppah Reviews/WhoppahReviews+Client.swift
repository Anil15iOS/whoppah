//  
//  WhoppahReviews+Client.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import ComposableArchitecture
import Combine

public extension WhoppahReviews {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<WhoppahReviews.TrackingAction> { action in
        switch action {
        default:
            return .none.eraseToEffect()
        }
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<WhoppahReviews.OutboundAction, Effect<WhoppahReviews.Action, Never>> { action in
        switch action {
        default:
            return .none.eraseToEffect()
        }
    }
}
