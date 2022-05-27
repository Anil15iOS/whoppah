//
//  UINavigationBar.swift
//  Whoppah
//
//  Created by Eddie Long on 15/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func setTransparent(_ value: Bool) {
        isTranslucent = value
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
}
