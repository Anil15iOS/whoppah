//
//  PushNotificationType.swift
//  Whoppah
//
//  Created by Eddie Long on 08/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public enum PushNotificationType {
    case route(value: String)
    case message(text: String)
    case unknown
}
