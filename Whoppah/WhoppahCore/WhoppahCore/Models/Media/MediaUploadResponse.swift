//
//  MediaUploadResponse.swift
//  WhoppahCore
//
//  Created by Eddie Long on 26/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public class MediaUploadResponse: Codable {
    // MARK: - Properties

    public let id: UUID

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id
    }
}
