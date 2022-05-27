//  
//  SignupSplashView+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import Foundation

public extension SignupSplashView.Model {
    static var mock: Self {
        return Self(loginButtonTitle: "Log In",
                    registerButtonTitle: "Hi! I'm new here",
                    continueAsGuestButtonTitle: "Continue as a guest")
    }
}
