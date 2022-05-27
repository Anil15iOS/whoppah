//
//  HomeRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 24/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol HomeRepository {
    var categoryRepo: CategoryRepository { get }
    var moreItemRepo: LegacySearchRepository { get }

    var homeBlock: Observable<GraphQL.GetPageQuery.Data?> { get }
    func loadHomeblock()
}
