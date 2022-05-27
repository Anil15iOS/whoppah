//
//  AuctionService.swift
//  Whoppah
//
//  Created by Eddie Long on 24/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

public protocol AuctionService {
    /// Create a bid in a given auction for an amount
    ///
    /// - Parameter productId The id of the product to bid on
    /// - Parameter auctionId The auction to add the bid to
    /// - Parameter amount The amount to bid
    /// - Parameter createThread Whether a thread should be created as part of the bid. Generaly true but set to false in certain scenarios, such as buy now.
    /// - Returns: An observable with the newly created bid
    func createBid(productId: UUID, auctionId: UUID, amount: PriceInput, createThread: Bool) -> Observable<Bid>

    /// Create a counter bid in a given auction for an amount
    ///
    /// - Parameter productId The id of the product to counter on
    /// - Parameter auctionId The auction to add the counter bid to
    /// - Parameter amount The amount to bid
    /// - Parameter buyerId The id of the buyer of the item
    /// - Returns: An observable with the newly created bid
    func createCounterBid(productId: UUID, auctionId: UUID, amount: PriceInput, buyerId: UUID) -> Observable<Bid>

    /// Accepts a 'new' bid
    ///
    /// - Parameter id The id of the bid to accept
    /// - Returns: An observable with the updated bid
    func acceptBid(id: UUID) -> Observable<Bid>

    /// Rejects a 'new' bid
    ///
    /// - Parameter id The id of the bid to reject
    /// - Returns: An observable with the updated bid
    func rejectBid(id: UUID) -> Observable<Bid>

    /// Withdraws a 'new' bid
    ///
    /// - Parameter id The id of the bid to withdraw
    /// - Returns: An observable with the updated bid
    func withdrawBid(id: UUID) -> Observable<UUID>
}
