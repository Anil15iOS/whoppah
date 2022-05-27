//
//  WhoppahModelConvertable.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 21/12/2021.
//

import Foundation

protocol WhoppahModelConvertable {
    associatedtype ModelType
    var toWhoppahModel: ModelType { get }
}
