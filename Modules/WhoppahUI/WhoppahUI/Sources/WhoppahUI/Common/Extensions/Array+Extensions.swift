//
//  Array+Extensions.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 15/04/2022.
//

import Foundation

extension Array {
    func firstNumberOfElements(_ count: Int) -> Self {
        let upperLimit = Swift.min(count, self.count)
        return Self(self[0..<upperLimit])
    }
}
