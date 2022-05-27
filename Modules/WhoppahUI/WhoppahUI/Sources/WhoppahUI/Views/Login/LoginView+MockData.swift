//  
//  LoginView+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import Foundation

public extension LoginView.Model {
    static var mock: Self {
        let signInOptions = [
            SignInOption(id: .magicLink,
                         title: "Get link via email",
                         foregroundColor: WhoppahTheme.Color.base1,
                         iconName: "magic_wand_icon"),
            SignInOption(id: .apple,
                         title: "Log in with Apple",
                         foregroundColor: WhoppahTheme.Color.base1,
                         iconName: "apple_icon"),
            SignInOption(id: .google,
                         title: "Log in with Google",
                         foregroundColor: WhoppahTheme.Color.base5,
                         iconName: "google_icon"),
            SignInOption(id: .facebook,
                         title: "Log in with Facebook",
                         foregroundColor: .blue,
                         iconName: "facebook_icon")
        ]
        
        let common = Common(doneButtonTitle: "Done",
                            invalidEmailOrPassword: "Invalid email or password. Please try again.",
                            invalidEmail: "Invalid email address",
                            invalidPassword: "Invalid password")
        
        let login = Login(title: "Welcome back!",
                          navigationTitle: "Log in",
                          emailPlaceHolderText: "Email",
                          passwordPlaceHolderText: "Your password",
                          forgotPasswordTitle: "Forgot password?",
                          otherOptionsTitle: "or",
                          signInOptions: signInOptions,
                          signInButtonTitle: "Log in")
        
        let forgotPassword = ForgotPassword(enterYourEmailTitle: "Enter your email",
                                            navigationTitle: "Forgotten password",
                                            forgotPasswordDescription: "Forgot your password? No problem! We will send you a link with which you can easily set a new password.",
                                            enterYourEmailPlaceholder: "Enter your e-mail address",
                                            sendButtonTitle: "Send")
        
        let forgotPasswordConfirmation = ForgotPasswordConfirmation(resetPasswordSentTitle: "Password reset requested",
                                                                    navigationTitle: "Forgotten password",
                                                                    resetPasswordSentDescription: "We have sent you an email with a link with which you can reset your password.",
                                                                    backToLoginButtonTitle: "Log in again")
        
        let magicLink = MagicLink(navigationTitle: "One time code log in",
                                  magicLinkTitle: "One time code log in",
                                  magicLinkDescription: "Log in via a Magic link. Fill in your email to receive an email with a one-time log in code or direct log in button.",
                                  magicLinkEnterCodeDescription: "Enter the code sent to you by email. If you haven’t received a code, please check your spam box or",
                                  enterYourEmailPlaceholder: "Your email",
                                  sendLinkButtonTitle: "Send me the email",
                                  expiredCode: "Invalid or expired magic code",
                                  incompleteCode: "Incomplete magic code",
                                  resendEmail: "resend the email",
                                  signingYouIn: "Please wait while we log you in",
                                  signInButtonTitle: "Login")
        
        return .init(common: common,
                     login: login,
                     forgotPassword: forgotPassword,
                     forgotPasswordConfirmation: forgotPasswordConfirmation,
                     magicLink: magicLink)
    }
}
