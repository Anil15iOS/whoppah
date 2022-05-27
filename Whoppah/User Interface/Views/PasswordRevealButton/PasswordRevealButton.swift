//
//  PasswordRevealButton.swift
//  Whoppah
//
//  Created by Eddie Long on 01/05/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class PasswordRevealButton: UIButton {
    @IBOutlet var textfield: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(addTap(_:)), for: .touchUpInside)
    }

    @objc func addTap(_: UIButton) {
        textfield.isSecureTextEntry = !textfield.isSecureTextEntry
        isSelected = !isSelected
    }
}
