//
//  BidRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 12/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore
import Resolver

class BidRepositoryImpl: BidRepository {
    @Injected private var apollo: ApolloService
    
    init() {}

    func get(_ id: UUID) -> Observable<GraphQL.GetBidQuery.Data.Bid> {
        apollo.fetch(query: GraphQL.GetBidQuery(id: id)).compactMap { $0.data?.bid }
    }
}
