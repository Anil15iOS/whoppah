//
//  RegistrationView+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 19/01/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahUI
import WhoppahLocalization

extension RegistrationView.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        let common = Common(
            nextButtonTitle: l.commonNextStepButton(),
            invalidEmail: l.commonInvalidEmail(),
            missingEmail: l.commonMissingEmail(),
            missingUsername: l.commonMissingProfileName(),
            phoneNumberRequired: l.commonMissingPhoneNumber(),
            invalidPhoneNumber: l.yourAccountSettingsValidationInvalidPhoneNumber(),
            doneButtonTitle: l.create_ad_camera_btn_save(),
            invalidPasswordRepeat: l.error_invalid_pass_repeat(),
            missingBusinessName: l.commonMissingCompanyName(),
            missingFirstName: l.commonMissingFirstName(),
            missingLastName: l.commonMissingLastName(),
            missingZipCode: l.commonMissingAddressPostcode(),
            missingStreet: l.commonMissingAddressStreet(),
            missingCity: l.commonMissingAddressCity(),
            missingCountry: l.commonMissingAddressCountry())
        
        let chooseSignupType = ChooseSignupType(
            title: l.authAccountTypeChooserTitle(),
            navigationTitle: l.commonCreateAccount(),
            person: l.authAccountTypeChooserPersonTitle(),
            business: l.authAccountTypeChooserBusinessTitle())
        
        let signUpOptions = [
            SignUpOption(id: .apple,
                         title: l.authSignUpApple(),
                         foregroundColor: WhoppahTheme.Color.base1,
                         iconName: "apple_icon"),
            SignUpOption(id: .google,
                         title: l.authSignUpGoogle(),
                         foregroundColor: WhoppahTheme.Color.base5,
                         iconName: "google_icon"),
            SignUpOption(id: .facebook,
                         title: l.authSignUpFacebook(),
                         foregroundColor: .blue,
                         iconName: "facebook_icon")
        ]
        
        let enterUsernameEmail = EnterUsernameEmail(
            navigationTitle: l.commonCreateAccount(),
            signUpOptions: signUpOptions,
            otherOptionsTitle: l.commonOr(),
            usernamePlaceholder: l.auth_sign_up1_name(),
            emailPlaceholder: l.authSignInEmailPlaceholder(),
            emailAlreadyInUse: l.authRegistrationEmailExists(),
            whoppahIsNotAllowed: l.registerBlockWhoppah(),
            logInNow: l.authRegistrationLogInNow(),
            fillInPhoneNumberTitle: l.authSignUpFillInPhoneNumber())
        
        let requirements = PasswordRequirements(
            meetsMinimumCharacterCountRequirement: l.common_password_rule1(),
            meetsAtLeastOneLowerCaseRequirement: l.common_password_rule2(),
            meetsAtLeastOneDigitRequirement: l.common_password_rule3(),
            meetsAtLeaseOneUpperCaseRequirement: l.common_password_rule4())
            
        let choosePassword = ChoosePassword(
            title: l.auth_sign_up2_password(),
            navigationTitle: l.commonCreateAccount(),
            requirements: requirements,
            repeatPasswordTitle: l.auth_sign_up2_repeat_password(),
            agreeToWhoppahTerms: [
                l.signupAgreeWhoppahTermsPart1(),
                l.signupAgreeWhoppahTermsPart2(),
                l.signupAgreeWhoppahTermsPart3(),
                l.signupAgreeWhoppahTermsPart4(),
                l.signupAgreeWhoppahTermsPart5()
            ],
            agreeToPaymentTerms: [
                l.signupAgreeStripeTermsPart1(),
                l.signupAgreeStripeTermsPart2(),
                l.signupAgreeStripeTermsPart3()
            ])
        
        let businessInfo = BusinessInfo(
            title: l.authSignUp3FillInBusinessInfo(),
            navigationTitle: l.authSignUp3FillInBusinessInfo(),
            businessNamePlaceholder: l.authSignUp3BusinessName(),
            contactPersonTitle: l.authSignUp4Title(),
            firstNamePlaceholder: l.authSignUp3FirstName(),
            lastNamePlaceholder: l.authSignUp3LastName())
        
        let countryList: [Country] = [
            Country(code: "NL", name: l.common_netherlands()),
            Country(code: "BE", name: l.common_belgium()),
            Country(code: "GB", name: l.common_united_kingdom()),
            Country(code: "DE", name: l.common_germany()),
            Country(code: "FR", name: l.common_france()),
            Country(code: "IT", name: l.common_italy())
        ]
            
        let businessAddress = BusinessAddress(
            title: l.authSignUpFillInAddress(),
            navigationTitle: l.authSignUp3FillInBusinessInfo(),
            zipCodePlaceholder: l.authSignUpPostalCode(),
            streetPlaceholder: l.authSignUpStreetHouseNumber(),
            additionalInfoPlaceholder: l.authSignUpAdditionalAddressInfo(),
            cityPlaceholder: l.add_address_city_placeholder(),
            countryPlaceholder: l.commonCountry(),
            countryList: countryList)
        
        return .init(
            common: common,
            chooseSignupType: chooseSignupType,
            enterUsernamePassword: enterUsernameEmail,
            choosePassword: choosePassword,
            businessInfo: businessInfo,
            businessAddress: businessAddress)
    }
}
