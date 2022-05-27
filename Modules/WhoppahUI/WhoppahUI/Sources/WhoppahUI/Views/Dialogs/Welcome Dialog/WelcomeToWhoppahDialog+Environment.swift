//  
//  WelcomeToWhoppahDialog+Environment.swift
//  
//
//  Created by Dennis Ippel on 15/02/2022.
//

import ComposableArchitecture

public extension WelcomeToWhoppahDialog {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<WelcomeToWhoppahDialogModel>
        var trackingClient: WhoppahUI.TrackingClient<WelcomeToWhoppahDialog.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<WelcomeToWhoppahDialog.OutboundAction, Effect<WelcomeToWhoppahDialog.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<WelcomeToWhoppahDialogModel>,
                    trackingClient: WhoppahUI.TrackingClient<WelcomeToWhoppahDialog.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<WelcomeToWhoppahDialog.OutboundAction, Effect<WelcomeToWhoppahDialog.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}


public extension WelcomeToWhoppahDialog.Environment {
    static let mock = Self(localizationClient: WelcomeToWhoppahDialog.mockLocalizationClient,
                           trackingClient: WelcomeToWhoppahDialog.mockTrackingClient,
                           outboundActionClient: WelcomeToWhoppahDialog.mockOutboundActionClient,
                           mainQueue: .main)
}
