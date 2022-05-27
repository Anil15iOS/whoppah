//
//  Sort.swift
//  Whoppah
//
//  Created by Eddie Long on 20/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

extension GraphQL.SearchSort {
    public func toString() -> String {
        switch self {
        case .distance:
            return "distance"
        case .created:
            return "created_at"
        case .price:
            return "price"
        default: return ""
        }
    }
}
