//  
//  ContextualSignupDialog+Action.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import Foundation

public extension ContextualSignupDialog {
    enum TrackingAction {
        case didTapCloseButton
        case didTapLogInButton
        case didTapRegisterButton
    }        

    enum OutboundAction {
        case didTapCloseButton
        case didTapLogInButton
        case didTapRegisterButton
    }

    enum Action {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
    }
}
