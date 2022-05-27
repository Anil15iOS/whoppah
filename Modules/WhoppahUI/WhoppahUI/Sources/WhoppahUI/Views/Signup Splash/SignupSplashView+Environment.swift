//  
//  SignupSplashView+Environment.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import ComposableArchitecture

public extension SignupSplashView {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<SignupSplashView.Model>
        var trackingClient: WhoppahUI.TrackingClient<SignupSplashView.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<SignupSplashView.OutboundAction, Effect<SignupSplashView.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<SignupSplashView.Model>,
                    trackingClient: WhoppahUI.TrackingClient<SignupSplashView.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<SignupSplashView.OutboundAction, Effect<SignupSplashView.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}


public extension SignupSplashView.Environment {
    static let mock = Self(localizationClient: SignupSplashView.mockLocalizationClient,
                           trackingClient: SignupSplashView.mockTrackingClient,
                           outboundActionClient: SignupSplashView.mockOutboundActionClient,
                           mainQueue: .main)
}
