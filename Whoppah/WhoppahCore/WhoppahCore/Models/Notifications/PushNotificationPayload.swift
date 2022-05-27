//
//  PushNotificationPayload.swift
//  Whoppah
//
//  Created by Eddie Long on 12/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public class PushNotificationPayload: Codable {
    public let url: URL?

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case url
    }
}
