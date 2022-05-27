//
//  UnknownAttribute.swift
//  Whoppah
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

struct UnknownAttribute: AdAttribute {
    let id = UUID()
    let title = R.string.localizable.createAdSelectUnknownBrandArtist()
    let slug = unknownAttributeSlug
    let description: String? = nil
}

extension UnknownAttribute: BrandAttribute {}
