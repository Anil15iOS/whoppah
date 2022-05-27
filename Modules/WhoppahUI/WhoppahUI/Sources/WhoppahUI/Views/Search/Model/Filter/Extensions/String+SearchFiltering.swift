//
//  String+SearchFiltering.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import WhoppahModel

extension String: SearchFilterResettable & SearchFilterValueInspectable & SearchFilterInputConfigurable {
    mutating func reset() { self = "" }
    
    var filterId: String { self }
    var isActiveFilter: Bool { !self.isEmpty }
    var filterLabel: String { self }
    var attributeValue: String { self }
    
    mutating func from(input: SearchProductsInput,
                       key: SearchFilterKey,
                       attributesToMatch: [AbstractAttribute]?)
    {
        guard let value = input.filters?.compactMap({ $0.key == key ? $0.value : nil }).first else { return }
        self = value
    }
}
