//
//  InAppNotifier.swift
//  
//
//  Created by Dennis Ippel on 01/12/2021.
//

import Foundation

public struct InAppNotifier {
    
    public enum NotificationName: String {
        case userLoggedOut = "com.whoppah.app.userLoggedOut"
        case userProfileUpdated = "com.whoppah.app.user.profile.updated"
        case userProfileAvatarUpdated = "com.whoppah.app.user.profile.avatar.updated"
        case updateChatBadgeCount = "com.whoppah.app.updateChatBadge"
        case chatMessagesRead = "com.whoppah.app.chat.read"

        case adDeleted = "com.whoppah.ad.deleted"
        case adReposted = "com.whoppah.ad.reposted"
        case adCreated = "com.whoppah.ad.created"
        case adUpdated = "com.whoppah.ad.updated"
        
        public var name: NSNotification.Name {
            return NSNotification.Name(self.rawValue)
        }
    }
    
    public init() {}
    
    public func notify(_ notificationName: NotificationName, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: notificationName.name,
                                        object: nil,
                                        userInfo: userInfo)
    }
}
