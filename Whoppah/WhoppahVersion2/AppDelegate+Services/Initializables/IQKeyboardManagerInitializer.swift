//
//  IQKeyboardManagerInitializer.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

struct IQKeyboardManagerInitializer: AppInitializable {
    func didFinishLaunchingApplication() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}
