//
//  Testing.swift
//  Whoppah-testing
//
//  Created by Eddie Long on 11/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahCoreNext
import WhoppahModel
import Resolver

public let showVerboseUserErrors = false

struct TestingConfiguration: AppConfigurationProvider {
    init() {
        #if DISTRIBUTION
            fatalError()
        #endif
        #if STAGING
            fatalError()
        #endif
        #if !TESTING
            fatalError()
        #endif
    }

    var environment: AppEnvironment {
        #if DEBUG
            var isLocal = false
            for arg in ProcessInfo.processInfo.arguments {
                let components = arg.components(separatedBy: "=")
                if components.count <= 1 { continue }
                switch components[0] {
                case "LOCAL":
                    let rhs = components[1].lowercased()
                    isLocal = rhs == "1" || rhs == "true"
                default: break
                }
            }

            // Toggle this if you want to use staging in the debugger
            if isLocal {
                return AppEnvironment("LocalDev",
                                   host: "https://gateway.testing.whoppah.com",
                                   authHost: "https://dashboard.testing.whoppah.com",
                                   graphHost: "http://127.0.0.1:3000",
                                   mediaHost: "https://gateway.testing.whoppah.com",
                                   version: "v1")
            }
        #endif

        return AppEnvironment("Testing",
                           host: "https://gateway.testing.whoppah.com",
                           authHost: "https://dashboard.testing.whoppah.com",
                           graphHost: "https://gateway.testing.whoppah.com",
                           mediaHost: "https://gateway.testing.whoppah.com",
                           version: "v1")
    }
}

extension Resolver {
    static func registerAppConfigurationProvider() {
        lazy var configuration: TestingConfiguration = {
            TestingConfiguration()
        }()
        register { configuration as AppConfigurationProvider }
    }
}
