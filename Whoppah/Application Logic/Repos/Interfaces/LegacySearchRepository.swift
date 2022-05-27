//
//  SearchRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 13/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol LegacySearchRepository: AdListItemRepository {
    var data: Observable<GraphQL.SearchQuery.Data> { get }
    var suggestionData: Observable<GraphQL.QuerrySuggestionsQuery.Data> { get }

    // Loading
    func load(query: String?, filter: GraphQL.SearchFilterInput?, sort: GraphQL.SearchSort?, ordering: GraphQL.Ordering?)
    func loadMore() -> Bool
    func loadSuggestions(query: String?)
}

struct SearchRepoUpdater: ListUpdater {
    let items: [AdViewModel]
    let repo: LegacySearchRepository
    init(items: [AdViewModel], repo: LegacySearchRepository) {
        self.items = items
        self.repo = repo
    }

    func apply() {
        repo.applyItems(list: items)
    }
}
