//
//  AppInitializables.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation

struct AppInitializables: AppInitializable {
    private var initializables: [AppInitializable]
    
    init() {
        #if DEBUG
        initializables = [
            AudioInitializer(),
            DeeplinkManagerInitializer(),
            FacebookInitializer(),
            FirebaseInitializer(),
            GoogleInitializer(),
            IQKeyboardManagerInitializer(),
            LokaliseInitializer(),
            StripeInitializer()
        ]
        #else
        initializables = [
            AudioInitializer(),
            DeeplinkManagerInitializer(),
            FacebookInitializer(),
            FirebaseInitializer(),
            GoogleInitializer(),
            IQKeyboardManagerInitializer(),
            LokaliseInitializer(),
            StripeInitializer()
        ]
        #endif
    }
    
    func didFinishLaunchingApplication() {
        initializables.forEach { $0.didFinishLaunchingApplication() }
    }
    
    func sceneDidBecomeActive() {
        initializables.forEach { $0.sceneDidBecomeActive() }
    }
}
