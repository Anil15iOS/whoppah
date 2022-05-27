//
//  ADsService.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/15/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import WhoppahDataStore
import Resolver

final class ADsServiceImpl: ADsService {
    private var viewMap = Set<UUID>()
    
    @Injected private var inAppNotifier: InAppNotifier
    @Injected private var apollo: ApolloService

    private func withdrawAd(id: UUID, reason: GraphQL.ProductWithdrawReason?) -> Observable<Void> {
        apollo.apply(mutation: GraphQL.WithdrawProductMutation(id: id, reason: reason)).map { _ in () }
    }

    func viewAd(id: UUID) -> Observable<Void> {
        guard !viewMap.contains(id) else { return Observable.just(()) }
        viewMap.insert(id)
        let query = GraphQL.ProductQuery(id: id, playlist: .hls)
        return apollo.apply(mutation: GraphQL.TrackEventMutation(entity: .product, id: id, event: .view),
                                     query: query,
                                     storeTransaction: { (_, cachedQuery: inout GraphQL.ProductQuery.Data) in
                                         cachedQuery.product?.viewCount += 1
        }).map { _ in () }
    }

    func canWithdrawAd(state: GraphQL.ProductState) -> Bool {
        state == .accepted
    }

    func deleteAd(id: UUID,
                  state _: GraphQL.ProductState,
                  reason: GraphQL.ProductWithdrawReason?) -> Observable<Void> {
        withdrawAd(id: id, reason: reason).map { [weak self] _ in
            self?.inAppNotifier.notify(.adDeleted, userInfo: ["id": id])
            return ()
        }
    }

    func publishAd(id: UUID) -> Observable<GraphQL.ProductState?> {
        apollo.apply(mutation: GraphQL.PublishProductMutation(id: id)).map { res in res.data?.publishProduct.state }
    }

    func repostAd(id: UUID) -> Observable<GraphQL.ProductState?> {
        return publishAd(id: id)
    }

    // MARK: - Report

    func reportItem(itemId: UUID, reason: GraphQL.AbuseReportReason, comment: String) -> Observable<Void> {
        let input = GraphQL.AbuseReportInput(id: itemId, type: .product, reason: reason, description: comment)
        return apollo.apply(mutation: GraphQL.CreateAbuseReportMutation(input: input)).map { _ in () }
    }
}
