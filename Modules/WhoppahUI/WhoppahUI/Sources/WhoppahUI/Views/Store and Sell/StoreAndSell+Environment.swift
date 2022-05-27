//  
//  StoreAndSell+Environment.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 13/12/2021.
//

import ComposableArchitecture

public extension StoreAndSell {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<StoreAndSell.Model>
        var trackingClient: WhoppahUI.TrackingClient<StoreAndSell.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<StoreAndSell.OutboundAction, Effect<StoreAndSell.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<StoreAndSell.Model>,
                    trackingClient: WhoppahUI.TrackingClient<StoreAndSell.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<StoreAndSell.OutboundAction, Effect<StoreAndSell.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}

public extension StoreAndSell.Environment {
    static let mock = Self(localizationClient: StoreAndSell.mockLocalizationClient,
                           trackingClient: StoreAndSell.mockTrackingClient,
                           outboundActionClient: StoreAndSell.mockOutboundActionClient,
                           mainQueue: .main)
}
