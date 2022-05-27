//
//  AppMenu+Environment.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import ComposableArchitecture
import WhoppahModel

public extension AppMenu {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<AppMenu.Model>
        var trackingClient: WhoppahUI.TrackingClient<AppMenu.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<AppMenu.OutboundAction, Effect<AppMenu.Action, Never>>
        var categoriesClient: WhoppahUI.CategoriesClient
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<AppMenu.Model>,
                    trackingClient: WhoppahUI.TrackingClient<AppMenu.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<AppMenu.OutboundAction, Effect<AppMenu.Action, Never>>,
                    categoriesClient: WhoppahUI.CategoriesClient,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.categoriesClient = categoriesClient

            self.mainQueue = mainQueue
        }
    }
}

public extension AppMenu.Environment {
    static let mock = Self(localizationClient: AppMenu.mockLocalizationClient,
                           trackingClient: AppMenu.mockTrackingClient,
                           outboundActionClient: AppMenu.mockOutboundActionClient,
                           categoriesClient: WhoppahUI.CategoriesClient.mockCategoriesClient,
                           mainQueue: .main)
}
