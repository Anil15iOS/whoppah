//
//  FavoritesRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxCocoa
import RxSwift
import Resolver
import WhoppahCore
import WhoppahDataStore

class FavoritesRepositoryImpl: FavoritesRepository {
    var items: Driver<Swift.Result<[AdViewModel], Error>> {
        _items.asDriver(onErrorJustReturn: .success([]))
    }

    var _items = BehaviorSubject<Swift.Result<[AdViewModel], Error>>(value: .success([]))

    var itemList = [AdViewModel]()
    private var favoritesWatcher: GraphQLQueryWatcher<GraphQL.GetMerchantFavoritesQuery>?

    private var recommendedItemsWatcher: GraphQLQueryWatcher<GraphQL.RecommendedProductsQuery>?
    private var recommendedItemsSubject = BehaviorSubject<Swift.Result<[AdViewModel], Error>>(value: .success([]))
    var recommendedItems: Driver<Swift.Result<[AdViewModel], Error>> {
        recommendedItemsSubject.asDriver(onErrorJustReturn: .success([]))
    }

    var pager = PagedView(pageSize: 25)

    private var bag = DisposeBag()
    
    @Injected fileprivate var apollo: ApolloService

    init() {}
}

// MARK: Favorites

extension FavoritesRepositoryImpl {
    func load(id: UUID) {
        bag = DisposeBag()
        pager.resetToFirstPage()
        itemList.removeAll()
        loadItems(id: id)
    }

    private func loadItems(id: UUID) {
        if let watcher = favoritesWatcher {
            return watcher.refetch()
        } else {
            
            let query = GraphQL.GetMerchantFavoritesQuery(id: id, playlist: .hls)
            favoritesWatcher = apollo.watch(query: query, cache: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case let .success(data):
                    guard let self = self, let favorites = data.merchant?.favorites else { return }

                    // Pagination is not yet supported
                    self.pager.onListFetched(page: 1, total: 1, limit: favorites.count)
                    self.itemList = []
                    favorites.forEach { result in
                        if let product = result.item.asProduct {
                            self.itemList.append(AdViewModel(product: product as WhoppahCore.Product))
                        }
                    }
                    self._items.onNext(.success(self.itemList))
                case let .failure(error):
                    self?._items.onNext(.failure(error))
                }
            }
        }
    }

    func getViewModel(atIndex index: Int) -> AdViewModel? {
        guard index < itemList.count else { return nil }
        return itemList[index]
    }

    func numitems() -> Int {
        itemList.count
    }

    func onAdLiked(viewModel: AdViewModel) {
        itemList.append(viewModel)
        _items.onNext(.success(itemList))
    }

    func onAdUnliked(viewModel: AdViewModel) {
        itemList.removeAll(where: { $0.id == viewModel.product.id })
        _items.onNext(.success(itemList))
    }
}

// MARK: Recommended items

extension FavoritesRepositoryImpl {
    func loadRecommendedItems(id: UUID) {
        if let watcher = recommendedItemsWatcher {
            return watcher.refetch()
        } else {
            recommendedItemsWatcher = apollo.watch(query: GraphQL.RecommendedProductsQuery(user: id), cache: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case let .success(data):
                    guard let self = self else { return }
                    let items = data.recommendedProducts.compactMap { AdViewModel(product: $0) }
                    self.recommendedItemsSubject.onNext(.success(items))
                case let .failure(error):
                    self?.recommendedItemsSubject.onNext(.failure(error))
                }
            }
        }
    }
}
