//
//  RectangleBorderView.swift
//  Whoppah
//
//  Created by Eddie Long on 23/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RectangleBorderView: UIView {
    var borderLayer: CAShapeLayer?
    private let padding: CGFloat = 8

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        commonInit()
    }

    override var bounds: CGRect {
        didSet {
            let newBounds = CGRect(x: -padding, y: -padding, width: bounds.width + padding * 2, height: bounds.height + padding * 2)
            borderLayer?.frame = newBounds
        }
    }

    // MARK: - Common

    private func commonInit() {
        let border = CAShapeLayer()
        border.strokeColor = UIColor.white.cgColor

        border.fillColor = nil
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = 1
        let newBounds = CGRect(x: -padding, y: -padding, width: frame.size.width + padding * 2, height: frame.size.height + padding * 2)
        border.frame = newBounds
        // border.path = UIBezierPath(rect: newBounds).cgPath
        layer.addSublayer(border)
        borderLayer = border
    }
}
