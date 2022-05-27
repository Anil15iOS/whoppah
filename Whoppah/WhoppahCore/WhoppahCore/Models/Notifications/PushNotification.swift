//
//  PushNotification.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/18/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public struct PushNotification {
    // MARK: - Properties

    public let text: String
    public let payload: PushNotificationPayload?
    public let type: PushNotificationType
}
