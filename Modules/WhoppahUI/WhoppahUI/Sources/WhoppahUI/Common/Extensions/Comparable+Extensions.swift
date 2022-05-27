//
//  Comparable+Extensions.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 19/04/2022.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
