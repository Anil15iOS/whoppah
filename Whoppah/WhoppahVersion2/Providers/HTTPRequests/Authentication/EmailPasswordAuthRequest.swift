//
//  EmailPasswordAuthRequest.swift
//  Whoppah
//
//  Created by Dennis Ippel on 17/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCoreNext
import WhoppahModel
import Resolver

struct EmailPasswordAuthRequest: HTTPRequestable {
    enum RequestType {
        case signOut(fcmToken: String)
    }
    
    @Injected public var appConfig: AppConfigurationProvider
    
    var baseURL: String? {
        let env = appConfig.environment
        return env.baseUrl(env.authHost)
    }
    
    var path: String {
        switch requestType {
        case .signOut:  return "/auth/logout"
        }
    }
    
    var method: HTTPMethod { .post }
    
    var body: [String: Any]? {
        switch requestType {
        case let .signOut(fcmToken):
            return ["device_id": fcmToken]
        }
    }

    private var requestType: RequestType
    
    public init(_ requestType: RequestType) {
        self.requestType = requestType
    }
}
