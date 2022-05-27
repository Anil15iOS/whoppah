//
//  NotificationSettings.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/18/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public class NotificationSettings: Codable {
    // MARK: - Properties

    public var pushChat: Bool
    public var pushUpdates: Bool
    public var emailUpdates: Bool
    public var emailAccount: Bool
    public let ID: Int
    public let userID: Int

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case pushChat = "push_chat"
        case pushUpdates = "push_updates"
        case emailUpdates = "email_updates"
        case emailAccount = "email_account"
        case ID = "id"
        case userID = "user"
    }
}
