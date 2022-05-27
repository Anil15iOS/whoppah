//
//  CurvedCard.swift
//  Whoppah
//
//  Created by Eddie Long on 19/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CurvedCard: UIView {
    @IBInspectable var percentage: Double = 10.0 {
        didSet {
            updateCorners()
        }
    }

    private let corners: UIRectCorner = [.bottomRight]

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCorners()
    }

    override func prepareForInterfaceBuilder() {
        updateCorners()
    }

    private func updateCorners() {
        let radius = frame.size.width / 100.0 * CGFloat(percentage)
        roundCorners(corners: corners, radius: radius)
    }
}

@IBDesignable
class CurvedCardImage: UIImageView {
    @IBInspectable var percentage: Double = 10.0 {
        didSet {
            updateCorners()
        }
    }

    private let corners: UIRectCorner = [.bottomRight]

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCorners()
    }

    override func prepareForInterfaceBuilder() {
        updateCorners()
    }

    private func updateCorners() {
        let radius = frame.size.width / 100.0 * CGFloat(percentage)
        roundCorners(corners: corners, radius: radius)
    }
}
