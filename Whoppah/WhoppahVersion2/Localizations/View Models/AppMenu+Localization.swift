//
//  AppMenu+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 03/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import WhoppahUI
import WhoppahLocalization

extension AppMenu.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        return .init(title: "Menu",
                     contact: l.menu_option_contact(),
                     myProfile: l.menu_option_profile(),
                     chatsBidding: l.menu_option_chat(),
                     howWhoppahWorks: l.menu_option_how_whoppah_works(),
                     aboutWhoppah: l.menu_option_about_whoppah(),
                     whoppahReviews: l.menu_option_whoppah_reviews(),
                     storeAndSell: l.menu_option_storage())
    }
}

