//
//  FavoritesRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 30/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore

protocol FavoritesRepository {
    // Favorites
    var items: Driver<Result<[AdViewModel], Error>> { get }
    func load(id: UUID)
    var pager: PagedView { get }

    // Datasource
    func getViewModel(atIndex index: Int) -> AdViewModel?
    func numitems() -> Int

    // Liking/unliking
    func onAdLiked(viewModel: AdViewModel)
    func onAdUnliked(viewModel: AdViewModel)

    // Recommended items
    var recommendedItems: Driver<Result<[AdViewModel], Error>> { get }
    func loadRecommendedItems(id: UUID)
}
