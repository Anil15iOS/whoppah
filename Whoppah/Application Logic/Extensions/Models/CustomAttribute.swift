//
//  CustomAttribute.swift
//  Whoppah
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

struct CustomAttribute: AdAttribute {
    let id = UUID()
    let title: String
    let slug = uniqueCustomAttributeSlug
    let description: String? = nil

    init(title: String) {
        self.title = title
    }
}

extension CustomAttribute: BrandAttribute {}
