//
//  DateTime.swift
//  WhoppahDataStore
//
//  Created by Eddie Long on 12/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation

private let iso8601DateTimeFormatter = ISO8601DateFormatter()

// 1970-01-01T00:00:01Z
public class DateTime: JSONDecodable {
    public let date: Date
    public init() {
        date = Date()
    }

    public init(date: Date) {
        self.date = date
    }

    public required init(jsonValue value: JSONValue) throws {
        guard let isoString = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }
        let trimmedIsoString = isoString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        guard let date = iso8601DateTimeFormatter.date(from: trimmedIsoString) else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }
        self.date = date
    }
}

extension DateTime: JSONEncodable {
    public var jsonValue: JSONValue {
        // Add back in the milliseconds
        iso8601DateTimeFormatter.string(from: date) + ".000Z"
    }
}

private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "YYYY-MM-dd"
    return formatter
}

//  31-01-2019
extension Date: JSONDecodable {
    public init(jsonValue value: JSONValue) throws {
        guard let isoString = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }
        guard let date = dateFormatter.date(from: isoString) else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }
        self = date
    }
}

extension Date: JSONEncodable {
    public var jsonValue: JSONValue {
        dateFormatter.string(from: self)
    }
}
