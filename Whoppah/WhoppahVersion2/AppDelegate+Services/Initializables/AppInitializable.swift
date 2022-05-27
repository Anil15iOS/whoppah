//
//  AppInitializable.swift
//  Whoppah
//
//  Created by Dennis Ippel on 14/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation

protocol AppInitializable {
    func didFinishLaunchingApplication()
    func sceneDidBecomeActive()
}

extension AppInitializable {
    func didFinishLaunchingApplication() {}
    func sceneDidBecomeActive() {}
}
