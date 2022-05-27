//  
//  AboutWhoppah+Environment.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import ComposableArchitecture

public extension AboutWhoppah {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<AboutWhoppah.Model>
        var trackingClient: WhoppahUI.TrackingClient<AboutWhoppah.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<AboutWhoppah.OutboundAction, Effect<AboutWhoppah.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<AboutWhoppah.Model>,
                    trackingClient: WhoppahUI.TrackingClient<AboutWhoppah.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<AboutWhoppah.OutboundAction, Effect<AboutWhoppah.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}


public extension AboutWhoppah.Environment {
    static let mock = Self(localizationClient: AboutWhoppah.mockLocalizationClient,
                           trackingClient: AboutWhoppah.mockTrackingClient,
                           outboundActionClient: AboutWhoppah.mockOutboundActionClient,
                           mainQueue: .main)
}
