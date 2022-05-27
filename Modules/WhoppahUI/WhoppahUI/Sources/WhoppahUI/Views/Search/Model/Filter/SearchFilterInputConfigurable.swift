//
//  SearchFilterInputConfigurable.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import WhoppahModel

protocol SearchFilterInputConfigurable {
    mutating func from(input: SearchProductsInput,
                       key: SearchFilterKey,
                       attributesToMatch: [AbstractAttribute]?)
}
