//
//  FacebookInitializer.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import FacebookCore

struct FacebookInitializer: AppInitializable {
    func didFinishLaunchingApplication() {
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
    }
}
