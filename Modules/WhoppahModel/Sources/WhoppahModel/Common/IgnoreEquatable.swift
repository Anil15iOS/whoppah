//
//  IgnoreEquatable.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 25/04/2022.
//

import Foundation

@propertyWrapper
public struct IgnoreEquatable<Wrapped>: Equatable {
    public var wrappedValue: Wrapped
    
    public init(wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
    }

    public static func == (lhs: IgnoreEquatable<Wrapped>, rhs: IgnoreEquatable<Wrapped>) -> Bool {
        true
    }
}
