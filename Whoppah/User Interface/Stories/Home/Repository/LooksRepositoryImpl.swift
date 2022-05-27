//
//  LooksRepositoryImpl.swift
//  Whoppah
//
//  Created by Eddie Long on 25/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore

class LooksRepositoryImpl: LooksRepository {
    var lookSections: Observable<[LookSection]> {
        _lookSections.asObservable()
    }

    private var _lookSections = BehaviorSubject<[LookSection]>(value: [])
    private let bag = DisposeBag()

    private let pageRepo: PageRepository
    
    init(pageRepo: PageRepository) {
        self.pageRepo = pageRepo

        pageRepo.blocks.filter { !$0.isEmpty }.subscribe(onNext: { [weak self] blocks in
            guard let self = self else { return }
            var sections = [LookSection]()
            for block in blocks {
                if let attributeBlock = block.asAttributeBlock, !attributeBlock.attributes.isEmpty {
                    let attributes = attributeBlock.attributes.map { AttributeBlockSectionViewModel(datasource: $0, showTitle: false) }
                    sections.append(LookSection(looks: attributes))
                }
            }
            self._lookSections.onNext(sections)
            self._lookSections.onCompleted()
        }, onError: { [weak self] error in
            self?._lookSections.onError(error)
        }).disposed(by: bag)
    }

    func loadLooks() {
        pageRepo.load(slug: "shop-the-look")
    }
}
