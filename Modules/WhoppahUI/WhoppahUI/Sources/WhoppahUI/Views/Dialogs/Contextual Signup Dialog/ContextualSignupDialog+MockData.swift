//  
//  ContextualSignupDialog+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import Foundation

public extension ContextualSignupDialog.Model {
    static var mock: Self {
        return Self(title: "Before you continue..",
                    description: "Description",
                    loginButtonTitle: "Log In",
                    registerButtonTitle: "I'm new here!")
    }
}
