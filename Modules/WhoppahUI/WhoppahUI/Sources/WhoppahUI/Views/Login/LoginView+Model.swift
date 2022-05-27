//  
//  LoginView+Model.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import Foundation
import SwiftUI

public extension LoginView {
    struct Model: Equatable {
        let common: Common
        let login: Login
        let forgotPassword: ForgotPassword
        let forgotPasswordConfirmation: ForgotPasswordConfirmation
        let magicLink: MagicLink
        
        public init(common: LoginView.Model.Common,
                    login: LoginView.Model.Login,
                    forgotPassword: LoginView.Model.ForgotPassword,
                    forgotPasswordConfirmation: LoginView.Model.ForgotPasswordConfirmation,
                    magicLink: LoginView.Model.MagicLink)
        {
            self.common = common
            self.login = login
            self.forgotPassword = forgotPassword
            self.forgotPasswordConfirmation = forgotPasswordConfirmation
            self.magicLink = magicLink
        }
        
        public struct Common: Equatable {
            let doneButtonTitle: String
            let invalidEmailOrPassword: String
            let invalidEmail: String
            let invalidPassword: String
            
            static var initial = Self(
                doneButtonTitle: "",
                invalidEmailOrPassword: "",
                invalidEmail: "",
                invalidPassword: ""
            )
            
            public init(doneButtonTitle: String,
                        invalidEmailOrPassword: String,
                        invalidEmail: String,
                        invalidPassword: String)
            {
                self.doneButtonTitle = doneButtonTitle
                self.invalidEmailOrPassword = invalidEmailOrPassword
                self.invalidEmail = invalidEmail
                self.invalidPassword = invalidPassword
            }
        }
        
        public struct Login: Equatable {
            let title: String
            let navigationTitle: String
            let emailPlaceHolderText: String
            let passwordPlaceHolderText: String
            let forgotPasswordTitle: String
            let otherOptionsTitle: String
            let signInOptions: [SignInOption]
            let signInButtonTitle: String
            
            static var initial = Self(
                title: "",
                navigationTitle: "",
                emailPlaceHolderText: "",
                passwordPlaceHolderText: "",
                forgotPasswordTitle: "",
                otherOptionsTitle: "",
                signInOptions: [],
                signInButtonTitle: ""
            )
            
            public init(title: String,
                        navigationTitle: String,
                        emailPlaceHolderText: String,
                        passwordPlaceHolderText: String,
                        forgotPasswordTitle: String,
                        otherOptionsTitle: String,
                        signInOptions: [LoginView.Model.SignInOption], signInButtonTitle: String)
            {
                self.title = title
                self.navigationTitle = navigationTitle
                self.emailPlaceHolderText = emailPlaceHolderText
                self.passwordPlaceHolderText = passwordPlaceHolderText
                self.forgotPasswordTitle = forgotPasswordTitle
                self.otherOptionsTitle = otherOptionsTitle
                self.signInOptions = signInOptions
                self.signInButtonTitle = signInButtonTitle
            }
        }
        
        public struct ForgotPassword: Equatable {
            let enterYourEmailTitle: String
            let navigationTitle: String
            let forgotPasswordDescription: String
            let enterYourEmailPlaceholder: String
            let sendButtonTitle: String
            
            static var initial = Self(
                enterYourEmailTitle: "",
                navigationTitle: "",
                forgotPasswordDescription: "",
                enterYourEmailPlaceholder: "",
                sendButtonTitle: ""
            )
            
            public init(enterYourEmailTitle: String,
                        navigationTitle: String,
                        forgotPasswordDescription: String,
                        enterYourEmailPlaceholder: String,
                        sendButtonTitle: String)
            {
                self.enterYourEmailTitle = enterYourEmailTitle
                self.navigationTitle = navigationTitle
                self.forgotPasswordDescription = forgotPasswordDescription
                self.enterYourEmailPlaceholder = enterYourEmailPlaceholder
                self.sendButtonTitle = sendButtonTitle
            }
        }
        
        public struct ForgotPasswordConfirmation: Equatable {
            let resetPasswordSentTitle: String
            let navigationTitle: String
            let resetPasswordSentDescription: String
            let backToLoginButtonTitle: String
            
            static var initial = Self(
                resetPasswordSentTitle: "",
                navigationTitle: "",
                resetPasswordSentDescription: "",
                backToLoginButtonTitle: ""
            )
            
            public init(resetPasswordSentTitle: String,
                        navigationTitle: String,
                        resetPasswordSentDescription: String,
                        backToLoginButtonTitle: String)
            {
                self.resetPasswordSentTitle = resetPasswordSentTitle
                self.navigationTitle = navigationTitle
                self.resetPasswordSentDescription = resetPasswordSentDescription
                self.backToLoginButtonTitle = backToLoginButtonTitle
            }
        }
        
        public struct MagicLink: Equatable {
            let navigationTitle: String
            let magicLinkTitle: String
            let magicLinkDescription: String
            let magicLinkEnterCodeDescription: String
            let enterYourEmailPlaceholder: String
            let sendLinkButtonTitle: String
            let expiredCode: String
            let incompleteCode: String
            let resendEmail: String
            let signingYouIn: String
            let signInButtonTitle: String
            
            static var initial = Self(navigationTitle: "",
                                      magicLinkTitle: "",
                                      magicLinkDescription: "",
                                      magicLinkEnterCodeDescription: "",
                                      enterYourEmailPlaceholder: "",
                                      sendLinkButtonTitle: "",
                                      expiredCode: "",
                                      incompleteCode: "",
                                      resendEmail: "",
                                      signingYouIn: "",
                                      signInButtonTitle: "")
            
            public init(navigationTitle: String,
                        magicLinkTitle: String,
                        magicLinkDescription: String,
                        magicLinkEnterCodeDescription: String,
                        enterYourEmailPlaceholder: String,
                        sendLinkButtonTitle: String,
                        expiredCode: String,
                        incompleteCode: String,
                        resendEmail: String,
                        signingYouIn: String,
                        signInButtonTitle: String)
            {
                self.navigationTitle = navigationTitle
                self.magicLinkTitle = magicLinkTitle
                self.magicLinkDescription = magicLinkDescription
                self.magicLinkEnterCodeDescription = magicLinkEnterCodeDescription
                self.enterYourEmailPlaceholder = enterYourEmailPlaceholder
                self.sendLinkButtonTitle = sendLinkButtonTitle
                self.expiredCode = expiredCode
                self.incompleteCode = incompleteCode
                self.resendEmail = resendEmail
                self.signingYouIn = signingYouIn
                self.signInButtonTitle = signInButtonTitle
            }
        }
        
        static var initial = Self(
            common: .initial,
            login: .initial,
            forgotPassword: .initial,
            forgotPasswordConfirmation: .initial,
            magicLink: .initial
        )
        
        public enum SignInOptionId {
            case magicLink
            case facebook
            case google
            case apple
        }
        
        public struct SignInOption: Equatable, Hashable {
            let id: SignInOptionId
            let title: String
            let foregroundColor: Color
            let iconName: String
            
            public init(id: LoginView.Model.SignInOptionId,
                        title: String,
                        foregroundColor: Color,
                        iconName: String)
            {
                self.id = id
                self.title = title
                self.foregroundColor = foregroundColor
                self.iconName = iconName
            }
            
            public static func == (lhs: SignInOption, rhs: SignInOption) -> Bool {
                return lhs.id == rhs.id
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }
        }
    }
}
