//
//  ProductState+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 14/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

extension GraphQL.ProductState {
    var title: String {
        switch self {
        case .draft:
            return R.string.localizable.productStateDraft()
        case .accepted:
            return R.string.localizable.productStateAccepted()
        case .rejected:
            return R.string.localizable.productStateRejected()
        case .banned:
            return R.string.localizable.productStateBanned()
        case .curation:
            return R.string.localizable.productStateCuration()
        case .canceled:
            return R.string.localizable.productStateCanceled()
        case .updated, .archive:
            return ""
        case let .__unknown(value):
            return value
        }
    }
}
