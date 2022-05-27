//  
//  ContextualSignupDialog+Environment.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import ComposableArchitecture

public extension ContextualSignupDialog {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<ContextualSignupDialog.Model>
        var trackingClient: WhoppahUI.TrackingClient<ContextualSignupDialog.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<ContextualSignupDialog.OutboundAction, Effect<ContextualSignupDialog.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<ContextualSignupDialog.Model>,
                    trackingClient: WhoppahUI.TrackingClient<ContextualSignupDialog.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<ContextualSignupDialog.OutboundAction, Effect<ContextualSignupDialog.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}


public extension ContextualSignupDialog.Environment {
    static let mock = Self(localizationClient: ContextualSignupDialog.mockLocalizationClient,
                           trackingClient: ContextualSignupDialog.mockTrackingClient,
                           outboundActionClient: ContextualSignupDialog.mockOutboundActionClient,
                           mainQueue: .main)
}
