//  
//  LoginView+Action.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import Foundation

public extension LoginView {
    enum TrackingAction: Equatable {
        case didLoginSuccessfully
//        case loginDidFail(error: Error)
        case didTapForgotPassword
    }        

    enum OutboundAction: Equatable {
        case didTapForgotPassword
        case didTapSignInOption(id: Model.SignInOptionId)
        case didTapSignIn(email: String, password: String)
        case didTapSendPasswordResetLink(email: String)
        case didTapSendMagicLinkCode(email: String)
        case didTapLoginWithMagicCode(code: String, email: String, cookie: String)
        case didTapSignInAgain
        case dismissView
        case dismissViewAndReopen
    }

    enum Action: Equatable {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
        case authorizationResponse(Result<String, Error>)
        case requestMagicLinkTokenResponse(Result<String, Error>)
        case loginWithMagicLinkResponse(Result<String, Error>)
        case didSendForgotPasswordEmail(Result<String, Error>)
        
        public static func == (lhs: LoginView.Action, rhs: LoginView.Action) -> Bool {
            switch (lhs, rhs) {
            case (.loadContent, .loadContent):
                return true
            case (let .didFinishLoadingContent(lResult), let .didFinishLoadingContent(rResult)):
                return compare(lResult, rResult)
            case (let .trackingAction(lAction), let .trackingAction(rAction)):
                return lAction == rAction
            case (let .outboundAction(lAction), let .outboundAction(rAction)):
                return lAction == rAction
            case (let .authorizationResponse(lResult), let .authorizationResponse(rResult)):
                return compare(lResult, rResult)
            case (let .requestMagicLinkTokenResponse(lResult), let .requestMagicLinkTokenResponse(rResult)):
                return compare(lResult, rResult)
            case (let .loginWithMagicLinkResponse(lResult), let .loginWithMagicLinkResponse(rResult)):
                return compare(lResult, rResult)
            case (let .didSendForgotPasswordEmail(lResult), let .didSendForgotPasswordEmail(rResult)):
                return compare(lResult, rResult)
            default:
                return false
            }
        }
    }
}
