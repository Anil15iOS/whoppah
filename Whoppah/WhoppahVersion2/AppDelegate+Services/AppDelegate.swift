//
//  AppDelegate.swift
//  Whoppah
//
//  Created by Boris Sagan on 10/17/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import AVFoundation
import UIKit
import WhoppahUI
import SwiftUI
import Resolver

class AppDelegate: UIResponder, UIApplicationDelegate {
    @LazyInjected private var appInitializables: AppInitializable
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appInitializables.didFinishLaunchingApplication()
        return true
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}
}
