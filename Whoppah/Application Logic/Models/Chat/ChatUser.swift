//
//  ChatUser.swift
//  Whoppah
//
//  Created by Eddie Long on 06/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import MessengerKit
import WhoppahCore
import WhoppahDataStore

struct ChatUser: MSGUser {
    var id: UUID
    var displayName: String
    var avatar: UIImage?
    let avatarUrl: URL?

    private let role: GraphQL.SubscriberRole?
    var isSender: Bool = false

    init(id: UUID, displayName: String, avatarUrl: URL?, role: GraphQL.SubscriberRole?) {
        self.id = id
        self.displayName = displayName
        self.avatarUrl = avatarUrl
        avatar = nil
        self.role = role
    }

    init(id: UUID, displayName: String, avatar: UIImage, role: GraphQL.SubscriberRole?) {
        self.id = id
        self.displayName = displayName
        avatarUrl = nil
        self.avatar = avatar
        self.role = role
    }

    func isBot() -> Bool {
        if case .bot = role {
            return true
        }
        return false
    }
}
