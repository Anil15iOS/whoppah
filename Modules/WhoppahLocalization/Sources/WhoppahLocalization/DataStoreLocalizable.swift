//
//  DataStoreLocalizable.swift
//  WhoppahLocalization
//
//  Created by Dennis Ippel on 21/03/2022.
//

import Foundation

protocol DataStoreLocalizable {
    associatedtype ModelType
    func localize(_ path: KeyPath<ModelType, String>, params: String...) -> String
}
