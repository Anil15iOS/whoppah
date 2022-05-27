//
//  Artist.swift
//  WhoppahCore
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

public protocol Artist: AdAttribute {
    var id: UUID { get }
    var title: String { get }
    var slug: String { get }
    var description: String? { get }
}
