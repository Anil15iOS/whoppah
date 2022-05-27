//
//  UIApplication.swift
//  Whoppah
//
//  Created by Eddie Long on 06/10/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var window: UIWindow? {
        return (self.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }
}
