//
//  MyAdsListRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 06/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

protocol MyAdListRepository: AdListItemRepository {
    func load()
    func loadMore() -> Bool

    @discardableResult
    func onAdDeleted(id: UUID) -> Bool
    @discardableResult
    func onAdReposted(id: UUID) -> Bool
    func getAd(id: UUID) -> AdViewModel?
}
