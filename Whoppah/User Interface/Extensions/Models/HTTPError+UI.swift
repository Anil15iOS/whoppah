//
//  HTTPError+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahCoreNext
import Resolver

// Temp solution will replace during the big refactor

class HTTPCrashReporter {
    @Injected fileprivate var crashReporter: CrashReporter
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        var text = R.string.localizable.common_generic_error_message()
        switch self {
        case let .invalidContentType(contentType, data):
            guard showVerboseUserErrors else { break }

            // Send to the end user
            if let dataText = String(data: data, encoding: .utf8) {
                text = dataText
            } else {
                text = "Invalid server content-type response \(contentType)"
            }
        case let .statusCode(url, statusCode, data):
            var errorText = ""
            if let errorData = data {
                if errorData.count <= 2048 {
                    if let text = String(data: errorData, encoding: .utf8) {
                        errorText = "\(url.absoluteString) - \(text)"
                    }
                } else {
                    if let text = String(data: errorData.subdata(in: 0 ..< 2048), encoding: .utf8) {
                        errorText = "\(url.absoluteString) - \(text)"
                    }
                }
            } else {
                errorText = "None"
            }
            if 500 ... 599 ~= statusCode {
                errorText = "[Internal Server Error] Status code \(statusCode). Message: \(errorText)"
            } else {
                if errorText.isEmpty {
                    errorText = "[Server Error] No data - status code \(statusCode)"
                } else {
                    errorText = "[Server Error] Status code \(statusCode) - text \(errorText)"
                }
            }

            HTTPCrashReporter().crashReporter.log(event: errorText, withInfo: nil)
            guard showVerboseUserErrors else { break }
            text = errorText
        case .emptydata:
            guard showVerboseUserErrors else { break }
            text = "[Server Error] No data"
        case let .jsonDecodeError(error):
            HTTPCrashReporter().crashReporter.log(error: error)
            guard showVerboseUserErrors else { break }
            text = error.localizedDescription
        case let .connectionError(error):
            HTTPCrashReporter().crashReporter.log(error: error)
            guard showVerboseUserErrors else { break }
            text = error.localizedDescription
        default: break
        }

        return text
    }
}
