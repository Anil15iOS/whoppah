//
//  SignupSplashView+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 06/01/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahUI
import WhoppahLocalization

extension SignupSplashView.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        return .init(loginButtonTitle: l.auth_intro_btn_sign_in(),
                     registerButtonTitle: l.auth_intro_btn_sign_up(),
                     continueAsGuestButtonTitle: l.auth_intro_btn_guest())
    }
}
