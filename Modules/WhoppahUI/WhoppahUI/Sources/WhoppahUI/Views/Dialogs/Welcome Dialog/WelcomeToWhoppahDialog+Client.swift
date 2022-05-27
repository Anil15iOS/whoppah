//  
//  WelcomeToWhoppahDialog+Client.swift
//  
//
//  Created by Dennis Ippel on 15/02/2022.
//

import ComposableArchitecture
import Combine

public extension WelcomeToWhoppahDialog {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<WelcomeToWhoppahDialogModel> {
        Effect(value: WelcomeToWhoppahDialog.NewUserModel.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<WelcomeToWhoppahDialog.TrackingAction> { action in
            .none.eraseToEffect()
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<WelcomeToWhoppahDialog.OutboundAction, Effect<WelcomeToWhoppahDialog.Action, Never>> { action in
            .none.eraseToEffect()
    }
}
