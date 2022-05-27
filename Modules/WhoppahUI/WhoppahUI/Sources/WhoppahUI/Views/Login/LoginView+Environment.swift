//  
//  LoginView+Environment.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import ComposableArchitecture

public extension LoginView {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<LoginView.Model>
        var trackingClient: WhoppahUI.TrackingClient<LoginView.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<LoginView.OutboundAction, Effect<LoginView.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<LoginView.Model>,
                    trackingClient: WhoppahUI.TrackingClient<LoginView.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<LoginView.OutboundAction, Effect<LoginView.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}


public extension LoginView.Environment {
    static let mock = Self(localizationClient: LoginView.mockLocalizationClient,
                           trackingClient: LoginView.mockTrackingClient,
                           outboundActionClient: LoginView.mockOutboundActionClient,
                           mainQueue: .main)
}
