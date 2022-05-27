//  
//  RegistrationView+Model.swift
//  WhoppahUIIntegrationTest
//
//  Created by Dennis Ippel on 17/01/2022.
//

import Foundation
import SwiftUI

public extension RegistrationView {
    struct Model: Equatable {
        let common: Common
        let chooseSignupType: ChooseSignupType
        let enterUsernamePassword: EnterUsernameEmail
        let choosePassword: ChoosePassword
        let businessInfo: BusinessInfo
        let businessAddress: BusinessAddress
        
        public enum SignUpType {
            case individual
            case business
        }
        
        public init(common: Common,
                    chooseSignupType: ChooseSignupType,
                    enterUsernamePassword: EnterUsernameEmail,
                    choosePassword: ChoosePassword,
                    businessInfo: BusinessInfo,
                    businessAddress: BusinessAddress) {
            self.common = common
            self.chooseSignupType = chooseSignupType
            self.enterUsernamePassword = enterUsernamePassword
            self.choosePassword = choosePassword
            self.businessInfo = businessInfo
            self.businessAddress = businessAddress
        }
        
        public  static var initial = Self(
            common: .initial,
            chooseSignupType: .initial,
            enterUsernamePassword: .initial,
            choosePassword: .initial,
            businessInfo: .initial,
            businessAddress: .initial)
        
        public struct Common: Equatable {
            let nextButtonTitle: String
            let invalidEmail: String
            let missingEmail: String
            let missingUsername: String
            let phoneNumberRequired: String
            let invalidPhoneNumber: String
            let doneButtonTitle: String
            let invalidPasswordRepeat: String
            let missingBusinessName: String
            let missingFirstName: String
            let missingLastName: String
            let missingZipCode: String
            let missingStreet: String
            let missingCity: String
            let missingCountry: String
            
            static var initial = Self(
                nextButtonTitle: "",
                invalidEmail: "",
                missingEmail: "",
                missingUsername: "",
                phoneNumberRequired: "",
                invalidPhoneNumber: "",
                doneButtonTitle: "",
                invalidPasswordRepeat: "",
                missingBusinessName: "",
                missingFirstName: "",
                missingLastName: "",
                missingZipCode: "",
                missingStreet: "",
                missingCity: "",
                missingCountry: "")
            
            public init(nextButtonTitle: String,
                        invalidEmail: String,
                        missingEmail: String,
                        missingUsername: String,
                        phoneNumberRequired: String,
                        invalidPhoneNumber: String,
                        doneButtonTitle: String,
                        invalidPasswordRepeat: String,
                        missingBusinessName: String,
                        missingFirstName: String,
                        missingLastName: String,
                        missingZipCode: String,
                        missingStreet: String,
                        missingCity: String,
                        missingCountry: String)
            {
                self.nextButtonTitle = nextButtonTitle
                self.invalidEmail = invalidEmail
                self.missingEmail = missingEmail
                self.missingUsername = missingUsername
                self.phoneNumberRequired = phoneNumberRequired
                self.invalidPhoneNumber = invalidPhoneNumber
                self.doneButtonTitle = doneButtonTitle
                self.invalidPasswordRepeat = invalidPasswordRepeat
                self.missingBusinessName = missingBusinessName
                self.missingFirstName = missingFirstName
                self.missingLastName = missingLastName
                self.missingZipCode = missingZipCode
                self.missingStreet = missingStreet
                self.missingCity = missingCity
                self.missingCountry = missingCountry
            }
        }
        
        public enum SignUpOptionId {
            case facebook
            case google
            case apple
        }
        
        public struct SignUpOption: Equatable, Hashable {
            let id: SignUpOptionId
            let title: String
            let foregroundColor: Color
            let iconName: String
            
            public init(id: SignUpOptionId,
                        title: String,
                        foregroundColor: Color,
                        iconName: String)
            {
                self.id = id
                self.title = title
                self.foregroundColor = foregroundColor
                self.iconName = iconName
            }
            
            public static func == (lhs: SignUpOption, rhs: SignUpOption) -> Bool {
                return lhs.id == rhs.id
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }
        }
        
        public struct ChooseSignupType: Equatable {
            let title: String
            let navigationTitle: String
            let person: String
            let business: String
            
            static var initial = Self(
                title: "",
                navigationTitle: "",
                person: "",
                business: "")

            public init(title: String,
                        navigationTitle: String,
                        person: String,
                        business: String)
            {
                self.title = title
                self.navigationTitle = navigationTitle
                self.person = person
                self.business = business
            }
        }
        
        public struct EnterUsernameEmail: Equatable {
            let navigationTitle: String
            let signUpOptions: [SignUpOption]
            let otherOptionsTitle: String
            let usernamePlaceholder: String
            let emailPlaceholder: String
            let emailAlreadyInUse: String
            let whoppahIsNotAllowed: String
            let logInNow: String
            let fillInPhoneNumberTitle: String
            
