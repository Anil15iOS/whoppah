//
//  SearchFilterType.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation

enum SearchFilterType: String, ExpressibleByStringLiteral {
    typealias StringLiteralType = String
    
    case query
    case category
    case brand
    case color
    case style
    case material
    case other
    case price
    case width
    case height
    case depth
    case numberOfItems
    case country
    
    init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)!
    }
}
