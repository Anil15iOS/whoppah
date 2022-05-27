//
//  AppMenu+Client.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import ComposableArchitecture
import Combine
import WhoppahModel
import Foundation

public extension AppMenu {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<AppMenu.TrackingAction> { action in
        switch action {
        default:
            return .none.eraseToEffect()
        }
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<AppMenu.OutboundAction, Effect<AppMenu.Action, Never>> { action in
            .none.eraseToEffect()
    }
}
