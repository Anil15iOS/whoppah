//  
//  SearchView+Client.swift
//  
//
//  Created by Dennis Ippel on 09/03/2022.
//

import ComposableArchitecture
import Combine
import WhoppahModel
import SwiftUI

public extension SearchView {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<SearchView.TrackingAction> { action in
            .none.eraseToEffect()
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<SearchView.OutboundAction, Effect<SearchView.Action, Never>> { action in
            .none.eraseToEffect()
    }
}
