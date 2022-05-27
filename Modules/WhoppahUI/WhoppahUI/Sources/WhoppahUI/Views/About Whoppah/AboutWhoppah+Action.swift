//  
//  AboutWhoppah+Action.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import Foundation

public extension AboutWhoppah {
    enum TrackingAction {
        case mailToSupportTapped
    }        

    enum OutboundAction {
        case mailToSupportTapped(String)
    }

    enum Action {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
    }
}
