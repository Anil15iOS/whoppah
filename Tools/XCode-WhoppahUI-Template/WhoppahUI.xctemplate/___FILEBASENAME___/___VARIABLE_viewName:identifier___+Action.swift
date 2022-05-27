//  ___FILEHEADER___

import Foundation

public extension ___VARIABLE_viewName:identifier___ {
    enum TrackingAction {

    }        

    enum OutboundAction {

    }

    enum Action {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
    }
}
