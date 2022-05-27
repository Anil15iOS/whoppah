//
//  TextButton.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class TextButton: UIButton {
    // MARK: - States

    override var isEnabled: Bool {
        didSet { titleLabel?.alpha = isEnabled ? 1.0 : 0.5 }
    }

    func updateStyle() {
        setTitleColor(UIColor.space, for: .normal)
        titleLabel?.font = UIFont.button
    }
}
