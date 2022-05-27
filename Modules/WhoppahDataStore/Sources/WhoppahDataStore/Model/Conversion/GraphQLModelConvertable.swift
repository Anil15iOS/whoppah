//
//  GraphQLModelConvertable.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 22/12/2021.
//

import Foundation

protocol GraphQLModelConvertable {
    associatedtype ModelType
    var toGraphQLModel: ModelType { get }
}
