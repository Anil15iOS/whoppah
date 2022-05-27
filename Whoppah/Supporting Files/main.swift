//
//  main.swift
//  Whoppah
//
//  Created by Eddie Long on 17/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

let isRunningTests = Bundle.isRunningTests()
let appDelegateClass: String = isRunningTests ? NSStringFromClass(TestingAppDelegate.self) : NSStringFromClass(AppDelegate.self)
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClass)
