//
//  Device.swift
//  Whoppah
//
//  Created by Eddie Long on 26/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import ARKit
import Foundation

extension Device {
    static func supportsAR() -> Bool {
        ARConfiguration.isSupported
    }
}
