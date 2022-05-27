//  
//  WhoppahReviews+Action.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import Foundation

public extension WhoppahReviews {
    enum TrackingAction {
        case myTrackingAction
    }        

    enum OutboundAction {
        case myOutboundAction
    }

    enum Action {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
    }
}
