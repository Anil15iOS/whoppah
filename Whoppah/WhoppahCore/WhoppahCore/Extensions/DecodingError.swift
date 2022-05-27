//
//  DecodeError.swift
//  Whoppah
//
//  Created by Eddie Long on 11/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

extension CodingKey {
    public func intAsString() -> String? {
        intValue != nil ? String(intValue!) : nil
    }

    public func asString() -> String {
        var text = "'" + stringValue + "'"
        if let intText = intAsString() {
            text += ("@index " + intText)
        }
        return text
    }
}

extension DecodingError {
    public func asString() -> String {
        switch self {
        case let .dataCorrupted(context):
            return "Decode error, data corrupted.\n" + context.codingPath.map { $0.stringValue }.joined(separator: " - ") + "\n" + context.debugDescription
        case let .keyNotFound(codingKey, context):
            return "Decode error, key not found. \nKey '" + codingKey.asString() + "\n" + context.debugDescription
        case let .typeMismatch(_, context):
            return "Decode error, type mismatch. \n" + context.debugDescription
        case let .valueNotFound(_, context):
            return "Decode error, value not found. \n" + context.debugDescription
        default:
            return "Decode error - unknown error"
        }
    }
}
