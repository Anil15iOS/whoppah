//  
//  RegistrationView+Action.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 17/01/2022.
//

import Foundation
import ComposableArchitecture

public extension RegistrationView {
    enum TrackingAction: Equatable {
        case signUpStart
        case socialSignUpStart
        case signUpSuccess
    }        

    enum OutboundAction: Equatable {
        case didChooseSignUpType(type: Model.SignUpType)
        case didSubmitUsername(userName: String,
                               email: String,
                               phoneNumber: String)
        case didSubmitPassword(password: String)
        case didSubmitBusinessInfo(businessName: String,
                                   firstName: String,
                                   lastName: String,
                                   phoneNumber: String?)
        case didSubmitBussinessAddress(zipCode: String,
                                       street: String,
                                       city: String,
                                       additionalInfo: String,
                                       country: String)
        case didSubmitPhoneNumber(phoneNumber: String)
        case didTapSignUpOption(id: Model.SignUpOptionId)
        case didTapNextButton(email: String,
                              userName: String,
                              phoneNumber: String)
        case didTapSignInNowButton
        case didTapWhoppahTermsOfUse
        case didTapWhoppahPrivacyPolicy
        case didTapPaymentTermsOfUse
        case didTapCloseButton
        case registrationDidFail
        case registrationDidSucceed
        case openLoginView
        case openWelcomeView
        case didRaiseError(error: Error)
        
        public static func == (lhs: RegistrationView.OutboundAction, rhs: RegistrationView.OutboundAction) -> Bool {
            switch(lhs, rhs) {
            case (let .didChooseSignUpType(lSignUpType),
                      let .didChooseSignUpType(rSignUpType)):
                return lSignUpType == rSignUpType
            case (let .didSubmitUsername(lUserName, lEmail, lPhoneNumber),
                      let .didSubmitUsername(rUserName, rEmail, rPhoneNumber)):
                return lUserName == rUserName && lEmail == rEmail && lPhoneNumber == rPhoneNumber
            case (let .didSubmitPassword(lPassword), let .didSubmitPassword(rPassword)):
                return lPassword == rPassword
            case (let .didSubmitBusinessInfo(lBusinessName, lFirstName, lLastName, lPhoneNumber),
                      let .didSubmitBusinessInfo(rBusinessName, rFirstName, rLastName, rPhoneNumber)):
                return lBusinessName == rBusinessName && lFirstName == rFirstName && lLastName == rLastName && lPhoneNumber == rPhoneNumber
            case (let .didSubmitBussinessAddress(lZipCode, lStreet, lCity, lAdditionalInfo, lCountry),
                      let .didSubmitBussinessAddress(rZipCode, rStreet, rCity, rAdditionalInfo, rCountry)):
                return lZipCode == rZipCode && lStreet == rStreet && lCity == rCity && lAdditionalInfo == rAdditionalInfo && lCountry == rCountry
            case (let .didSubmitPhoneNumber(lPhoneNumber), let .didSubmitPhoneNumber(rPhoneNumber)):
                return lPhoneNumber == rPhoneNumber
            case (let .didTapSignUpOption(lId), let .didTapSignUpOption(rId)):
                return lId == rId
            case (let .didTapNextButton(lEmail, lUserName, lPhoneNumber), let .didTapNextButton(rEmail, rUserName, rPhoneNumber)):
                return lEmail == rEmail && lUserName == rUserName && lPhoneNumber == rPhoneNumber
            case (.didTapSignInNowButton, didTapSignInNowButton),
                (.didTapWhoppahTermsOfUse, .didTapWhoppahTermsOfUse),
                (.didTapWhoppahPrivacyPolicy, .didTapWhoppahPrivacyPolicy),
                (.didTapPaymentTermsOfUse, .didTapPaymentTermsOfUse),
                (.didTapCloseButton, .didTapCloseButton),
                (.registrationDidFail, .registrationDidFail),
                (.registrationDidSucceed, .registrationDidSucceed),
                (.openLoginView, .openLoginView),
                (.openWelcomeView, .openWelcomeView):
                return true
            case (let .didRaiseError(lError), let .didRaiseError(rError)):
                return compare(lError, rError)
            default:
                return false
            }
        }
    }

    enum Action: Equatable {
        case loadContent
        case didFinishLoadingContent(Result<Model, WhoppahUI.LocalizationClientError>)
        case trackingAction(TrackingAction)
        case outboundAction(OutboundAction)
        case emailAvailabilityResponse(Result<Bool, Error>)
        case registrationResponse(Result<String, Error>)
        case signInResponse(Result<String, Error>)
        case updateMerchantResponse(Result<UUID, Error>)
        case socialRegistrationResponse(Result<String, Error>)
        case updatePhoneNumberResponse(Result<UUID, Error>)
        
        public static func == (lhs: RegistrationView.Action, rhs: RegistrationView.Action) -> Bool {
            switch(lhs, rhs) {
            case (.loadContent, .loadContent):
                return true
            case (let .didFinishLoadingContent(lResult), let .didFinishLoadingContent(rResult)):
                return compare(lResult, rResult)
            case (let .trackingAction(lAction), let .trackingAction(rAction)):
                return lAction == rAction
            case (let .outboundAction(lAction), let .outboundAction(rAction)):
                return lAction == rAction
            case (let .emailAvailabilityResponse(lResult), let .emailAvailabilityResponse(rResult)):
                return compare(lResult, rResult)
            case (let .registrationResponse(lResult), let .registrationResponse(rResult)):
                return compare(lResult, rResult)
            case (let .signInResponse(lResult), let .signInResponse(rResult)):
                return compare(lResult, rResult)
            case (let .updateMerchantResponse(lResult), let .updateMerchantResponse(rResult)):
                return compare(lResult, rResult)
            case (let .socialRegistrationResponse(lResult), let .socialRegistrationResponse(rResult)):
                return compare(lResult, rResult)
            case (let .updatePhoneNumberResponse(lResult), let .updatePhoneNumberResponse(rResult)):
                return compare(lResult, rResult)
            default:
                return false
            }
        }
    }
}
