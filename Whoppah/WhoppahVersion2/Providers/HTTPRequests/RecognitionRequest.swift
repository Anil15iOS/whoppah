//
//  RecognitionService.swift
//  Whoppah
//
//  Created by Eddie Long on 09/03/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCoreNext
import WhoppahModel
import Resolver

struct RecognitionRequest: HTTPUploadRequestable {
    enum RequestType {
        case uploadImage(image: Data)
    }
    
    @Injected public var appConfig: AppConfigurationProvider

    var baseURL: String? {
        let env = appConfig.environment
        let mediaHost = env.mediaHost
        return env.baseUrl(mediaHost)
    }
    
    var path: String {
        switch requestType {
        case .uploadImage:
            return "/cloudvision"
        }
    }

    var method: HTTPMethod {
        switch requestType {
        case .uploadImage:
            return .post
        }
    }

    var file: [String: Data]? {
        switch requestType {
        case let .uploadImage(image):
            return ["image": image]
        }
    }

    var filename: String? {
        switch requestType {
        case .uploadImage:
            return "image.jpg"
        }
    }

    var mimeType: String? {
        switch requestType {
        case .uploadImage:
            return "image/jpeg"
        }
    }

    var maxRetries: Int? {
        switch requestType {
        case .uploadImage:
            return 3
        }
    }
    
    private var requestType: RequestType
    
    public init(_ requestType: RequestType) {
        self.requestType = requestType
    }
}
