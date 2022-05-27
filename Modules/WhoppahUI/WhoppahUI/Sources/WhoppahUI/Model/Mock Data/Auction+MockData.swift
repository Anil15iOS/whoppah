//
//  Auction+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation
import WhoppahModel

extension WhoppahModel.Auction {
    static var random: Self {
        let id = UUID()
        
        return .init(
            id: id,
            identifier: id.uuidString,
            state: Self.randomAuctionState,
            product: UUID(),
            startDate: nil,
            expiryDate: nil,
            endDate: nil,
            buyNowPrice: Price(amount: Double.random(in: 10...20000), currency: .eur),
            minimumBid: Price(amount: Double.random(in: 10...20000), currency: .eur),
            allowBid: Int.random(in: 0...1) == 1,
            allowBuyNow: Int.random(in: 0...1) == 1,
            bidCount: Int.random(in: 0...8),
            bids: [])
    }
    
    private static var randomAuctionState: AuctionState {
        return [AuctionState.completed,
                .published,
                .published,
                .published,
                .reserved]
            .randomElement() ?? .completed
    }
}
