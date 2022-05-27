//
//  Device.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/18/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

class Device: Codable {
    // MARK: - Properties

    let ID: Int

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case ID = "id"
    }
}
