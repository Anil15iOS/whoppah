//
//  AuctionState+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 14/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

extension GraphQL.AuctionState {
    var title: String {
        switch self {
        case .draft:
            return R.string.localizable.auctionStateDraft()
        case .published:
            return R.string.localizable.auctionStatePublished()
        case .reserved:
            return R.string.localizable.auctionStateReserved()
        case .canceled:
            return R.string.localizable.auctionStateCanceled()
        case .banned:
            return R.string.localizable.auctionStateBanned()
        case .expired:
            return R.string.localizable.auctionStateExpired()
        case .completed:
            return R.string.localizable.auctionStateCompleted()
        case let .__unknown(value):
            return value
        }
    }
}
