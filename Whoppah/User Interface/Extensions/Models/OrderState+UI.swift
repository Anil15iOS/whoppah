//
//  OrderState+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 14/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

extension GraphQL.OrderState {
    var title: String {
        switch self {
        case .new:
            return R.string.localizable.orderStateNew()
        case .accepted:
            return R.string.localizable.orderStateAccepted()
        case .canceled:
            return R.string.localizable.orderStateCanceled()
        case .expired:
            return R.string.localizable.orderStateExpired()
        case .completed:
            return R.string.localizable.orderStateCompleted()
        case .disputed:
            return R.string.localizable.orderStateDisputed()
        case .shipped:
            return R.string.localizable.orderStateShipped()
        case .delivered:
            return ""
        case let .__unknown(value):
            return value
        }
    }
}
