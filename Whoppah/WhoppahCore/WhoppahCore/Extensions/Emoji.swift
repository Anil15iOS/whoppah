//
//  Emoji.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji

extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600 ... 0x1F64F, // Emoticons
             0x1F300 ... 0x1F5FF, // Misc Symbols and Pictographs
             0x1F680 ... 0x1F6FF, // Transport and Map
             0x1F1E6 ... 0x1F1FF, // Regional country flags
             0x2600 ... 0x26FF, // Misc symbols
             0x2700 ... 0x27BF, // Dingbats
             0xFE00 ... 0xFE0F, // Variation Selectors
             0x1F900 ... 0x1F9FF, // Supplemental Symbols and Pictographs
             65024 ... 65039, // Variation selector
             8400 ... 8447: // Combining Diacritical Marks for Symbols
            return true

        default: return false
        }
    }

    var isZeroWidthJoiner: Bool {
        value == 8205
    }
}

extension String {
    var glyphCount: Int {
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }

    var containsEmoji: Bool {
        unicodeScalars.contains { $0.isEmoji }
    }
}

extension String {
    public static func emojiFlag(for countryCode: String) -> String? {
        let lowercasedCode = countryCode.lowercased()
        guard lowercasedCode.count == 2 else { return nil }
        guard lowercasedCode.unicodeScalars.allSatisfy({ isLowercaseASCIIScalar($0) }) else { return nil }

        let indicatorSymbols = lowercasedCode.unicodeScalars.map { regionalIndicatorSymbol(for: $0) }
        return String(indicatorSymbols.map { Character($0) })
    }

    private static func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
        scalar.value >= 0x61 && scalar.value <= 0x7A
    }

    private static func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
        precondition(isLowercaseASCIIScalar(scalar))

        // 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
        // 0x61 marks the start of the lowercase ASCII alphabet: 'a'
        return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
    }
}
