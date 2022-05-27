//  
//  WelcomeToWhoppahDialog+Action.swift
//  
//
//  Created by Dennis Ippel on 15/02/2022.
//

import Foundation

public extension WelcomeToWhoppahDialog {
    enum TrackingAction {
        case didTapCloseButton
        case didTapCreateAdButton
        case didTapDiscoverDesignButton
    }

    enum OutboundAction {
        case didTapCloseButton
        case didTapCreateAdButton
        case didTapDiscoverDesignButton
    }

    enum Action {
        case loadContent
        case didFinishLoadingContent(Result<WelcomeToWhoppahDialogModel, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
    }
}
