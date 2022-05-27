//
//  HairlineConstraint.swift
//  Whoppah
//
//  Created by Eddie Long on 25/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

class HairlineConstraint: NSLayoutConstraint {
    override func awakeFromNib() {
        super.awakeFromNib()

        constant = 1.0 / UIScreen.main.scale
    }
}
