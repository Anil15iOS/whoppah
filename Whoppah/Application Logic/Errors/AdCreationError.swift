//
//  AdCreationError.swift
//  Whoppah
//
//  Created by Eddie Long on 26/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public enum AdCreationError: String, Error, LocalizedError {
    case incompleteData = "incomplete_server_data"

    public var errorDescription: String? {
        #if DEBUG || STAGING || TESTING
            return rawValue
        #else
            return R.string.localizable.common_generic_error_message()
        #endif
    }
}
