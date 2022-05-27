//
//  PushNotificationsService.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol PushNotificationsService {
    /// The current opened chat thread id
    // TODO: Attempt to remove this
    var openedThreadID: UUID? { get set }

    /// The Firebase FCM push notification token
    var fcmToken: String? { get }

    /// Register for push notifications with iOS and the Whoppah backend
    func registerForRemoteNotifications()

    /// Requests push notification permission
    ///
    /// - Parameter completion Called when notification permission has been determined
    func requestNotificationPermission(completion: @escaping ((Bool) -> Void))

    /// Checks whether notification permission is granted
    ///
    /// - Parameter completion Called when notification permission has been determined
    func checkNotificationPermission(completion: @escaping (UNAuthorizationStatus) -> Void)
}
