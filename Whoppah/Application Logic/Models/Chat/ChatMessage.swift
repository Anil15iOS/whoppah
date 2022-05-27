//
//  ChatMessage.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import MessengerKit
import WhoppahCore
import WhoppahDataStore

// MARK: - MSGMessage

class ChatMessage: Hashable {
    public enum ContentType: Hashable {
        case text(payload: TextPayload)
        case askTrackingID(payload: AskTrackingPayload)
        case didProductReceived(payload: ProductReceivedPayload)
        case bid(payload: BidPayload)
        case askPay(payload: AskPayPayload)
        case paymentCompletedBuyer(payload: PaymentCompletedBuyerPayload)
        case paymentCompletedSeller(payload: PaymentCompletedSellerPayload)
        case paymentCompletedMerchant(payload: PaymentCompletedMerchantPayload)
        case trackingID(payload: TrackIDPayload)
        case orderIncomplete(payload: OrderIncompletePayload)
        case media(payload: MediaPayload)
        case firstReply(payload: NSAttributedString)
        case itemReceived(payload: AutoreplyPayload)
    }

    let id: Int
    let original: UUID
    let type: ContentType
    let user: ChatUser
    let created: DateTime
    let updated: DateTime?
    let isUnread: Bool
    // Store the hash so it can be used in various places - as this object is immutable this is ok
    lazy var hash: Int = 0

    lazy var msgMessage = MSGMessage(id: id, body: .custom(self), user: user, sentAt: created.date)

    fileprivate init(id: Int,
                     type: ContentType,
                     created: DateTime,
                     updated: DateTime?,
                     unread: Bool,
                     user: ChatUser,
                     original: UUID) {
        self.id = id
        self.original = original
        self.user = user
        self.created = created
        self.updated = updated
        self.type = type
        isUnread = unread
        var hasher = Hasher()
        hash(into: &hasher)
        hash = hasher.finalize()
    }

    func sortDate() -> Date {
        updated?.date ?? created.date
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(isUnread.hashValue)
        hasher.combine(type.hashValue)
    }

    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.type == rhs.type
    }
}

extension ChatMessageFactory {
    func createMessage(_ message: GraphMessage, user: ChatUser, type: ChatMessage.ContentType) -> ChatMessage {
        let newId = generateMessageId(message.id)
        return ChatMessage(id: newId,
                           type: type,
                           created: message.created,
                           updated: message.updated,
                           unread: message.unread,
                           user: user,
                           original: message.id)
    }

    func createTextMessage(_ message: NewMessage, user: ChatUser) -> ChatMessage {
        let newId = generateMessageId(message.id)
        return ChatMessage(id: newId,
                           type: .text(payload: TextPayload(messageId: message.id, text: message.body ?? "")),
                           created: message.created,
                           updated: message.updated,
                           unread: message.unread,
                           user: user,
                           original: message.id)
    }

    func createManualMessage(id: UUID, user: ChatUser, type: ChatMessage.ContentType) -> ChatMessage {
        let newId = generateMessageId(id)
        return ChatMessage(id: newId,
                           type: type,
                           created: DateTime(date: Date()),
                           updated: DateTime(date: Date()),
                           unread: true,
                           user: user,
                           original: id)
    }
}
