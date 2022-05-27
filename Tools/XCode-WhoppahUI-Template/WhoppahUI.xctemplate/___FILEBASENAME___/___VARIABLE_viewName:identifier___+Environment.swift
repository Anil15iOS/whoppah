//  ___FILEHEADER___

import ComposableArchitecture

public extension ___VARIABLE_viewName:identifier___ {
    struct Environment {
        var localizationClient: WhoppahUI.LocalizationClient<___VARIABLE_viewName:identifier___.Model>
        var trackingClient: WhoppahUI.TrackingClient<___VARIABLE_viewName:identifier___.TrackingAction>
        var outboundActionClient: WhoppahUI.OutboundActionClient<___VARIABLE_viewName:identifier___.OutboundAction, Effect<___VARIABLE_viewName:identifier___.Action, Never>>
        var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(localizationClient: WhoppahUI.LocalizationClient<___VARIABLE_viewName:identifier___.Model>,
                    trackingClient: WhoppahUI.TrackingClient<___VARIABLE_viewName:identifier___.TrackingAction>,
                    outboundActionClient: WhoppahUI.OutboundActionClient<___VARIABLE_viewName:identifier___.OutboundAction, Effect<___VARIABLE_viewName:identifier___.Action, Never>>,
                    mainQueue: AnySchedulerOf<DispatchQueue>)
        {
            self.localizationClient = localizationClient
            self.trackingClient = trackingClient
            self.outboundActionClient = outboundActionClient
            self.mainQueue = mainQueue
        }
    }
}


public extension ___VARIABLE_viewName:identifier___.Environment {
    static let mock = Self(localizationClient: ___VARIABLE_viewName:identifier___.mockLocalizationClient,
                           trackingClient: ___VARIABLE_viewName:identifier___.mockTrackingClient,
                           outboundActionClient: ___VARIABLE_viewName:identifier___.mockOutboundActionClient,
                           mainQueue: .main)
}