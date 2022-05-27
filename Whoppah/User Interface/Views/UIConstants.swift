//
//  UIConstants.swift
//  Whoppah
//
//  Created by Eddie Long on 23/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

struct UIConstants {
    static let listInteritemHSpacing: CGFloat = 16.0
    static let listInteritemVSpacing: CGFloat = 16.0
    static let margin: CGFloat = 16.0
}

// Titles, description, body
extension UIConstants {
    static let titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let titleTopMargin: CGFloat = 40.0
    static let titleBottomMargin: CGFloat = 24.0 // When it's a textfield below the title
    static let titleBottomTextMargin: CGFloat = 8.0 // When there is text below the title
    static let bodyFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let descriptionSize: CGFloat = 11.0
    static let descriptionFont = UIFont.systemFont(ofSize: descriptionSize)
}

// MARK: Textfields

extension UIConstants {
    static let textfieldHeight: CGFloat = 58.0
    static let textfieldTitleFont = UIFont.systemFont(ofSize: 13, weight: .regular)
}

// MARK: Buttons

extension UIConstants {
    static let buttonHeight: CGFloat = 48.0
    static let buttonFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let buttonBottomMarginFloating: CGFloat = -16
}

// MARK: TextViews

extension UIConstants {
    static let textviewFont = UIFont.systemFont(ofSize: 16)
}

// MARK: Dividers

extension UIConstants {
    static let titleDividerColor = UIColor(hexString: "#3c3c43", alpha: 0.29)
}
