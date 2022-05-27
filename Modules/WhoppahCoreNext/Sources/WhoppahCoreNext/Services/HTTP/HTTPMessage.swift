//
//  HTTPMessage.swift
//  WhoppahCoreNext
//
//  Created by Boris Sagan on 11/5/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public class HTTPMessage: Codable {
    // MARK: - Properties

    public let text: String?

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case text = "detail"
    }
}
