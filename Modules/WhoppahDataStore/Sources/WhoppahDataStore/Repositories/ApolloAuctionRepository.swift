//
//  ApolloAuctionRepository.swift
//  WhoppahDataStore
//
//  Created by Marko Stojkovic on 15.4.22..
//

import Foundation
import Apollo
import Combine
import Resolver
import WhoppahRepository
import WhoppahModel

class ApolloAuctionRepository: AuctionRepository {
    
    @Injected private var apollo: ApolloService
    
    func createBid(product: WhoppahModel.Product,
                   amount: WhoppahModel.Price,
                   createThread: Bool) -> AnyPublisher<Bid, Error> {
        guard let auction = product.auction else {
            return Fail(outputType: Bid.self, failure: WhoppahRepository.Error.missingAuction)
                .eraseToAnyPublisher()
        }
        
        let input = GraphQL.BidInput(auctionId: auction.id,
                                     amount: GraphQL.PriceInput(amount: Double(amount.amount),
                                                                currency: amount.currency.toGraphQLCurrency),
                                     createThread: createThread)
        let query = GraphQL.ProductQuery(id: product.id, playlist: .hls)
        return apollo.apply(mutation: GraphQL.CreateBidMutation(input: input),
                            query: query,
                            storeTransaction: { (result, cachedQuery: inout GraphQL.ProductQuery.Data) in
            guard let bid = result.data?.createBid else { return }
            typealias ProductAuction = GraphQL.ProductQuery.Data.Product.Auction
            let buyer = ProductAuction.Bid.Buyer(id: bid.buyer.id)
            let amount = ProductAuction.Bid.Amount(currency: bid.amount.currency,
                                                   amount: bid.amount.amount)
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
        })
        .tryMap { result -> Bid in
            guard let bid = result.data?.createBid else {
                throw WhoppahRepository.Error.noData
            }
            return bid.toWhoppahModel
        }
        .eraseToAnyPublisher()
    }
    
    func createCounterBid(productId: UUID,
                          auctionId: UUID,
                          amount: PriceInput,
                          buyerId: UUID) -> AnyPublisher<Bid, Error> {
        let input = GraphQL.CounterBidInput(auctionId: auctionId,
                                            amount: GraphQL.PriceInput(amount: Double(amount.amount),
                                                                       currency: amount.currency.toGraphQLCurrency),
                                            buyerId: buyerId)
        let query = GraphQL.ProductQuery(id: productId, playlist: .hls)
        return apollo.apply(mutation: GraphQL.CreateCounterBidMutation(input: input),
                            query: query,
                            storeTransaction: { (result, cachedQuery: inout GraphQL.ProductQuery.Data) in
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
        })
        .tryMap { result -> Bid in
            guard let bid = result.data?.createCounterBid else {
                throw WhoppahRepository.Error.noData
            }
            return bid.toWhoppahModel
        }
        .eraseToAnyPublisher()
    }
    
    func acceptBid(id: UUID) -> AnyPublisher<Bid, Error> {
        apollo.apply(mutation: GraphQL.AcceptBidMutation(id: id))
            .tryMap { result -> Bid in
                guard let bid = result.data?.acceptBid else {
                    throw WhoppahRepository.Error.noData
                }
                return bid.toWhoppahModel
            }
            .eraseToAnyPublisher()
    }
    
    func rejectBid(id: UUID) -> AnyPublisher<Bid, Error> {
        apollo.apply(mutation: GraphQL.RejectBidMutation(id: id))
            .tryMap { result -> Bid in
                guard let bid = result.data?.rejectBid else {
                    throw WhoppahRepository.Error.noData
                }
                return bid.toWhoppahModel
            }
            .eraseToAnyPublisher()
    }
    
    func withdrawBid(id: UUID) -> AnyPublisher<UUID, Error> {
        apollo.apply(mutation: GraphQL.WithdrawBidMutation(id: id))
            .tryMap({ result -> UUID in
                guard let id = result.data?.withdrawBid.id else {
                    throw WhoppahRepository.Error.noData
                }
                return id
            })
            .eraseToAnyPublisher()
    }
}
