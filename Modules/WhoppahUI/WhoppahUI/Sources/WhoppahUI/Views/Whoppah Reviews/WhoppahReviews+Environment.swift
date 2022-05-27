//  
//  WhoppahReviews+Environment.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import ComposableArchitecture

public extension WhoppahReviews {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<WhoppahReviews.Model>
        var trackingClient: WhoppahUI.TrackingClient<WhoppahReviews.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<WhoppahReviews.OutboundAction, Effect<WhoppahReviews.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<WhoppahReviews.Model>,
                    trackingClient: WhoppahUI.TrackingClient<WhoppahReviews.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<WhoppahReviews.OutboundAction, Effect<WhoppahReviews.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}


public extension WhoppahReviews.Environment {
    static let mock = Self(localizationClient: WhoppahReviews.mockLocalizationClient,
                           trackingClient: WhoppahReviews.mockTrackingClient,
                           outboundActionClient: WhoppahReviews.mockOutboundActionClient,
                           mainQueue: .main)
}
