//  
//  RegistrationView+MockData.swift
//  WhoppahUIIntegrationTest
//
//  Created by Dennis Ippel on 17/01/2022.
//

import Foundation

public extension RegistrationView.Model {
    static var mock: Self {
        let common = Common(
            nextButtonTitle: "Next step",
            invalidEmail: "Invalid email",
            missingEmail: "Email is required",
            missingUsername: "Missing user name",
            phoneNumberRequired: "Phone number is required",
            invalidPhoneNumber: "Invalid phone number",
            doneButtonTitle: "Done",
            invalidPasswordRepeat: "Passwords do not match",
            missingBusinessName: "Company name is required",
            missingFirstName: "Enter your first name",
            missingLastName: "Enter your surname",
            missingZipCode: "Missing zipcode",
            missingStreet: "Missing street",
            missingCity: "Missing city",
            missingCountry: "Missing country")
        
        let chooseSignupType = ChooseSignupType(
            title: "I'm signing up as...",
            navigationTitle: "Create account",
            person: "Person",
            business: "Business")
        
        let signUpOptions = [
            SignUpOption(id: .apple,
                         title: "Continue with Apple",
                         foregroundColor: WhoppahTheme.Color.base1,
                         iconName: "apple_icon"),
            SignUpOption(id: .google,
                         title: "Continue with Google",
                         foregroundColor: WhoppahTheme.Color.base5,
                         iconName: "google_icon"),
            SignUpOption(id: .facebook,
                         title: "Continue with Facebook",
                         foregroundColor: .blue,
                         iconName: "facebook_icon")
        ]
        
        let enterUsernamePassword = EnterUsernameEmail(
            navigationTitle: "Create account",
            signUpOptions: signUpOptions,
            otherOptionsTitle: "or",
            usernamePlaceholder: "User name",
            emailPlaceholder: "example@mail.com",
            emailAlreadyInUse: "Unable to register, an account already exists with this email address",
            whoppahIsNotAllowed: "\"Whoppah\" is not allowed",
            logInNow: "Log in now",
            fillInPhoneNumberTitle: "Fill in your phone number")
        
        let choosePassword = ChoosePassword(
            title: "Choose your password",
            navigationTitle: "Create account",
            requirements: PasswordRequirements(
                meetsMinimumCharacterCountRequirement: "Minimum 8 characters",
                meetsAtLeastOneLowerCaseRequirement: "At least one lowercase letter",
                meetsAtLeastOneDigitRequirement: "Minimum one digit",
                meetsAtLeaseOneUpperCaseRequirement: "At least one capital letter"),
            repeatPasswordTitle: "Repeat password",
            agreeToWhoppahTerms: [
                "I agree to Whoppah's",
                "Terms of use",
                "and",
                "Privacy Policy",
                "."
            ], agreeToPaymentTerms: [
                "I agree to the",
                "Terms and Conditions",
                "from payment service provider Stripe",
            ])
        
        let businessInfo = BusinessInfo(
            title: "Fill in your business information",
            navigationTitle: "Business information",
            businessNamePlaceholder: "Business name",
            contactPersonTitle: "Who is the contact person?",
            firstNamePlaceholder: "First name",
            lastNamePlaceholder: "Last name")
        
        let businessAddress = BusinessAddress(
            title: "Fill in the address",
            navigationTitle: "Address Information",
            zipCodePlaceholder: "ZIP code",
            streetPlaceholder: "Street",
            additionalInfoPlaceholder: "Additional address info",
            cityPlaceholder: "City",
            countryPlaceholder: "Country",
            countryList: [
                Country(code: "NL", name: "Netherlands"),
                Country(code: "BE", name: "Belgium"),
                Country(code: "GB", name: "Great Britain"),
                Country(code: "DE", name: "Germany"),
                Country(code: "FR", name: "France"),
                Country(code: "IT", name: "Italy")
            ])
        
        return Self(
            common: common,
            chooseSignupType: chooseSignupType,
            enterUsernamePassword: enterUsernamePassword,
            choosePassword: choosePassword,
            businessInfo: businessInfo,
            businessAddress: businessAddress)
    }
}
