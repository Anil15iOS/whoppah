//
//  UpdateAppDialog+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 16/11/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import WhoppahUI
import ComposableArchitecture
import WhoppahLocalization

extension UpdateAppDialog.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        return .init(title: l.upgradeAppDialogHeader(),
                     description: l.upgradeAppDialogTitle(),
                     ctaTitle: l.upgradeAppDialogButton())
    }
}
