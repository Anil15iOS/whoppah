//
//  Staging.swift
//  Whoppah
//
//  Created by Eddie Long on 05/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahCoreNext
import Resolver
import Testing_Debug

public let showVerboseUserErrors = true

struct StagingConfiguration: AppConfigurationProvider {
    init() {
        #if DISTRIBUTION
            fatalError()
        #endif
        #if !STAGING
            fatalError()
        #endif
        #if TESTING
            fatalError()
        #endif
    }

    var environment: Environment {
        Environment("Staging",
                    host: "https://gateway.staging.whoppah.dev",
                    authHost: "https://dashboard.staging.whoppah.dev",
                    graphHost: "https://gateway.staging.whoppah.dev",
                    mediaHost: "https://gateway.staging.whoppah.dev",
                    version: "v1")
    }
}

extension Resolver {
    static func registerAppConfigurationProvider() {
        register { StagingConfiguration() as AppConfigurationProvider }
    }
}
