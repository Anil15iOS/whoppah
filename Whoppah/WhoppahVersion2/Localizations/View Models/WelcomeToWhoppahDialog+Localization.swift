//
//  WelcomeToWhoppahDialog+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 15/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahUI
import WhoppahLocalization

extension WelcomeToWhoppahDialog.NewUserModel: StaticContentLocalizable {
    public static var localized: Self {
        .init(title: R.string.localizable.welcomeDialogTitle(),
              description: R.string.localizable.welcomeDialogDescription(),
              createAdButtonTitle: R.string.localizable.welcomeDialogCreateAdButton(),
              discoverDesignButtonTitle: R.string.localizable.welcomeDialogSearchButton())
    }
}

extension WelcomeToWhoppahDialog.ExistingSocialUserModel: StaticContentLocalizable {
    public static var localized: Self {
        .init(title: R.string.localizable.welcomeDialogTitleExisting(),
              descriptionWithEmail: { email in R.string.localizable.welcomeDialogDescriptionExisting(email) },
              createAdButtonTitle: R.string.localizable.welcomeDialogCreateAdButton(),
              discoverDesignButtonTitle: R.string.localizable.welcomeDialogSearchButton())
    }
}
