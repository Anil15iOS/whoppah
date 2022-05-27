//
//  PageRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 26/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class PageRepositoryImpl: PageRepository {
    var blocks: Observable<[GraphQL.GetPageQuery.Data.PageByKey.Block]> {
        _blocks.asObservable()
    }

    private var _blocks = BehaviorSubject<[GraphQL.GetPageQuery.Data.PageByKey.Block]>(value: [])
    private var bag = DisposeBag()
    
    @Injected private var apollo: ApolloService

    func load(slug: String) {
        bag = DisposeBag()
        let query = GraphQL.GetPageQuery(key: .slug, value: slug)
        apollo.fetch(query: query).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            if let blocks = result.data?.pageByKey?.blocks {
                self._blocks.onNext(blocks)
            } else {
                self._blocks.onNext([])
            }
            self._blocks.onCompleted()
        }, onError: { [weak self] error in
            self?._blocks.onError(error)
        }).disposed(by: bag)
    }
}
