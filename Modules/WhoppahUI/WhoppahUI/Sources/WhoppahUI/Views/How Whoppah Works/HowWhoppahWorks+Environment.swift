//
//  HowWhoppahWorks+Environment.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 08/11/2021.
//

import ComposableArchitecture

public extension HowWhoppahWorks {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<HowWhoppahWorks.Model>
        var trackingClient: WhoppahUI.TrackingClient<HowWhoppahWorks.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<HowWhoppahWorks.OutboundAction, Effect<HowWhoppahWorks.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<HowWhoppahWorks.Model>,
                    trackingClient: WhoppahUI.TrackingClient<HowWhoppahWorks.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<HowWhoppahWorks.OutboundAction, Effect<HowWhoppahWorks.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}


public extension HowWhoppahWorks.Environment {
    static let mock = Self(localizationClient: HowWhoppahWorks.mockLocalizationClient,
                           trackingClient: HowWhoppahWorks.mockTrackingClient,
                           outboundActionClient: HowWhoppahWorks.mockOutboundActionClient,
                           mainQueue: .main)
}
