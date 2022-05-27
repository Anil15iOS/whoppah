//
//  SearchFilterValueInspectable.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation

protocol SearchFilterValueInspectable {
    var isActiveFilter: Bool { get }
    var filterLabel: String { get }
    var attributeValue: String { get }
}
