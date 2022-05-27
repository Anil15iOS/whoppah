//
//  Country+SearchFiltering.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import WhoppahModel

extension WhoppahModel.Country: SearchFilterValueInspectable,
                                SearchFilterSingleSelectable,
                                SearchFilterIdentifiable
{
    var filterId: String { self.rawValue }
    var isActiveFilter: Bool { true }
    var filterLabel: String { self.localized }
    var attributeValue: String { self.rawValue.uppercased() }
}
