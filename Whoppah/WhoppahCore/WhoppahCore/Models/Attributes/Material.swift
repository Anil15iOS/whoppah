//
//  Material.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public func materialTitleKey(_ slug: String) -> String {
    "material-\(slug)"
}

public protocol Material: AdAttribute {
    var id: UUID { get }
    var title: String { get }
    var slug: String { get }
    var description: String? { get }
}

extension Material {
    public var title: String {
        materialTitleKey(slug)
    }
}
