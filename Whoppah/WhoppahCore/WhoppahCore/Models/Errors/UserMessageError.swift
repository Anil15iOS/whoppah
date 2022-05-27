//
//  LocalizedError.swift
//  WhoppahCore
//
//  Created by Eddie Long on 20/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public class UserMessageError: LocalizedError {
    private let message: String
    public init(message: String) {
        self.message = message
    }

    public var errorDescription: String? { message }
}
