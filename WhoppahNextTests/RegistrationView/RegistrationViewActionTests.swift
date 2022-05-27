//
//  RegistrationViewActionTests.swift
//  WhoppahNextTests
//
//  Created by Dennis Ippel on 10/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import XCTest
import ComposableArchitecture
import WhoppahUI
import Combine

@testable import Testing_Debug

class RegistrationViewActionTests: WhoppahTestBase {
    enum TestError: Error {
        case testError1
        case testError2
    }
    
    func testOutboundActionEquality() {
        var lAction: RegistrationView.OutboundAction
        var rAction: RegistrationView.OutboundAction
        
        lAction = .didChooseSignUpType(type: .business)
        rAction = .didChooseSignUpType(type: .individual)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
        
        lAction = .didSubmitUsername(userName: UUID().uuidString,
                                     email: UUID().uuidString,
                                     phoneNumber: UUID().uuidString)
        rAction = .didSubmitUsername(userName: UUID().uuidString,
                                     email: UUID().uuidString,
                                     phoneNumber: UUID().uuidString)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)

        lAction = .didSubmitPassword(password: UUID().uuidString)
        rAction = .didSubmitPassword(password: UUID().uuidString)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
        
        lAction = .didSubmitBusinessInfo(businessName: UUID().uuidString,
                                         firstName: UUID().uuidString,
                                         lastName: UUID().uuidString,
                                         phoneNumber: UUID().uuidString)
        rAction = .didSubmitBusinessInfo(businessName: UUID().uuidString,
                                         firstName: UUID().uuidString,
                                         lastName: UUID().uuidString,
                                         phoneNumber: UUID().uuidString)

        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
        
        lAction = .didSubmitBussinessAddress(zipCode: UUID().uuidString,
                                             street: UUID().uuidString,
                                             city: UUID().uuidString,
                                             additionalInfo: UUID().uuidString,
                                             country: UUID().uuidString)
        rAction = .didSubmitBussinessAddress(zipCode: UUID().uuidString,
                                             street: UUID().uuidString,
                                             city: UUID().uuidString,
                                             additionalInfo: UUID().uuidString,
                                             country: UUID().uuidString)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)

        lAction = .didSubmitPhoneNumber(phoneNumber: UUID().uuidString)
        rAction = .didSubmitPhoneNumber(phoneNumber: UUID().uuidString)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)

        lAction = .didTapSignUpOption(id: .apple)
        rAction = .didTapSignUpOption(id: .facebook)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
        
        lAction = .didTapNextButton(email: UUID().uuidString,
                                    userName: UUID().uuidString,
                                    phoneNumber: UUID().uuidString)
        rAction = .didTapNextButton(email: UUID().uuidString,
                                    userName: UUID().uuidString,
                                    phoneNumber: UUID().uuidString)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)

        lAction = .didRaiseError(error: TestError.testError1)
        rAction = .didRaiseError(error: TestError.testError2)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
        
        lAction = .didTapSignInNowButton
        rAction = .didTapSignInNowButton
        XCTAssertTrue(lAction == rAction)

        lAction = .didTapWhoppahTermsOfUse
        rAction = .didTapWhoppahTermsOfUse
        XCTAssertTrue(lAction == rAction)
        
        lAction = .didTapWhoppahPrivacyPolicy
        rAction = .didTapWhoppahPrivacyPolicy
        XCTAssertTrue(lAction == rAction)
        
        lAction = .didTapPaymentTermsOfUse
        rAction = .didTapPaymentTermsOfUse
        XCTAssertTrue(lAction == rAction)

        lAction = .didTapCloseButton
        rAction = .didTapCloseButton
        XCTAssertTrue(lAction == rAction)
        
        lAction = .registrationDidFail
        rAction = .registrationDidFail
        XCTAssertTrue(lAction == rAction)

        lAction = .registrationDidSucceed
        rAction = .registrationDidSucceed
        XCTAssertTrue(lAction == rAction)

        lAction = .openLoginView
        rAction = .openLoginView
        XCTAssertTrue(lAction == rAction)
        
        lAction = .openWelcomeView
        rAction = .openWelcomeView
        XCTAssertTrue(lAction == rAction)
    }
    
    func testActionEquality() {
        var lAction: RegistrationView.Action
        var rAction: RegistrationView.Action
        
        lAction = .loadContent
        rAction = .loadContent
        
        XCTAssertTrue(lAction == lAction)

        lAction = .didFinishLoadingContent(Result<RegistrationView.Model, WhoppahUI.LocalizationClientError>.success(.mock))
        rAction = .didFinishLoadingContent(Result<RegistrationView.Model, WhoppahUI.LocalizationClientError>.success(.initial))
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)

        lAction = .trackingAction(.signUpStart)
        rAction = .trackingAction(.signUpSuccess)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
        
        lAction = .outboundAction(.openWelcomeView)
        rAction = .outboundAction(.openLoginView)
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
        
        lAction = .emailAvailabilityResponse(Result<Bool, Error>.success(true))
        rAction = .emailAvailabilityResponse(Result<Bool, Error>.success(false))
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
        
        lAction = .registrationResponse(Result<String, Error>.success(UUID().uuidString))
        rAction = .registrationResponse(Result<String, Error>.success(UUID().uuidString))
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
        
        lAction = .signInResponse(Result<String, Error>.success(UUID().uuidString))
        rAction = .signInResponse(Result<String, Error>.success(UUID().uuidString))
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)

        lAction = .updateMerchantResponse(Result<UUID, Error>.success(UUID()))
        rAction = .updateMerchantResponse(Result<UUID, Error>.success(UUID()))
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)

        lAction = .socialRegistrationResponse(Result<String, Error>.success(UUID().uuidString))
        rAction = .socialRegistrationResponse(Result<String, Error>.success(UUID().uuidString))
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)

        lAction = .updatePhoneNumberResponse(Result<UUID, Error>.success(UUID()))
        rAction = .updatePhoneNumberResponse(Result<UUID, Error>.success(UUID()))
        
        XCTAssertTrue(lAction == lAction)
        XCTAssertFalse(lAction == rAction)
    }
}
