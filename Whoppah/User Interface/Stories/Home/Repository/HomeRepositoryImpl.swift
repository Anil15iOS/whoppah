//
//  HomeRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 24/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class HomeRepositoryImpl: HomeRepository {
    @Injected fileprivate var apolloService: ApolloService
    
    let moreItemRepo: LegacySearchRepository
    let categoryRepo: CategoryRepository

    var homeBlock: Observable<GraphQL.GetPageQuery.Data?> {
        _homeBlock.asObservable()
    }

    private var _homeBlock = PublishSubject<GraphQL.GetPageQuery.Data?>()
    private var bag = DisposeBag()

    init(searchRepository: LegacySearchRepository,
         categoryRepository: CategoryRepository) {
        moreItemRepo = searchRepository
        categoryRepo = categoryRepository
    }
}

extension HomeRepositoryImpl {
    func loadHomeblock() {
        bag = DisposeBag()
        apolloService
            .fetch(query: GraphQL.GetPageQuery(key: .slug, value: "home", playlist: .hls))
            .subscribe(onNext: { [weak self] result in
                self?._homeBlock.onNext(result.data)
            }, onError: { [weak self] error in
                self?._homeBlock.onError(error)
            }).disposed(by: bag)
    }
}
