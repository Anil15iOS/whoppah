//
//  AuctionServiceImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 24/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

final class AuctionServiceImpl: AuctionService {
    
    @Injected private var apollo: ApolloService

    func createBid(productId: UUID, auctionId: UUID, amount: PriceInput, createThread: Bool) -> Observable<Bid> {
        let input = GraphQL.BidInput(auctionId: auctionId, amount: GraphQL.PriceInput(amount: amount.amount, currency: amount.currency), createThread: createThread)
        let query = GraphQL.ProductQuery(id: productId, playlist: .hls)
        return apollo.apply(mutation: GraphQL.CreateBidMutation(input: input), query: query, storeTransaction: { (result, cachedQuery: inout GraphQL.ProductQuery.Data) in
            guard let bid = result.data?.createBid else { return }
            typealias ProductAuction = GraphQL.ProductQuery.Data.Product.Auction
            let buyer = ProductAuction.Bid.Buyer(id: bid.buyer.id)
            let amount = ProductAuction.Bid.Amount(currency: bid.amount.currency, amount: bid.amount.amount)
            if cachedQuery.product?.auction?.bids == nil {
                cachedQuery.product?.auction?.bids = [ProductAuction.Bid]()
            }
            cachedQuery.product?.auction?.bids.append(ProductAuction.Bid(id: bid.id,
                                                                         state: bid.state,
                                                                         amount: amount,
                                                                         buyer: buyer))
            var isMax = false
            if let bid = cachedQuery.product?.auction?.highestBid {
                isMax = bid.amount.amount > amount.amount && bid.amount.currency == amount.currency
            }
            if isMax {
                let amount = ProductAuction.HighestBid.Amount(currency: bid.amount.currency, amount: bid.amount.amount)
                cachedQuery.product?.auction?.highestBid = ProductAuction.HighestBid(id: bid.id,
                                                                                     state: bid.state,
                                                                                     amount: amount)
            }
        }).compactMap { $0.data }.map { $0.createBid }
    }

    func createCounterBid(productId: UUID, auctionId: UUID, amount: PriceInput, buyerId: UUID) -> Observable<Bid> {
        let input = GraphQL.CounterBidInput(auctionId: auctionId, amount: GraphQL.PriceInput(amount: amount.amount, currency: amount.currency), buyerId: buyerId)
        let query = GraphQL.ProductQuery(id: productId, playlist: .hls)
        return apollo.apply(mutation: GraphQL.CreateCounterBidMutation(input: input), query: query, storeTransaction: { (result, cachedQuery: inout GraphQL.ProductQuery.Data) in
            guard let bid = result.data?.createCounterBid else { return }
            typealias ProductAuction = GraphQL.ProductQuery.Data.Product.Auction
            typealias ProductAuctionBid = ProductAuction.Bid
            let buyer = ProductAuctionBid.Buyer(id: bid.buyer.id)
            let amount = ProductAuctionBid.Amount(currency: bid.amount.currency, amount: bid.amount.amount)
            if cachedQuery.product?.auction?.bids == nil {
                cachedQuery.product?.auction?.bids = [ProductAuctionBid]()
            }
            cachedQuery.product?.auction?.bids.append(ProductAuctionBid(id: bid.id,
                                                                        state: bid.state,
                                                                        amount: amount,
                                                                        buyer: buyer))

            var isMax = false
            if let bid = cachedQuery.product?.auction?.highestBid {
                isMax = bid.amount.amount > amount.amount && bid.amount.currency == amount.currency
            }
            if isMax {
                let amount = ProductAuction.HighestBid.Amount(currency: bid.amount.currency, amount: bid.amount.amount)
                cachedQuery.product?.auction?.highestBid = ProductAuction.HighestBid(id: bid.id,
                                                                                     state: bid.state,
                                                                                     amount: amount)
            }
        }).compactMap { $0.data }.map { $0.createCounterBid }
    }

    func acceptBid(id: UUID) -> Observable<Bid> {
        apollo.apply(mutation: GraphQL.AcceptBidMutation(id: id)).compactMap { $0.data }.map { $0.acceptBid }
    }

    func rejectBid(id: UUID) -> Observable<Bid> {
        apollo.apply(mutation: GraphQL.RejectBidMutation(id: id)).compactMap { $0.data }.map { $0.rejectBid }
    }

    func withdrawBid(id: UUID) -> Observable<UUID> {
        apollo.apply(mutation: GraphQL.WithdrawBidMutation(id: id)).compactMap { $0.data }.map { $0.withdrawBid.id }
    }
}
