//  
//  SignupSplashView+Model.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import Foundation
import SwiftUI

public extension SignupSplashView {
    struct Model: Equatable {
        var loginButtonTitle: String
        var registerButtonTitle: String
        var continueAsGuestButtonTitle: String
        
        static var initial = Self(loginButtonTitle: "",
                                  registerButtonTitle: "",
                                  continueAsGuestButtonTitle: "")
        
        public init(loginButtonTitle: String,
                    registerButtonTitle: String,
                    continueAsGuestButtonTitle: String)
        {
            self.loginButtonTitle = loginButtonTitle
            self.registerButtonTitle = registerButtonTitle
            self.continueAsGuestButtonTitle = continueAsGuestButtonTitle
        }
    }
}
