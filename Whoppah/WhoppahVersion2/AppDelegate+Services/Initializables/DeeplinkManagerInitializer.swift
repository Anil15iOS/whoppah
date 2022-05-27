//
//  DeeplinkManagerInitializer.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation

struct DeeplinkManagerInitializer: AppInitializable {
    func sceneDidBecomeActive() {
        DeeplinkManager.shared.executeDeeplink()
    }
}
