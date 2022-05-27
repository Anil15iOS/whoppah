//  
//  MerchantProductsView+Client.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import ComposableArchitecture
import Combine

public extension MerchantProductsView {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<MerchantProductsView.TrackingAction> { action in
            .none.eraseToEffect()
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<MerchantProductsView.OutboundAction, Effect<MerchantProductsView.Action, Never>> { action in
            .none.eraseToEffect()
    }
}
