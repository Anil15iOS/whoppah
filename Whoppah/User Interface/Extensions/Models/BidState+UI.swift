//
//  BidState+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 09/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

extension GraphQL.BidState {
    func isApproved() -> Bool {
        switch self {
        case .accepted, .processing, .completed:
            return true
        default:
            return false
        }
    }

    var title: String {
        switch self {
        case .accepted:
            return R.string.localizable.bidStateAccepted()
        case .rejected:
            return R.string.localizable.bidStateRejected()
        case .processing:
            return R.string.localizable.bidStateProcessing()
        case .canceled:
            return R.string.localizable.bidStateCancelled()
        case .new:
            return R.string.localizable.bidStateNew()
        case .expired:
            return R.string.localizable.bidStateExpired()
        case .completed:
            return R.string.localizable.bidStateCompleted()
        case let .__unknown(value):
            return value
        }
    }
}
