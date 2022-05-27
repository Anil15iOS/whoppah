//
//  UserDefaultsConfig.swift
//  Whoppah
//
//  Created by Eddie Long on 07/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

struct UserDefaultsConfig {
    @UserDefault("has_seen_onboarding", defaultValue: false)
    static var hasSeenOnboarding: Bool

    @UserDefault("shown_search_intro", defaultValue: false)
    static var hasShownSearchIntro: Bool

    @UserDefault("seller_bid_tip_message_id", defaultValue: nil)
    static var sellerBotMessageId: String?

    @UserDefault("buyer_bid_tip_message_id", defaultValue: nil)
    static var buyerBotMessageId: String?

    @UserDefault("search_alert_tip_count", defaultValue: 0)
    private static var searchAlertTipShowCount: Int
    
    static var showSearchAlertTip: Bool {
        guard !shownSaveAlertTipSession else { return false }
        return searchAlertTipShowCount < 2
    }
    
    static var searchAlertTipShown: Bool = false {
        didSet {
            guard searchAlertTipShown else { return }
            shownSaveAlertTipSession = true
            searchAlertTipShowCount += 1
        }
    }
    private static var shownSaveAlertTipSession = false

    // Used to record the number of bids placed up to a maximum
    private static let maxBidsToRecord = 2
    @UserDefault("bids_placed_list", defaultValue: "")
    private static var bidsPlacedList: String

    private static var placedBids: [UUID] {
        bidsPlacedList.components(separatedBy: ",").compactMap { UUID(uuidString: $0) }
    }

    static func willShowNewBidText(_ id: UUID) -> Bool {
        placedBids.contains(id)
    }

    static func onBidPlaced(_ id: UUID) {
        var currentBids = placedBids
        guard currentBids.count < maxBidsToRecord, !currentBids.contains(id) else { return }
        currentBids.append(id)
        bidsPlacedList = currentBids.map { $0.uuidString }.joined(separator: ",")
    }
}
