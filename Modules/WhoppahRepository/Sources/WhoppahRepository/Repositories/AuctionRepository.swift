//
//  AuctionRepository.swift
//  WhoppahRepository
//
//  Created by Marko Stojkovic on 15.4.22..
//

import Foundation
import Combine
import WhoppahModel

public protocol AuctionRepository {
    /// Create a bid in a given auction for an amount
    ///
    /// - Parameter product The product to bid on
    /// - Parameter amount The amount to bid
    /// - Parameter createThread Whether a thread should be created as part of the bid. Generaly true but set to false in certain scenarios, such as buy now.
    /// - Returns: An observable with the newly created bid
    func createBid(product: WhoppahModel.Product, amount: WhoppahModel.Price, createThread: Bool) -> AnyPublisher<Bid, Error>

    /// Create a counter bid in a given auction for an amount
    ///
    /// - Parameter productId The id of the product to counter on
    /// - Parameter auctionId The auction to add the counter bid to
    /// - Parameter amount The amount to bid
    /// - Parameter buyerId The id of the buyer of the item
    /// - Returns: An observable with the newly created bid
    func createCounterBid(productId: UUID, auctionId: UUID, amount: PriceInput, buyerId: UUID) -> AnyPublisher<Bid, Error>

    /// Accepts a 'new' bid
    ///
    /// - Parameter id The id of the bid to accept
    /// - Returns: An observable with the updated bid
    func acceptBid(id: UUID) -> AnyPublisher<Bid, Error>

    /// Rejects a 'new' bid
    ///
    /// - Parameter id The id of the bid to reject
    /// - Returns: An observable with the updated bid
    func rejectBid(id: UUID) -> AnyPublisher<Bid, Error>

    /// Withdraws a 'new' bid
    ///
    /// - Parameter id The id of the bid to withdraw
    /// - Returns: An observable with the updated bid
    func withdrawBid(id: UUID) -> AnyPublisher<UUID, Error>
}
