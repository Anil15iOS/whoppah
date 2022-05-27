//
//  DataStoreLocalizer.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 21/03/2022.
//

import Foundation

open class DataStoreLocalizer<T> {
    public init() {}
    
    open func localize(_ path: KeyPath<T, String>, model: T, params: [String]) -> String {
        return ""
    }
    
    public func missingLocalization(forKey key: KeyPath<T, String>) -> String {
        #if DEBUG
        print("🌍 Missing localization \(key)")
        #endif
        return ""
    }
}
