//  
//  ProductDetailView+Client.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/03/2022.
//

import ComposableArchitecture
import Combine

public extension ProductDetailView {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<ProductDetailView.TrackingAction> { action in
            .none.eraseToEffect()
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<ProductDetailView.OutboundAction, Effect<ProductDetailView.Action, Never>> { action in
            .none.eraseToEffect()
    }
}
