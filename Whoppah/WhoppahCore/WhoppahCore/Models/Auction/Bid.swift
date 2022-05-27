//
//  Bid.swift
//  WhoppahCore
//
//  Created by Eddie Long on 24/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

public protocol Bid {
    var id: UUID { get }
    var price: Price { get }
    var state: GraphQL.BidState { get }
}

extension Bid {
    public func isActive() -> Bool {
        state != .rejected && state != .expired
    }
}
