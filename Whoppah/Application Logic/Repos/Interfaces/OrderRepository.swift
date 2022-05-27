//
//  OrderRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 09/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol OrderRepository {
    init(state: [GraphQL.OrderState])

    func load(merchantId: UUID)
    func loadMore() -> Bool

    var pager: PagedView { get }
    var items: Observable<Result<[GraphQL.OrdersQuery.Data.Order.Item], Error>> { get }

    // Datasource
    func getViewModel(atIndex index: Int) -> GraphQL.OrdersQuery.Data.Order.Item?
    func numitems() -> Int

    func applyItems(list: [GraphQL.OrdersQuery.Data.Order.Item])
}
