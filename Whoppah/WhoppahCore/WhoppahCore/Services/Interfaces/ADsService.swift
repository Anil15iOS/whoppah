//
//  AdsService.swift
//  Whoppah
//
//  Created by Eddie Long on 24/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahDataStore

public protocol ADsService {
    /// Delete an ad from the CMS
    ///
    /// - Parameter id the ad to delete
    /// - Parameter state the state of the ad
    /// - Parameter reason the optional withdrawal reason
    /// - Returns: An observable, with no value
    func deleteAd(id: UUID, state: GraphQL.ProductState, reason: GraphQL.ProductWithdrawReason?) -> Observable<Void>

    /// Repost an ad that has expired
    ///
    /// - Parameter id the ad to repost
    /// - Returns: An observable with an optional product state
    func repostAd(id: UUID) -> Observable<GraphQL.ProductState?>

    /// Publish an ad, should be in draft state
    ///
    /// - Parameter id the ad to publish
    /// - Returns: An observable with an optional product state
    func publishAd(id: UUID) -> Observable<GraphQL.ProductState?>

    /// Log a view of the ad
    ///
    /// - Parameter id the ad to publish
    /// - Returns: An observable, with no value
    func viewAd(id: UUID) -> Observable<Void>

    /// Whether an ad can be withdrawn
    ///
    /// - Parameter state the state of the ad to test
    /// - Returns: True if the ad can be withdrawn, false otherwise
    func canWithdrawAd(state: GraphQL.ProductState) -> Bool

    /// Report a product
    ///
    /// - Parameter itemId the ad to report
    /// - Parameter reason the abuse report reason
    /// - Parameter comment a user entered abuse report text
    /// - Returns: An observable, with no value
    func reportItem(itemId: UUID, reason: GraphQL.AbuseReportReason, comment: String) -> Observable<Void>
}
