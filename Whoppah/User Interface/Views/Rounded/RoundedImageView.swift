//
//  RoundedImageView.swift
//  Whoppah
//
//  Created by Eddie Long on 26/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
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
        layer.cornerRadius = rounded ? bounds.size.height / CGFloat(100 / radiusPercentage) : 0
        layer.masksToBounds = true
    }
}
