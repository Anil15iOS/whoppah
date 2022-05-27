//
//  EnumLocalizer.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation

open class EnumLocalizer<T> {
    public init() {}
    
    open func localize(_ value: T) -> String {
        return ""
    }
    
    public func missingLocalization(forValue value: T) -> String {
        #if DEBUG
        print("🌍 Missing localization \(value)")
        #endif
        return ""
    }
}
