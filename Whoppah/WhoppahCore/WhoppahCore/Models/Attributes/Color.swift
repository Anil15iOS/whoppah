//
//  Color.swift
//  WhoppahCore
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public func colorTitleKey(_ slug: String) -> String {
    "color-\(slug)"
}

public protocol Color: AdAttribute {
    var id: UUID { get }
    var title: String { get }
    var hex: String { get }
    var slug: String { get }
    var description: String? { get }
}
