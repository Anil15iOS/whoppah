//
//  PushNotificationsParser.swift
//  Whoppah
//
//  Created by Eddie Long on 08/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

struct PushNotifications {
    // MARK: - NotificationName

    struct Name {
        static let chat = Notification.Name("com.whoppah.app.chat")
    }

    struct ChatNotificationProp {
        static let thread = "thread_id"
    }
}

struct PushNotificationsParser {
    func parseUrl(_ url: String) -> Navigator.Route {
        guard let url = URL(string: url) else { return .unknown }
        return Navigator.getRoute(forUrl: url)
    }
}
