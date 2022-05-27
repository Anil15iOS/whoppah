//
//  LocalizationService.swift
//  Whoppah
//
//  Created by Dennis Ippel on 15/11/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import WhoppahUI
import ComposableArchitecture
import WhoppahLocalization

struct LocalizationService {
    func localise<T: StaticContentLocalizable>(_ model: T.Type) -> T? {
        return T.localized as? T
    }
}
