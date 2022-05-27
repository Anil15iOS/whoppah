//
//  ContextualSignupDialog+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 11/01/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahUI
import WhoppahLocalization

extension ContextualSignupDialog.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        return .init(title: "",
                     description: nil,
                     loginButtonTitle: l.contextualSignupSignInButton(),
                     registerButtonTitle: l.contextualSignupCreateAccountButton())
    }
}

