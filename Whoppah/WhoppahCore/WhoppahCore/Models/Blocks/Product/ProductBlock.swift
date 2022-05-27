//
//  ProductBlock.swift
//  WhoppahCore
//
//  Created by Eddie Long on 14/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol ProductBlock {
    var titleKey: String { get }
    var buttonKey: String { get }
    var link: String? { get }
    var blockProducts: [Product] { get }
}
