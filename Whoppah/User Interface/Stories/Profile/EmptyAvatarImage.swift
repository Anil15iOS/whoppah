//
//  EmptyAvatarImage.swift
//  Whoppah
//
//  Created by Eddie Long on 11/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

class EmptyAvatarImage {
    static func create(letter: Character, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let color = R.color.blue()
        color!.setFill()
        UIRectFill(rect)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        var fontSize: CGFloat = 36.0
        var font = UIFont(name: "GalanoGrotesque-SemiBold", size: fontSize)

        var attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        let text = "\(letter)"
        // Get the width and height that the text will occupy.
        // Resize the text until it fits
        let padding: CGFloat = 4.0
        var stringSize = text.size(withAttributes: attributes as [NSAttributedString.Key: Any])
        while stringSize.width + (padding * 2) > size.width || stringSize.height + (padding * 2) > size.height, fontSize >= CGFloat.ulpOfOne {
            fontSize -= 1.0
            if fontSize <= CGFloat.ulpOfOne { break }
            font = UIFont(name: "GalanoGrotesque-SemiBold", size: fontSize)
            attributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            stringSize = text.size(withAttributes: attributes as [NSAttributedString.Key: Any])
        }

        if fontSize <= CGFloat.ulpOfOne {
            return UIImage()
        }

        text.draw(in:
            CGRect(
                x: (size.width - stringSize.width) / 2,
                y: (size.height - stringSize.height) / 2,
                width: stringSize.width,
                height: stringSize.height
            ),
                  withAttributes: attributes as [NSAttributedString.Key: Any])

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
