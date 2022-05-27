//
//  RoundedView.swift
//  Whoppah
//
//  Created by Eddie Long on 08/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable var radiusPercentage: Float = 50 {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable var addDropShadow: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateCornerRadius()
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / CGFloat(100 / radiusPercentage) : 0
        layer.masksToBounds = true

        if addDropShadow, rounded {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 16
            layer.shadowOpacity = 0.1
        }
    }
}
