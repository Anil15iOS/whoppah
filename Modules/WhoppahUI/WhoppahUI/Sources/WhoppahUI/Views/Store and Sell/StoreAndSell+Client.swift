//  
//  StoreAndSell+Client.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 13/12/2021.
//

import ComposableArchitecture
import Combine

public extension StoreAndSell {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<StoreAndSell.TrackingAction> { action in
        switch action {
        default:
            return .none.eraseToEffect()
        }
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<StoreAndSell.OutboundAction, Effect<StoreAndSell.Action, Never>> { action in
        switch action {
        default:
            return .none.eraseToEffect()
        }
    }
}
