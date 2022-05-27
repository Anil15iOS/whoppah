//
//  Page.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/18/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

class Page<T: Codable>: Codable {
    // MARK: - Properties

    let count: Int
    let next: URL?
    let previous: URL?
    let results: [T]?

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
}
