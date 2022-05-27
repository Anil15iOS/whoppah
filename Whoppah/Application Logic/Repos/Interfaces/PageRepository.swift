//
//  PageRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 26/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol PageRepository {
    var blocks: Observable<[GraphQL.GetPageQuery.Data.PageByKey.Block]> { get }
    func load(slug: String)
}
