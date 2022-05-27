//
//  Production.swift
//  Whoppah
//
//  Created by Eddie Long on 05/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahCoreNext
import WhoppahModel
import Resolver

#if DEBUG
    public let showVerboseUserErrors = true
#else
    // NEVER CHANGE BELOW
    public let showVerboseUserErrors = false
#endif

struct ProductionConfiguration: AppConfigurationProvider {
    init() {
        #if !DEBUG
            assert(!showVerboseUserErrors)
        #endif
        #if !DISTRIBUTION
            fatalError()
        #endif
        #if STAGING
            fatalError()
        #endif
        #if TESTING
            fatalError()
        #endif
    }

    var environment: AppEnvironment {
        AppEnvironment("Production",
                    host: "https://gateway.production.whoppah.com",
                    authHost: "https://dashboard.production.whoppah.com",
                    graphHost: "https://gateway.production.whoppah.com",
                    mediaHost: "https://gateway.production.whoppah.com",
                    version: "v1")
    }

    var sslCertFile: String? { Bundle.main.path(forResource: "production_cert", ofType: "cer") }
}

extension Resolver {
    static func registerAppConfigurationProvider() {
        register { ProductionConfiguration() as AppConfigurationProvider }
    }
}
