//
//  Category+Extensions.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 17/03/2022.
//

import Foundation

extension Category: Hashable, Identifiable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.uuidString)
    }
}

extension Category: AbstractAttribute {}

extension Category: ChildrenContainable {}
