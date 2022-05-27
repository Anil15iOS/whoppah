//
//  Double.swift
//  WhoppahCore
//
//  Created by Eddie Long on 24/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

extension Double {
    public func isApproxEqual(_ other: Double) -> Bool {
        fabs(self - other) < Double.ulpOfOne
    }

    public var isApproxZero: Bool { self < Double.ulpOfOne }

    public func formatAsSimpleDecimal() -> String? {
        let formatter = NumberFormatter()
        // If there's a remainder then we use different formatting
        if !hasRemainder() {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        }
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        return formatter.string(from: self as NSNumber)
    }

    public func hasRemainder() -> Bool {
        self - Double(Int(self)) > Double.ulpOfOne
    }
}
