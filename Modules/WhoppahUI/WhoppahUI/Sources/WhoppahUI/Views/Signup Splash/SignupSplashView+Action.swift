//  
//  SignupSplashView+Action.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import Foundation

public extension SignupSplashView {
    enum TrackingAction {
        case didTapLogInButton
        case didTapRegisterButton
        case didTapGuestButton
    }        

    enum OutboundAction {
        case didTapLogInButton
        case didTapRegisterButton
        case didTapGuestButton
    }

    enum Action {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
    }
}
