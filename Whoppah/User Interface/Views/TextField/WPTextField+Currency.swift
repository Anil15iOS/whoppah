//
//  WPTextField+Currency.swift
//  Whoppah
//
//  Created by Eddie Long on 03/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

extension WPTextField {
    func setCurrencyLeftView(_ view: UIView) {
        leftViewRect = view.frame
        leftView = view
        leftViewMode = .always
    }
}
