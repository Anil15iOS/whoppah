//
//  AppEnvironment.swift
//  WhoppahCore
//
//  Created by Eddie Long on 06/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public struct AppEnvironment {
    // MARK: - Properties

    public var name: String = ""
    public var host: String = ""
    public var graphHost: String = ""
    public var authHost: String = ""
    public var mediaHost: String = ""
    public var version: String = ""
    public var headers: [String: Any] = [:]
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData

    // MARK: - Initialization
    
    public init() {}

    public init(_ name: String,
                host: String,
                authHost: String,
                graphHost: String,
                mediaHost: String,
                version: String) {
        self.name = name
        self.host = host
        self.graphHost = graphHost
        self.authHost = authHost
        self.mediaHost = mediaHost
        self.version = version
    }

    public func baseUrl(_ host: String) -> String {
        host + "/api" + "/\(version)"
    }
}
