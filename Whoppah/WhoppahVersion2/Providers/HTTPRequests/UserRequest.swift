//
//  UserRequest.swift
//  Whoppah
//
//  Created by Boris Sagan on 9/28/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCoreNext
import WhoppahCore

enum UserRequest: HTTPRequestable {
    case notificationSettings
    case updateNotificationSettings(settings: NotificationSettings)

    var path: String {
        switch self {
        case .notificationSettings, .updateNotificationSettings:
            return "/profile/notification-settings"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .notificationSettings:
            return .get
        case .updateNotificationSettings:
            return .put
        }
    }

    var body: [String: Any]? {
        switch self {
        case let .updateNotificationSettings(settings):
            guard let data = try? JSONEncoder().encode(settings) else { return nil }
            let body = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
            return body
        default:
            return nil
        }
    }
}
