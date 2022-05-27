//
//  UpdateAppDialog+Environment.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import Foundation
import CombineSchedulers
import ComposableArchitecture

public extension UpdateAppDialog {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<UpdateAppDialog.Model>
        var trackingClient: WhoppahUI.TrackingClient<TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<UpdateAppDialog.OutboundAction, Effect<UpdateAppDialog.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<UpdateAppDialog.Model>,
                    trackingClient: WhoppahUI.TrackingClient<TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<UpdateAppDialog.OutboundAction, Effect<UpdateAppDialog.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}

public extension UpdateAppDialog.Environment {
    static let mock = Self(localizationClient: UpdateAppDialog.mockLocalizationClient,
                           trackingClient: UpdateAppDialog.mockTrackingClient,
                           outboundActionClient: UpdateAppDialog.mockOutboundActionClient,
                           mainQueue: .main)
}
