//
//  Int+SearchFiltering.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import WhoppahModel

extension Int: SearchFilterResettable & SearchFilterValueInspectable & SearchFilterInputConfigurable {
    var filterId: String { "\(self.hashValue)" }
    
    mutating func reset() { self = 1 }
    var isActiveFilter: Bool { self != 1 }
    var filterLabel: String { "\(self)" }
    var attributeValue: String { "\(self)" }
    
    mutating func from(input: SearchProductsInput,
                       key: SearchFilterKey,
                       attributesToMatch: [AbstractAttribute]?)
    {
        guard let value = input.filters?.compactMap({ $0.key == key ? $0.value : nil }).first,
              let intValue = Int(value)
        else { return }

        self = intValue
    }
}
