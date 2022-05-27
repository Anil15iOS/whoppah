//
//  Auction.swift
//  WhoppahCore
//
//  Created by Eddie Long on 24/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

public protocol Auction {
    var id: UUID { get }
    var state: GraphQL.AuctionState { get }
    var currentHighestBid: Bid? { get }
    var bidCount: Int { get }
    var allBids: [Bid] { get }

    var minBid: Price? { get }
    var buyNowValue: Price? { get }
    var allowBid: Bool { get }
    var allowBuyNow: Bool { get }

    var endDate: DateTime? { get }
}

public protocol AuctionBasic {
    var id: UUID { get }
    var state: GraphQL.AuctionState { get }
    var allowBid: Bool { get }
    var allowBuyNow: Bool { get }
    var minBid: Price? { get }
    var buyNowValue: Price? { get }
}
