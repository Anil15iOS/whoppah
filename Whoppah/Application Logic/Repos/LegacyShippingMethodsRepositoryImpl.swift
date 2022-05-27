//
//  LegacyShippingMethodsRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 12/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class LegacyShippingMethodsRepositoryImpl: LegacyShippingMethodsRepository {
    @LazyInjected private var apollo: ApolloService

    func load(origin: String?, destination: String?) -> Observable<[GraphQL.GetShippingMethodsQuery.Data.ShippingMethod]> {
        apollo.fetch(query: GraphQL.GetShippingMethodsQuery(origin: origin, destination: destination))
            .map { $0.data?.shippingMethods ?? [] }
    }
}
