//
//  FirebaseInitializer.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

struct FirebaseInitializer: AppInitializable {
    func didFinishLaunchingApplication() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        RemoteConfig.remoteConfig().fetchAndActivate { status, error in
            
        }
    }
}
