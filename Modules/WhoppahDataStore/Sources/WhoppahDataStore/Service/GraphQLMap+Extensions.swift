//
//  File.swift
//  
//
//  Created by Dennis Ippel on 01/12/2021.
//

import Apollo

extension GraphQLMap {
    public var asJsonString: String {
        guard let data = try? JSONSerializationFormat.serialize(value: self),
                let text = String(data: data, encoding: .utf8) else { return "{}" }
        return text
    }
}
