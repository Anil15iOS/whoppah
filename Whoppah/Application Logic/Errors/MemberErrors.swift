//
//  MemberErrors.swift
//  Whoppah
//
//  Created by Eddie Long on 04/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public enum MemberErrors: String, Error, LocalizedError {
    case missingMerchant = "missing_merchant"
    case unableToFetchMember = "unable_fetch_member"

    public var errorDescription: String? {
        #if DEBUG || STAGING || TESTING
            return rawValue
        #else
            return R.string.localizable.common_generic_error_message()
        #endif
    }
}
