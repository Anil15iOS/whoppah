//
//  AdListItemRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 06/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

protocol AdListItemRepository {
    var pager: PagedView { get }
    var items: Observable<Result<(totalCount: Int, elements: [AdViewModel]), Error>> { get }

    // Datasource
    func getViewModel(atIndex index: Int) -> AdViewModel?
    func numitems() -> Int

    func applyItems(list: [AdViewModel])
}
