//
//  Recognition.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/18/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public class Recognition: Codable {
    // MARK: - Properties

    public let url: String

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case url
    }

    public init() { url = "" }
}
