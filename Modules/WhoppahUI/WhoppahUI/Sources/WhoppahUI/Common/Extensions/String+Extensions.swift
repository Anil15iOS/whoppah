//
//  String+Extensions.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 04/01/2022.
//

import Foundation

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    static var empty: Self { "" }
    
    /// Warning: naive implementation
    var strippingMarkdownNaive: Self {
        self.replacingOccurrences(of: "**", with: "")
            .replacingOccurrences(of: "()", with: "")
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
    }
}

// Used by Focuser package

extension String: Identifiable {
    public var id: UUID { UUID() }
}
