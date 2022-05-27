//
//  FeatureService.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol FeatureService {
    /// Whether SSL pinning is enabled in the app
    var sslPinningEnabled: Bool { get }
}
