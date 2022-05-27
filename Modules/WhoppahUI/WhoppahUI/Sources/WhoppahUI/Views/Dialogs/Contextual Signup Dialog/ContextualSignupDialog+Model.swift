//  
//  ContextualSignupDialog+Model.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import Foundation
import SwiftUI

public extension ContextualSignupDialog {
    struct Model: Equatable {
        public var title: String
        public var description: String?
        public var loginButtonTitle: String
        public var registerButtonTitle: String

        public init(title: String,
                    description: String? = nil,
                    loginButtonTitle: String,
                    registerButtonTitle: String)
        {
            self.title = title
            self.description = description
            self.loginButtonTitle = loginButtonTitle
            self.registerButtonTitle = registerButtonTitle
        }
        
        static var initial = Self(title: "",
                                  description: nil,
                                  loginButtonTitle: "",
                                  registerButtonTitle: "")
    }
}
