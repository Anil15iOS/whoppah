//
//  Errors+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 06/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import WhoppahCore

extension DisposedError: LocalizedError {
    public var errorDescription: String? {
        guard showVerboseUserErrors else { return R.string.localizable.common_generic_error_message() }
        return rawValue
    }
}

extension GenericUserError: LocalizedError {
    public var errorDescription: String? {
        guard showVerboseUserErrors else { return R.string.localizable.common_generic_error_message() }

        guard let underlying = underlyingError else {
            return R.string.localizable.common_generic_error_message()
        }

        guard let graphError = underlying as? GraphQLError else {
            return underlying.localizedDescription
        }
        // Very large errors can fill the entire screen
        // and cannot be dismissed
        // GraphQL is very verbose, so we limit to 512 characters
        var error = graphError.description
        if let locations = graphError.locations {
            error += "\nLocations: "
            error += locations.map { "\($0.line) - \($0.column)" }.joined(separator: " -- ")
        }
        if let exts = graphError.extensions, !exts.isEmpty {
            error += "\nExtensions: "
            for ext in exts {
                error += "\(ext.key) - \(ext.value)\n"
            }
        }
        return error
    }
}
