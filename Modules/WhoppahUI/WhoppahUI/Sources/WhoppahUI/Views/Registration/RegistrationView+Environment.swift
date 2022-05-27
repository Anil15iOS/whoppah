//  
//  RegistrationView+Environment.swift
//  WhoppahUIIntegrationTest
//
//  Created by Dennis Ippel on 17/01/2022.
//

import ComposableArchitecture

public extension RegistrationView {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<RegistrationView.Model>
        var trackingClient: WhoppahUI.TrackingClient<RegistrationView.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<RegistrationView.OutboundAction, Effect<RegistrationView.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<RegistrationView.Model>,
                    trackingClient: WhoppahUI.TrackingClient<RegistrationView.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<RegistrationView.OutboundAction, Effect<RegistrationView.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}

public extension RegistrationView.Environment {
    static let mock = Self(localizationClient: RegistrationView.mockLocalizationClient,
                           trackingClient: RegistrationView.mockTrackingClient,
                           outboundActionClient: RegistrationView.mockOutboundActionClient,
                           mainQueue: .main)
}
