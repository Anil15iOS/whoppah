//
//  LokaliseInitializer.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import Lokalise

struct LokaliseInitializer: AppInitializable {
    func didFinishLaunchingApplication() {
        Lokalise.shared.setProjectID("214963985d56c3942fdbd2.64093634", token: "af6c7e77b026256b697e1d3f9b959dc99242c2a7")
        Lokalise.shared.swizzleMainBundle()

        // Segment
        #if TESTING
            Lokalise.shared.localizationType = .prerelease
        #else
            Lokalise.shared.localizationType = .release
        #endif
    }
    
    func sceneDidBecomeActive() {
        Lokalise.shared.checkForUpdates { _, errorOrNil in
            guard errorOrNil == nil else { return }
            onStringsLoaded()
        }
    }
}
