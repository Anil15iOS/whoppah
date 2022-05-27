//
//  AdAttribute+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 21/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

extension AdAttribute {
    var isArt: Bool {
        slug == "art" || slug == "kunst"
    }

    var localizedTitle: String {
        switch self {
        case is BrandAttribute, is Artist, is Designer:
            return title
        case is Material:
            return localizedString(materialTitleKey(slug)) ?? ""
        case is Style:
            return localizedString(styleTitleKey(slug)) ?? ""
        case is WhoppahCore.Category:
            return localizedString(categoryTitleKey(slug)) ?? ""
        case is Color:
            return localizedString(colorTitleKey(slug)) ?? ""
        default:
            return title
        }
    }
}
