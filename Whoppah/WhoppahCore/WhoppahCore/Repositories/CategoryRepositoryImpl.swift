//
//  CategoryRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 29/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import Resolver
import RxCocoa
import RxSwift
import WhoppahDataStore

class CategoryRepositoryImpl: CategoryRepository {
    @Injected private var apollo: ApolloService
    private var categoryWatcher: GraphQLQueryWatcher<GraphQL.GetCategoriesQuery>?
    var categories: Driver<Swift.Result<GraphQL.GetCategoriesQuery.Data?, Error>> {
        _categories.asDriver(onErrorJustReturn: .success(nil))
    }

    private var _categories = BehaviorSubject<Swift.Result<GraphQL.GetCategoriesQuery.Data?, Error>>(value: .success(nil))
}

extension CategoryRepositoryImpl {
    func load(level: Int) {
        if let watcher = categoryWatcher {
            watcher.refetch()
        } else {
            var filters = [GraphQL.CategoryFilter]()
            let category = GraphQL.CategoryFilter(key: .level, value: String(level))
            filters.append(category)
            categoryWatcher = apollo.watch(query: GraphQL.GetCategoriesQuery(filters: filters), cache: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case let .success(block):
                    self?._categories.onNext(.success(block))
                case let .failure(error):
                    self?._categories.onNext(.failure(error))
                }
            }
        }
    }
}
