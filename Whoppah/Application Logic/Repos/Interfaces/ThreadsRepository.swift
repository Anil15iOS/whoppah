//
//  ThreadsRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 27/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore

protocol ThreadsRepository {
    var pager: PagedView { get }
    var threads: Driver<Result<[ThreadOverviewCellViewModel], Error>> { get }

    func load()
    func loadMore() -> Bool
    func clear()

    // Datasource
    func getViewModel(atIndex index: Int) -> ThreadOverviewCellViewModel?
    func numitems() -> Int

    func applyItems(list: [ThreadOverviewCellViewModel])
}

struct ThreadNotificationRepoUpdater: ListUpdater {
    let items: [ThreadOverviewCellViewModel]
    let repo: ThreadsRepository
    init(items: [ThreadOverviewCellViewModel], repo: ThreadsRepository) {
        self.items = items
        self.repo = repo
    }

    func apply() {
        repo.applyItems(list: items)
    }
}
