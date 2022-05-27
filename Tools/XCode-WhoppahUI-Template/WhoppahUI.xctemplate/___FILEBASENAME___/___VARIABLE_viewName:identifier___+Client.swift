//  ___FILEHEADER___

import ComposableArchitecture
import Combine

public extension ___VARIABLE_viewName:identifier___ {
    
    static let mockLocalizationClient = WhoppahUI.LocalizationClient<Model> {
        Effect(value: Model.mock)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    static let mockTrackingClient = WhoppahUI.TrackingClient<___VARIABLE_viewName:identifier___.TrackingAction> { action in
            .none.eraseToEffect()
    }
    
    static let mockOutboundActionClient = WhoppahUI.OutboundActionClient<___VARIABLE_viewName:identifier___.OutboundAction, Effect<___VARIABLE_viewName:identifier___.Action, Never>> { action in
            .none.eraseToEffect()
    }
}