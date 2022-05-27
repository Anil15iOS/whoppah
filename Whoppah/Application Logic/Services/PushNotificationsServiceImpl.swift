//
//  PushNotificationsService.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/18/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Firebase
import FirebaseMessaging
import UIKit
import UserNotifications
import WhoppahCore
import WhoppahCoreNext
import Apollo
import Resolver
import WhoppahDataStore

//private struct PushNotificationsServiceKey: InjectionKey {
//    static var currentValue: PushNotificationsService = PushNotificationsServiceImpl()
//}

class PushNotificationsServiceImpl: NSObject, PushNotificationsService {
    // MARK: - Properties
    
    @Injected fileprivate var inAppNotifier: InAppNotifier
    @Injected fileprivate var user: WhoppahCore.LegacyUserService
    @Injected fileprivate var apollo: ApolloService

    var openedThreadID: UUID?
    private let parser = PushNotificationsParser()

    var fcmToken: String? { Messaging.messaging().fcmToken }

    // MARK: - Request and Register Token

    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        fixPushNotificationsFirebaseUpgradeHack()

        checkNotificationPermission { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self.registerFcmToken()
            default:
                break
            }
        }
    }

    public func checkNotificationPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    private func requestNotificationPermissionInternal(completion: @escaping ((Bool) -> Void)) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { success, error in
            if error == nil, success {
                completion(true)
            } else {
                completion(false)
            }
        })
    }

    private func fixPushNotificationsFirebaseUpgradeHack() {
        #if STAGING || TESTING
            // First issue caused by upgrading from Firebase 5.15.x to 5.20.x
            // Users (only internal) had their devices permentantly broken by the upgrade
            // The fix as suggested by the issue below is to delete the ID once and re-issue it again
            // See issue: https://github.com/firebase/firebase-ios-sdk/issues/2438
            // Remove this when the 6.1.0 version of Firebase Messaging is available in Cocoapods
            let oneTimeWorkaroundKey = "firebase-2438-issue"
            let deleteCount = UserDefaults.standard.integer(forKey: oneTimeWorkaroundKey)
            if deleteCount == 0 {
                /* InstanceID.instanceID().deleteID { error in
                     if let cError = error {
                         print("APNS: Error on delete: \(cError)")
                     } else {
                         UserDefaults.standard.set(deleteCount + 1, forKey: oneTimeWorkaroundKey)
                     }
                 } */
            }
        #endif
    }

    private func registerFcmToken() {
        guard let token = Messaging.messaging().fcmToken else { return }
        guard user.isLoggedIn == true else { return }

        let mutation = GraphQL.RegisterFcmTokenMutation(token: token, name: "iOS")
        _ = apollo.apply(mutation: mutation).subscribe(onNext: { success in
            print("FCMtoken>>> registered: \(success)")
        })
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationsServiceImpl: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let type = notification.getType() else { return }

        // Showing blue banner on Home Screen
        inAppNotifier.notify(.updateChatBadgeCount)

        switch type {
        case let .route(value):
            let result = parser.parseUrl(value)
            switch result {
            case let .chat(threadID):
                let thread = [PushNotifications.ChatNotificationProp.thread: threadID]
                NotificationCenter.default.post(name: PushNotifications.Name.chat, object: nil, userInfo: thread)
                if threadID != openedThreadID {
                    completionHandler([.sound, .alert])
                }
            default:
                completionHandler([.sound, .alert])
            }
        case .message:
            completionHandler([.sound, .alert])
        default:
            break
        }
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()

        guard let type = response.notification.getType() else { return }

        switch type {
        case let .route(value):
            let result = parser.parseUrl(value)
            // Don't navigate to chat if already opened
            // It will be updated anyway
            if case let .chat(thread) = result {
                guard thread != self.openedThreadID else { return }
            }
            Navigator().navigate(route: result)
        default:
            break
        }
    }
}

// MARK: - MessagingDelegate

extension PushNotificationsServiceImpl: MessagingDelegate {
    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard user.isLoggedIn == true,
              let fcmToken = fcmToken
        else { return }
        
        let mutation = GraphQL.RegisterFcmTokenMutation(token: fcmToken, name: "iOS")
        _ = apollo.apply(mutation: mutation).subscribe(onNext: { success in
            print("FCMtoken>>> registered: \(success)")
        })
    }

    func requestNotificationPermission(completion: @escaping ((Bool) -> Void)) {
        requestNotificationPermissionInternal(completion: { result in
            if result {
                self.registerForRemoteNotifications()
            }
            completion(result)
        })
    }
}
