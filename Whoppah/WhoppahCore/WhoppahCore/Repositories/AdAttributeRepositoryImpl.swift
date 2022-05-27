//
//  BrandAttributeRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import Resolver
import RxSwift
import WhoppahDataStore

class AdAttributeRepositoryImpl: AdAttributeRepository {
    @Injected private var apollo: ApolloService
    private var bag = DisposeBag()
    let type: AttributeType

    private var cachedResult: [AdAttribute]?

    init(type: AttributeType) {
        self.type = type
    }

    func loadAttributes<T>() -> Observable<[T]> {
        bag = DisposeBag()
        return Observable.create { (observer) -> Disposable in
            if let cache = self.cachedResult {
                observer.onNext(cache.compactMap { $0 as? T })
                observer.onCompleted()
                return Disposables.create()
            }

            self.apollo.fetch(query: GraphQL.GetAttributesQuery(key: .type, value: self.type.rawValue)).subscribe(onNext: { [weak self] result in

                guard let data = result.data, let self = self else { observer.onCompleted(); return }
                switch self.type {
                case .artists:
                    let attributes = data.attributesByKey.compactMap { $0.asArtist as? T }
                    self.cachedResult = attributes.compactMap { $0 as? AdAttribute }
                    observer.onNext(attributes)
                case .brands:
                    let attributes = data.attributesByKey.compactMap { $0.asBrand as? T }
                    self.cachedResult = attributes.compactMap { $0 as? AdAttribute }
                    observer.onNext(attributes)
                case .colors:
                    let attributes = data.attributesByKey.compactMap { $0.asColor as? T }
                    self.cachedResult = attributes.compactMap { $0 as? AdAttribute }
                    observer.onNext(attributes)
                case .designers:
                    let attributes = data.attributesByKey.compactMap { $0.asDesigner as? T }
                    self.cachedResult = attributes.compactMap { $0 as? AdAttribute }
                    observer.onNext(attributes)
                case .styles:
                    let attributes = data.attributesByKey.compactMap { $0.asStyle as? T }
                    self.cachedResult = attributes.compactMap { $0 as? AdAttribute }
                    observer.onNext(attributes)
                case .materials:
                    let attributes = data.attributesByKey.compactMap { $0.asMaterial as? T }
                    self.cachedResult = attributes.compactMap { $0 as? AdAttribute }
                    observer.onNext(attributes)
                }
                observer.onCompleted()
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: self.bag)
            return Disposables.create()
        }
    }
}
