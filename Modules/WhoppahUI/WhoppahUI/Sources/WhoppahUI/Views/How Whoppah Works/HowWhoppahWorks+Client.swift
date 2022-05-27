//
//  HowWhoppahWorks+Client.swift
//  
//
//  Created by Dennis Ippel on 08/11/2021.
//

import ComposableArchitecture
import Combine

public extension HowWhoppahWorks {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<HowWhoppahWorks.Model>(
        fetch: {
            Effect(value: HowWhoppahWorks.Model.mock)
                .setFailureType(to: WhoppahUI.LocalizationClientError.self)
                .eraseToEffect()
        }
    )
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<HowWhoppahWorks.TrackingAction> { action in
            .none.eraseToEffect()
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<HowWhoppahWorks.OutboundAction, Effect<HowWhoppahWorks.Action, Never>> { action in
            .none.eraseToEffect()
    }
}
