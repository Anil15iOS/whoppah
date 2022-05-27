//
//  String.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/9/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahDataStore

extension String {
    public func capitalizingFirstLetter(_ lowercaseRemaining: Bool = true) -> String {
        prefix(1).uppercased() + (lowercaseRemaining ? lowercased().dropFirst() : dropFirst())
    }

    public func lowerCaseFirstLetter() -> String {
        prefix(1).lowercased() + dropFirst()
    }

    public func masked(leavingCharacters suffixCount: Int, maskCharacter: String = "x") -> String {
        String(repeating: maskCharacter, count: Swift.max(0, count - suffixCount)) + suffix(suffixCount)
    }

    public func stripPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    public func trim() -> String {
        trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let me = self // SwiftFormat incorrectly strips out the 'self,' causing a compilation error :wtf:
        let boundingBox = me.boundingRect(with: constraintRect,
                                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                                          attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let me = self // SwiftFormat incorrectly strips out the 'self,' causing a compilation error :wtf:
        let boundingBox = me.boundingRect(with: constraintRect,
                                          options: .usesLineFragmentOrigin,
                                          attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }

    public func containsHtml() -> Bool {
        range(of: "<[^>]*>", options: .regularExpression, range: nil, locale: nil) != nil
    }

    public func isValidEmail() -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension String {
    public var isValidURL: Bool {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return false }
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == utf16.count
        } else {
            return false
        }
    }
}

extension Locale {
    private static func checkLocale(_ locale: GraphQL.Locale) -> Bool {
        if let code = Locale.current.languageCode?.uppercased() {
            if locale.rawValue == code {
                return true
            }
            if code.prefix(2) == locale.rawValue.prefix(2) {
                return true
            }
        }
        return false
    }

    public static func whoppahLocale(existing: GraphQL.Locale = .nlNl) -> GraphQL.Locale {
        for locale in GraphQL.Locale.allCases where checkLocale(locale) {
            return locale
        }
        return existing
    }    
}

public extension GraphQL.Locale {
    func toLocale() -> Locale {
        let l = Locale.whoppahLocale()
        return Locale(identifier: l.rawValue)
    }
}

extension String {
    public func getPrice() -> Money? {
        // First check the price without any locale
        let rawPrice = Money(self)
        if rawPrice != nil { return rawPrice }

        // Next check locale-specific e.g. 12,00
        let formatter = NumberFormatter()
        formatter.locale = Locale.whoppahLocale().toLocale()
        // I think I've stumbled onto and iOS bug here
        // Use the .currency number style and it _always_ returns nil
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        var text = trim()
        for currency in GraphQL.Currency.allCases {
            let symbol = currency.text
            if text.hasPrefix(symbol) {
                text = String(text.dropFirst(symbol.count))
                break
            }
        }

        let result = formatter.number(from: text)
        guard let final = result else { return nil }
        return final.doubleValue
    }
}

extension String {
    public var titleKey: String {
        self + "-title"
    }

    public var buttonKey: String {
        self + "-button"
    }

    public var descriptionKey: String {
        self + "-description"
    }
}

extension NSAttributedString {
    public func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(boundingBox.height)
    }

    public func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
}