            static var initial = Self(
                navigationTitle: "",
                signUpOptions: [],
                otherOptionsTitle: "",
                usernamePlaceholder: "",
                emailPlaceholder: "",
                emailAlreadyInUse: "",
                whoppahIsNotAllowed: "",
                logInNow: "",
                fillInPhoneNumberTitle: "")
            
            public init(navigationTitle: String,
                        signUpOptions: [SignUpOption],
                        otherOptionsTitle: String,
                        usernamePlaceholder: String,
                        emailPlaceholder: String,
                        emailAlreadyInUse: String,
                        whoppahIsNotAllowed: String,
                        logInNow: String,
                        fillInPhoneNumberTitle: String)
            {
                self.navigationTitle = navigationTitle
                self.signUpOptions = signUpOptions
                self.otherOptionsTitle = otherOptionsTitle
                self.usernamePlaceholder = usernamePlaceholder
                self.emailPlaceholder = emailPlaceholder
                self.emailAlreadyInUse = emailAlreadyInUse
                self.whoppahIsNotAllowed = whoppahIsNotAllowed
                self.logInNow = logInNow
                self.fillInPhoneNumberTitle = fillInPhoneNumberTitle
            }
        }
        
        public struct ChoosePassword: Equatable {
            let title: String
            let navigationTitle: String
            let requirements: PasswordRequirements
            let repeatPasswordTitle: String
            let agreeToWhoppahTerms: [String]
            let agreeToPaymentTerms: [String]
            
            static var initial = Self(
                title: "",
                navigationTitle: "",
                requirements: .initial,
                repeatPasswordTitle: "",
                agreeToWhoppahTerms: [],
                agreeToPaymentTerms: [])
            
            public init(title: String,
                        navigationTitle: String,
                        requirements: PasswordRequirements,
                        repeatPasswordTitle: String,
                        agreeToWhoppahTerms: [String],
                        agreeToPaymentTerms: [String])
            {
                self.title = title
                self.navigationTitle = navigationTitle
                self.requirements = requirements
                self.repeatPasswordTitle = repeatPasswordTitle
                self.agreeToWhoppahTerms = agreeToWhoppahTerms
                self.agreeToPaymentTerms = agreeToPaymentTerms
            }
        }
        
        public struct BusinessInfo: Equatable {
            let title: String
            let navigationTitle: String
            let businessNamePlaceholder: String
            let contactPersonTitle: String
            let firstNamePlaceholder: String
            let lastNamePlaceholder: String
            
            static var initial = Self(
                title: "",
                navigationTitle: "",
                businessNamePlaceholder: "",
                contactPersonTitle: "",
                firstNamePlaceholder: "",
                lastNamePlaceholder: "")
            
            public init(title: String,
                        navigationTitle: String,
                        businessNamePlaceholder: String,
                        contactPersonTitle: String,
                        firstNamePlaceholder: String,
                        lastNamePlaceholder: String)
            {
                self.title = title
                self.navigationTitle = navigationTitle
                self.businessNamePlaceholder = businessNamePlaceholder
                self.contactPersonTitle = contactPersonTitle
                self.firstNamePlaceholder = firstNamePlaceholder
                self.lastNamePlaceholder = lastNamePlaceholder
            }
        }
        
        public struct Country: Equatable, Hashable {
            let code: String
            let name: String
            
            public init(code: String, name: String) {
                self.code = code
                self.name = name
            }
            
            public static func == (lhs: Country, rhs: Country) -> Bool {
                return lhs.code == rhs.code
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(code)
            }
        }
        
        public struct BusinessAddress: Equatable {
            let title: String
            let navigationTitle: String
            let zipCodePlaceholder: String
            let streetPlaceholder: String
            let additionalInfoPlaceholder: String
            let cityPlaceholder: String
            let countryPlaceholder: String
            let countryList: [Country]
            
            static var initial = Self(
                title: "",
                navigationTitle: "",
                zipCodePlaceholder: "",
                streetPlaceholder: "",
                additionalInfoPlaceholder: "",
                cityPlaceholder: "",
                countryPlaceholder: "",
                countryList: [])
            
            public init(title: String,
                        navigationTitle: String,
                        zipCodePlaceholder: String,
                        streetPlaceholder: String,
                        additionalInfoPlaceholder: String,
                        cityPlaceholder: String,
                        countryPlaceholder: String,
                        countryList: [Country])
            {
                self.title = title
                self.navigationTitle = navigationTitle
                self.zipCodePlaceholder = zipCodePlaceholder
                self.streetPlaceholder = streetPlaceholder
                self.additionalInfoPlaceholder = additionalInfoPlaceholder
                self.cityPlaceholder = cityPlaceholder
                self.countryPlaceholder = countryPlaceholder
                self.countryList = countryList
            }
        }
    }
}
