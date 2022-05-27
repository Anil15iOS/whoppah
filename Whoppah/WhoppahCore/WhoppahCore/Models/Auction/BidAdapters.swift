//
//  BidAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 24/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.CreateBidMutation.Data.CreateBid: Bid {
    public var price: WhoppahCore.Price { amount }
}

extension GraphQL.CreateCounterBidMutation.Data.CreateCounterBid.Amount: Price {}
extension GraphQL.CreateCounterBidMutation.Data.CreateCounterBid: Bid {
    public var price: WhoppahCore.Price { amount }
}

extension GraphQL.AcceptBidMutation.Data.AcceptBid.Amount: Price {}
extension GraphQL.AcceptBidMutation.Data.AcceptBid: Bid {
    public var price: WhoppahCore.Price { amount }
}

extension GraphQL.RejectBidMutation.Data.RejectBid.Amount: Price {}
extension GraphQL.RejectBidMutation.Data.RejectBid: Bid {
    public var price: WhoppahCore.Price { amount }
}

extension GraphQL.GetBidQuery.Data.Bid.Amount: Price {}
extension GraphQL.GetBidQuery.Data.Bid: Bid {
    public var price: WhoppahCore.Price { amount }
}
