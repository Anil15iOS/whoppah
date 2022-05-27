//
//  GradientHeaderView.swift
//  Whoppah
//
//  Created by Eddie Long on 11/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class GradientHeaderView: UIView {
    var gradient: CAGradientLayer?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    override var bounds: CGRect {
        didSet {
            gradient?.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height)
        }
    }

    // MARK: - Common

    private func setupGradient() {
        let gradient = CAGradientLayer()

        gradient.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: isInverted ? 0.0 : 0.4).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: isInverted ? 0.4 : 0.0).cgColor
        ]

        gradient.locations = [0, 1]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height)
        if let existing = self.gradient, let index = layer.sublayers?.firstIndex(of: existing) {
            layer.sublayers?.remove(at: index)
        }
        layer.insertSublayer(gradient, at: 0)
        self.gradient = gradient
    }

    @IBInspectable var isInverted: Bool = false {
        didSet {
            setupGradient()
        }
    }

    var gradientOpacity: Float = 1.0 {
        didSet {
            self.layer.sublayers?.first?.opacity = gradientOpacity
        }
    }
}
