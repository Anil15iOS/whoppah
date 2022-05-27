//
//  JSON.swift
//  WhoppahDataStore
//
//  Created by Eddie Long on 27/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation

public typealias JSON = [String: Any?]

extension Dictionary {
    /// Custom `init` extension so Apollo can decode custom scalar type `JSON `
    public init(jsonValue value: JSONValue) throws {
        guard let dictionary = value as? Dictionary else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Dictionary.self)
        }
        self = dictionary
    }
}
