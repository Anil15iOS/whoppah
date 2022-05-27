//
//  GenericUserError.swift
//  WhoppahCore
//
//  Created by Eddie Long on 13/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public struct GenericUserError: Error {
    public let underlyingError: Error?

    public init(underlyingError: Error?) {
        self.underlyingError = underlyingError
    }
}
