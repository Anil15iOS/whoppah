//
//  FilterItem.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/26/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import WhoppahDataStore

enum FilterItem {
    case price(min: Money?, max: Money?)
    case postalCode(code: String)
    case radius(value: Int)
    case filterAttribute(value: FilterAttribute)
    case quality(value: GraphQL.ProductQuality)
    case category(category: FilterAttribute)
    case arReady(value: Bool)
}
