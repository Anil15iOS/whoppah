//
//  Image.swift
//  WhoppahCore
//
//  Created by Eddie Long on 15/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol Image {
    var id: UUID { get }
    var url: String { get }
}

public extension Image {
    func asURL() -> URL? { URL(string: url) }
}
