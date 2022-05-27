//
//  AppConfigurationProvider.swift
//  Whoppah
//
//  Created by Eddie Long on 05/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol AppConfigurationProvider {
    var environment: AppEnvironment { get }
    var sslCertFile: String? { get }
}

extension AppConfigurationProvider {
    public var sslCertFile: String? {
        nil
    }
}
