//
//  Style.swift
//  WhoppahCore
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public func styleTitleKey(_ slug: String) -> String {
    "style-\(slug)"
}

public protocol Style: AdAttribute {
    var id: UUID { get }
    var title: String { get }
    var slug: String { get }
    var description: String? { get }
}

extension Style {
    public var title: String {
        styleTitleKey(slug)
    }
}
