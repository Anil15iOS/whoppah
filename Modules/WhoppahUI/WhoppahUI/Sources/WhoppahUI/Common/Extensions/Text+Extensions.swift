//
//  Text+Extensions.swift
//  
//
//  Created by Dennis Ippel on 15/11/2021.
//

import SwiftUI

extension Text {
  init(_ attributedString: NSAttributedString) {
    self.init("") // initial, empty Text

    // scan the attributed string for distinctly attributed regions
    attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length),
                                         options: []) { (attrs, range, _) in
      let string = attributedString.attributedSubstring(from: range).string
      var text = Text(string)

      // then, read applicable attributes and apply them to the Text

      if let font = attrs[.font] as? UIFont {
        // this takes care of the majority of formatting - text size, font family,
        // font weight, if it's italic, etc.
        text = text.font(.init(font))
      }

      if let color = attrs[.foregroundColor] as? UIColor {
        text = text.foregroundColor(Color(color))
      }

      if let kern = attrs[.kern] as? CGFloat {
        text = text.kerning(kern)
      }

      if let tracking = attrs[.tracking] as? CGFloat {
        text = text.tracking(tracking)
      }

      if let strikethroughStyle = attrs[.strikethroughStyle] as? NSNumber,
         strikethroughStyle != 0 {
        if let strikethroughColor = (attrs[.strikethroughColor] as? UIColor) {
          text = text.strikethrough(true, color: Color(strikethroughColor))
        } else {
          text = text.strikethrough(true)
        }
      }

      if let underlineStyle = attrs[.underlineStyle] as? NSNumber,
         underlineStyle != 0 {
        if let underlineColor = (attrs[.underlineColor] as? UIColor) {
          text = text.underline(true, color: Color(underlineColor))
        } else {
          text = text.underline(true)
        }
      }

      if let baselineOffset = attrs[.baselineOffset] as? NSNumber {
        text = text.baselineOffset(CGFloat(baselineOffset.floatValue))
      }

      // append the newly styled subtext to the rest of the text
      self = self + text
    }
  }
}

extension Text {
  init(html htmlString: String, // the HTML-formatted string
       raw: Bool = false, // set to true if you don't want to embed in the doc skeleton
       size: CGFloat? = nil, // optional document-wide text size
       fontFamily: String = "-apple-system") { // optional document-wide font family
    let fullHTML: String
    if raw {
      fullHTML = htmlString
    } else {
      var sizeCss = ""
       if let size = size {
         sizeCss = "font-size: \(size)px;"
       }
       fullHTML = """
        <!doctype html>
         <html>
            <head>
              <style>
                body {
                  font-family: \(fontFamily);
                  \(sizeCss)
                }
              </style>
            </head>
            <body>
              \(htmlString)
            </body>
          </html>
        """
    }
    let attributedString: NSAttributedString
    if let data = fullHTML.data(using: .unicode),
       let attrString = try? NSAttributedString(data: data,
                                                options: [.documentType: NSAttributedString.DocumentType.html],
                                                documentAttributes: nil) {
      attributedString = attrString
    } else {
      attributedString = NSAttributedString()
    }

    self.init(attributedString) // uses the NSAttributedString initializer
  }
}
