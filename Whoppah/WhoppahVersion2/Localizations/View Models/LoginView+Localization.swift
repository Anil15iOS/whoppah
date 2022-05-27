//
//  LoginView+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 03/01/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import WhoppahUI
import WhoppahLocalization

extension LoginView.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        let common = Common(doneButtonTitle: l.create_ad_camera_btn_save(),
                            invalidEmailOrPassword: l.common_email_pass_invalid(),
                            invalidEmail: l.commonInvalidEmail(),
                            invalidPassword: l.error_invalid_pass())
        
        let signInOptions = [
            SignInOption(id: .magicLink,
                         title: l.authSignInBtnMagic(),
                         foregroundColor: WhoppahTheme.Color.base1,
                         iconName: "magic_wand_icon"),
            SignInOption(id: .apple,
                         title: l.authSignInApple(),
                         foregroundColor: WhoppahTheme.Color.base1,
                         iconName: "apple_icon"),
            SignInOption(id: .google,
                         title: l.authSignInGoogle(),
                         foregroundColor: WhoppahTheme.Color.base5,
                         iconName: "google_icon"),
            SignInOption(id: .facebook,
                         title: l.authSignInFacebook(),
                         foregroundColor: .blue,
                         iconName: "facebook_icon")
        ]
        
        let login = Login(title: l.authSignInScreenTitle(),
                          navigationTitle: l.authSignInScreenNavigationTitle(),
                          emailPlaceHolderText: l.auth_sign_in_email(),
                          passwordPlaceHolderText: l.authSignInPasswordPlaceholder(),
                          forgotPasswordTitle: l.auth_sign_in_forgot_pass(),
                          otherOptionsTitle: l.commonOr(),
                          signInOptions: signInOptions,
                          signInButtonTitle: l.auth_sign_in_btn_sign_in())
        
        let forgotPassword = ForgotPassword(enterYourEmailTitle: l.authForgotPasswordTitle(),
                                            navigationTitle: l.authForgotPassScreenTitle(),
                                            forgotPasswordDescription: l.authForgotPassDescription(),
                                            enterYourEmailPlaceholder: l.auth_forgot_pass_email(),
                                            sendButtonTitle: l.auth_forgot_pass_btn_proceed())
        
        let forgotPasswordConfirmation = ForgotPasswordConfirmation(resetPasswordSentTitle: l.authForgotPassSuccessTitle(),
                                                                    navigationTitle: l.authForgotPassScreenTitle(),
                                                                    resetPasswordSentDescription: l.authForgotPassSuccessDescription(),
                                                                    backToLoginButtonTitle: l.authForgotPassSuccessSignInButton())
        
        let magicLink = MagicLink(navigationTitle: l.authSignInMagicScreenTitle(),
                                  magicLinkTitle: l.authSignInMagicScreenTitle(),
                                  magicLinkDescription: l.authSignInMagicScreenSubtitle(),
                                  magicLinkEnterCodeDescription: l.authSignInMagicCodeSubtitle(),
                                  enterYourEmailPlaceholder: l.authSignInMagicEmail(),
                                  sendLinkButtonTitle: l.authSignInMagicBtnCode(),
                                  expiredCode: l.authSignInMagicTheProvidedTokenIsIncorrect(),
                                  incompleteCode: l.authSignInMagicCodeIncomplete(),
                                  resendEmail: l.authSignInMagicCodeSubtitleEmail(),
                                  signingYouIn: l.authSignInMagicScreenTitle(),
                                  signInButtonTitle: l.auth_sign_in_btn_sign_in())
        
        return .init(common: common,
                     login: login,
                     forgotPassword: forgotPassword,
                     forgotPasswordConfirmation: forgotPasswordConfirmation,
                     magicLink: magicLink)
    }
}
