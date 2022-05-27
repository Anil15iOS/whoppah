//
//  UNNotification.swift
//  Whoppah
//
//  Created by Eddie Long on 08/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UserNotifications
import WhoppahCore

extension UNNotification {
    func getType() -> PushNotificationType? {
        guard let value = request.content.userInfo["route"] as? String else {
            if request.content.body.isEmpty { return nil }
            return .message(text: request.content.body)
        }
        return .route(value: value)
    }
}
