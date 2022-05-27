//
//  Style+SearchFiltering.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import WhoppahModel

extension WhoppahModel.Style: SearchFilterValueInspectable,
                              SearchFilterSingleSelectable,
                              SearchFilterIdentifiable
{
    var filterId: String { self.id.uuidString }
    var isActiveFilter: Bool { true }
    var filterLabel: String { self.localize(\.title) }
    var attributeValue: String { slug }
}
