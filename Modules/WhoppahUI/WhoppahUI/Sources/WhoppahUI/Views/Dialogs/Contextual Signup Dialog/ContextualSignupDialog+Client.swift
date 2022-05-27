//  
//  ContextualSignupDialog+Client.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import ComposableArchitecture
import Combine

public extension ContextualSignupDialog {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<ContextualSignupDialog.TrackingAction> { action in
            .none.eraseToEffect()
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<ContextualSignupDialog.OutboundAction, Effect<ContextualSignupDialog.Action, Never>> { action in
            .none.eraseToEffect()
    }
}
