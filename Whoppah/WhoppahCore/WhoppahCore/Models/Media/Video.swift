//
//  Video.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol Video {
    var id: UUID { get }
    var url: String { get }
    var thumbnail: String { get }
}

public extension Video {
    func asURL() -> URL? { URL(string: url) }
}
