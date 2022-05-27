//
//  UpdateAppDialog+Client.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import Foundation
import ComposableArchitecture

public extension UpdateAppDialog {
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<UpdateAppDialog.Model>(
        fetch: {
            Effect(value: UpdateAppDialog.Model.initial)
                .setFailureType(to: WhoppahUI.LocalizationClientError.self)
                .eraseToEffect()
        }
    )
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<UpdateAppDialog.OutboundAction, Effect<UpdateAppDialog.Action, Never>> { outboundAction in
        return .none.eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<UpdateAppDialog.TrackingAction> { trackingAction in
        return .none.eraseToEffect()
    }
}
