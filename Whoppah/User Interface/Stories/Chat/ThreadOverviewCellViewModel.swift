//
//  ThreadOverviewCellViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 12/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore

class ThreadOverviewCellViewModel {
    // MARK: Public

    struct Outputs {
        var productClick: Observable<GraphQL.GetThreadsQuery.Data.Thread.Item> {
            _productClick.asObservable()
        }

        fileprivate let _productClick = PublishSubject<GraphQL.GetThreadsQuery.Data.Thread.Item>()
    }

    let outputs = Outputs()
    private(set) var avatar: Character = "-"

    // MARK: Private

    private var thread: GraphQL.GetThreadsQuery.Data.Thread.Item
    private let unreadCount = BehaviorRelay<Int>(value: 0)
    private static let formatter = DateFormatter()
    private static let timeFormatter = DateFormatter()

    private(set) var lastMessageText: String? = ""
    
    @Injected private var inAppNotifier: InAppNotifier
    @Injected private var user: WhoppahCore.LegacyUserService
    
    init(thread: GraphQL.GetThreadsQuery.Data.Thread.Item) {
        self.thread = thread
        unreadCount.accept(thread.unreadCount)
        ThreadOverviewCellViewModel.formatter.dateStyle = .short
        ThreadOverviewCellViewModel.formatter.doesRelativeDateFormatting = true
        ThreadOverviewCellViewModel.timeFormatter.timeStyle = .short
        ThreadOverviewCellViewModel.timeFormatter.dateStyle = .none

        let myMerchantId = user.current?.mainMerchant.id
        for message in thread.messages {
            let merchant = message.merchant
            if username.isEmpty, merchant.id != myMerchantId {
                username = getMerchantDisplayName(type: merchant.type,
                                                  businessName: merchant.businessName,
                                                  name: merchant.name,
                                                  hideBusinessName: false)
                avatarURL = URL(string: merchant.avatar?.url ?? "")
            }
            
            isBusiness = merchant.type == .business

            if lastMessageText == nil, let body = message.body, !body.isEmpty {
                lastMessageText = body
            }

            if lastMessageText == nil, let bid = message.item?.asBid {
                let price = PriceInput(currency: bid.amount.currency, amount: bid.amount.amount)
                lastMessageText = R.string.localizable.chat_thread_last_bid(price.formattedPrice())
            }

            if lastMessageText == nil, thread.item.asProduct != nil {
                lastMessageText = R.string.localizable.threadCellWhoppahMessage()
            }

            // If we have what we need then bail out
            if lastMessageText != nil, !username.isEmpty { break }
        }

        // If no messages from another user then we just search through subscribers and find the first that isn't the user
        if username.isEmpty {
            if let merchant = thread.subscribers.filter({ $0.merchant.id != myMerchantId }).first?.merchant {
                username = getMerchantDisplayName(type: merchant.type,
                                                  businessName: merchant.businessName,
                                                  name: merchant.name,
                                                  hideBusinessName: false)
                avatarURL = URL(string: merchant.avatar?.url ?? "")
                isBusiness = merchant.type == .business
            }
        }
        avatar = username.first ?? "-"

        NotificationCenter.default.addObserver(self, selector: #selector(chatMessagesRead(_:)), name: InAppNotifier.NotificationName.chatMessagesRead.name, object: nil)
    }

    private(set) var avatarURL: URL?
    private(set) var username: String = ""
    private(set) var isBusiness: Bool = false

    var threadImage: URL? {
        if let merchant = thread.item.asMerchant {
            guard let urlText = merchant.avatar?.url else {
                return nil
            }
            return URL(string: urlText)
        } else if let item = thread.item.asProduct {
            guard let urlText = item.thumbnails.first?.url else {
                return nil
            }
            return URL(string: urlText)
        }
        return nil
    }

    var date: String {
        let datetime = thread.updated ?? thread.created
        guard !Calendar.current.isDateInToday(datetime.date) else {
            return ThreadOverviewCellViewModel.timeFormatter.string(from: datetime.date)
        }

        return "\(ThreadOverviewCellViewModel.formatter.string(from: datetime.date))"
    }

    var numberOfUnreadMessages: Observable<Int> { unreadCount.asObservable() }

    func onClicked() {
        outputs._productClick.onNext(thread)
    }

    @objc private func chatMessagesRead(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let threadId = userInfo["thread_id"] as? UUID else { return }
        guard threadId == thread.id else { return }
        thread.unreadCount = 0
        unreadCount.accept(0)
    }
}
