//
//  MediaRequest.swift
//  Whoppah
//
//  Created by Eddie Long on 29/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCoreNext
import WhoppahCore
import WhoppahModel
import Resolver
import WhoppahDataStore

struct MediaRequest: HTTPUploadRequestable {
    enum RequestType {
        case uploadImage(image: Data, contentType: GraphQL.ContentType, objectId: UUID?, type: String?, position: Int?)
        case uploadVideo(video: Data, contentType: GraphQL.ContentType, objectId: UUID?, position: Int?)
    }
    
    @Injected public var appConfig: AppConfigurationProvider

    var baseURL: String? {
        let env = appConfig.environment
        let mediaHost = env.mediaHost
        return env.baseUrl(mediaHost)
    }
    
    var path: String {
        switch requestType {
        case .uploadImage:  return "/media/image"
        case .uploadVideo:  return "/media/video"
        }
    }

    var method: HTTPMethod { .post }

    var formData: [String: Any]? {
        switch requestType {
        case let .uploadImage(_, contentType, objectId, type, position):
            var body = [String: Any]()
            body["content_type"] = contentType.rawValue.lowercased()
            if let objectId = objectId {
                body["object_id"] = objectId.uuidString
            }
            if let type = type {
                body["type"] = type
            }
            if let position = position {
                body["position"] = position
            }
            return body
        case let .uploadVideo(_, contentType, objectId, position):
            var body = [String: Any]()
            body["content_type"] = contentType.rawValue.lowercased()
            if let objectId = objectId {
                body["object_id"] = objectId.uuidString
            }
            if let position = position {
                body["position"] = position
            }
            return body
        }
    }

    var file: [String: Data]? {
        switch requestType {
        case let .uploadImage(image, _, _, _, _):   return ["file": image]
        case let .uploadVideo(video, _, _, _):      return ["file": video]
        }
    }

    var filename: String? {
        switch requestType {
        case .uploadImage:  return "image.jpg"
        case .uploadVideo:  return "video.mov"
        }
    }

    var mimeType: String? {
        switch requestType {
        case .uploadImage:  return "image/jpeg"
        case .uploadVideo:  return "video/mov"
        }
    }

    var maxRetries: Int? { 3 }
    
    private var requestType: RequestType
    
    public init(_ requestType: RequestType) {
        self.requestType = requestType
    }
}
