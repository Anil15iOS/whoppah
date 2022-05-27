//
//  RoundedButton.swift
//  Whoppah
//
//  Created by Eddie Long on 22/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable var addDropShadow: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable var radiusPercentage: Float = 50 {
        didSet {
            updateCornerRadius()
        }
    }

    override var bounds: CGRect {
        didSet {
            updateCornerRadius()
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateCornerRadius()
    }

    func updateCornerRadius() {
        clipsToBounds = true
        layer.cornerRadius = rounded ? bounds.size.height / CGFloat(100 / radiusPercentage) : 0

        if addDropShadow, rounded {
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowRadius = 16
            layer.shadowOpacity = 0.1

            let backgroundCGColor = backgroundColor?.cgColor
            backgroundColor = nil
            layer.backgroundColor = backgroundCGColor
        }
    }
}
