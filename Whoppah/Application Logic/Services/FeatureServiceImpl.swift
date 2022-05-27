//
//  FeatureService.swift
//  Whoppah
//
//  Created by Eddie Long on 16/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

final class FeatureServiceImpl: FeatureService {
    // Whether SSL pinning is enabled in the app
    // Regardless of whether the SSL cert is in the bundle or not
    #if DEBUG
        let sslPinningEnabled: Bool = false // Turn off in debug so Charles can be used
    #else
        let sslPinningEnabled: Bool = false
    #endif
}
