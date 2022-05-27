//
//  Result.swift
//  WhoppahTests
//
//  Created by Eddie Long on 18/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

extension Result {
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
