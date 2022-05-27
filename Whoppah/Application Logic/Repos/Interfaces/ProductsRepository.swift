//
//  LegacyProductsRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 12/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol LegacyProductsRepository: AdListItemRepository {
    // Load products
    func load(id: UUID, auctionState: GraphQL.AuctionState?, productState: GraphQL.ProductState?)
    func loadMore() -> Bool

    // Raw data (if needed)
    var data: Observable<GraphQL.ProductsQuery.Data> { get }
}

struct ProductsRepoUpdater: ListUpdater {
    let items: [AdViewModel]
    let repo: LegacyProductsRepository
    init(items: [AdViewModel], repo: LegacyProductsRepository) {
        self.items = items
        self.repo = repo
    }

    func apply() {
        repo.applyItems(list: items)
    }
}
