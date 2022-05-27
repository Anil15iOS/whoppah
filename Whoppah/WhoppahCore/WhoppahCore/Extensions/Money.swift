//
//  Float.swift
//  Whoppah
//
//  Created by Eddie Long on 01/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public typealias Money = Double

extension Money {
    public func isValidSellerPrice() -> Bool {
        self >= ProductConfig.minimumPrice
    }
}
