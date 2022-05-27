//
//  Data.swift
//  Whoppah
//
//  Created by Boris Sagan on 9/19/18.
//  Copyright © 2018 IT-nity. All rights reserved.
//

import Foundation

extension Data {
    public mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
