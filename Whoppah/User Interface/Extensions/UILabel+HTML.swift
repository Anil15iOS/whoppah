//
//  UILabel+HTML.swift
//  Whoppah
//
//  Created by Eddie Long on 24/06/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

private extension NSMutableAttributedString {
    /// Replaces the base font (typically Times) with the given font, while preserving traits like bold and italic
    func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = false) {
        let baseDescriptor = baseFont.fontDescriptor
        let wholeRange = NSRange(location: 0, length: length)
        beginEditing()
        enumerateAttribute(.font, in: wholeRange, options: []) { object, range, _ in
            guard let font = object as? UIFont else { return }
            // Instantiate a font with our base font's family, but with the current range's traits
            let traits = font.fontDescriptor.symbolicTraits
            guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else { return }
            let newSize = preserveFontSizes ? font.pointSize : baseDescriptor.pointSize
            let newFont = UIFont(descriptor: descriptor, size: newSize)
            self.removeAttribute(.font, range: range)
            self.addAttribute(.font, value: newFont, range: range)
        }
        endEditing()
    }
}

extension UILabel {
    func setHtml(_ html: String, align: NSTextAlignment = .left) {
        var alignment = ""
        switch align {
        case .left:
            alignment = "" // Default
        case .right:
            alignment = "display: block; text-align: right;"
        case .center:
            alignment = "display: block; text-align: center;"
        case .natural:
            // Handle this if we go to RTL
            alignment = ""
        default: break
        }
        let modifiedFont = String(format: "<span style=\"font-family: \(font!.fontName); font-size: \(font!.pointSize); \(alignment)\">%@</span>", html) as String
        let htmlData = NSString(string: modifiedFont).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                              options: options,
                                                              documentAttributes: nil)
        attributedString?.setBaseFont(baseFont: UIFont.systemFont(ofSize: 12), preserveFontSizes: true)
        attributedText = attributedString
    }
}
