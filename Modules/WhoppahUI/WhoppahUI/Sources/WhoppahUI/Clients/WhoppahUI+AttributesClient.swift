//
//  WhoppahUI+AttributesClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 24/03/2022.
//

import ComposableArchitecture
import WhoppahModel

public extension WhoppahUI {
    struct AttributesClient {
        var fetchAttributes: (AttributeType) -> Effect<[AbstractAttribute], Error>
        
        public init(fetchAttributes: @escaping (AttributeType) -> Effect<[AbstractAttribute], Error>) {
            self.fetchAttributes = fetchAttributes
        }
    }
}
