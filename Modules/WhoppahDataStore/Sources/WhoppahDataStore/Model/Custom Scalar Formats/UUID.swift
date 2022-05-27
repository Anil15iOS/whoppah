//
//  UUID.swift
//  WhoppahDataStore
//
//  Created by Eddie Long on 12/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//
import Apollo
import Foundation

extension UUID: JSONDecodable {
    public init(jsonValue value: JSONValue) throws {
        guard let valueStr = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: UUID.self)
        }
        guard let uuid = UUID(uuidString: valueStr.lowercased()) else {
            throw JSONDecodingError.couldNotConvert(value: value, to: UUID.self)
        }
        self = uuid
    }
}

extension UUID: JSONEncodable {
    public var jsonValue: JSONValue {
        uuidString.lowercased()
    }
}
