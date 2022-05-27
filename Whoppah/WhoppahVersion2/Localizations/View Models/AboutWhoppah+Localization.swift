//
//  AboutWhoppah+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 10/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import WhoppahUI
import WhoppahLocalization

extension AboutWhoppah.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        return .init(title: l.aboutWhoppah(),
                     welcomeTitle: l.aboutWelcomeTitle(),
                     paragraph1: l.aboutWelcomeText1(),
                     paragraph2: l.aboutWelcomeText2(),
                     pressHeadline: l.aboutContactPressHeadline(),
                     contactTitle: l.aboutContactTitle(),
                     contactSuggestion: l.aboutContactSuggestion(),
                     supportEmail: l.contactEmailTo(),
                     contactOfficeHours: l.aboutContactOfficeHours())
    }
}
