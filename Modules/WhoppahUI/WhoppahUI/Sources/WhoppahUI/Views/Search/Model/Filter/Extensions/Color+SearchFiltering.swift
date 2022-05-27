//
//  Color+SearchFiltering.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import WhoppahModel

extension WhoppahModel.Color: SearchFilterValueInspectable,
                              SearchFilterSingleSelectable,
                              SearchFilterIdentifiable
{
    var filterId: String { self.id.uuidString }
    var isActiveFilter: Bool { true }
    var filterLabel: String { title }
    var attributeValue: String { slug }
}
