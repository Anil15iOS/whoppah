//
//  WPChatStyle.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/19/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import MessengerKit
import WhoppahCore

struct WPChatStyle: MSGMessengerStyle {
    var inputTextViewBackgroundColor = UIColor.white

    var collectionView: MSGCollectionView.Type = WPChatCollectionView.self

    var inputView: MSGInputView.Type = WPInputView.self

    var headerHeight: CGFloat = 0

    var footerHeight: CGFloat = 30

    var backgroundColor: UIColor = .white

    var inputViewBackgroundColor: UIColor = UIColor(hexString: "#F3F4F6")

    var font: UIFont = UIFont.systemFont(ofSize: 17)

    var inputFont: UIFont = UIFont.bodyText

    var inputPlaceholder: String = R.string.localizable.chat_thread_type_message_placeholder()

    var inputTextColor: UIColor = .black

    var inputPlaceholderTextColor: UIColor = .steel

    var outgoingTextColor: UIColor = .black

    var outgoingLinkColor: UIColor = .space

    var incomingTextColor: UIColor = .black

    var incomingLinkColor: UIColor = UIColor(hexString: "#193A6F")

    func size(for message: MSGMessage, in collectionView: UICollectionView) -> CGSize {
        var size: CGSize = .zero

        switch message.body {
        case let .text(body):
            size = getTextBubble(body, in: collectionView)
        case .emoji:
            size = CGSize(width: collectionView.bounds.width, height: 60)
        case let .custom(body):
            guard let message = body as? ChatMessage else { return .zero }
            switch message.type {
            case let .text(payload):
                size = getTextBubble(payload.text, in: collectionView)
            case let .askPay(payload):
                size = WPAskPayCell.size(forSize: collectionView.bounds.size,
                                         payload: payload)
            case let .paymentCompletedSeller(payload):
                let isExpanded = orderDialogExpanded.getValue(forKey: payload.orderId)
                size = WPPaymentCompletedCell.size(forSize: collectionView.bounds.size, payload: payload, expanded: isExpanded)
            case let .paymentCompletedMerchant(payload):
                let isExpanded = orderDialogExpanded.getValue(forKey: payload.orderId)
                size = WPPaymentCompletedCell.size(forSize: collectionView.bounds.size, payload: payload, expanded: isExpanded)
            case let .paymentCompletedBuyer(payload):
                let isExpanded = orderDialogExpanded.getValue(forKey: payload.orderId)
                size = WPPaymentCompletedCell.size(forSize: collectionView.bounds.size, payload: payload, expanded: isExpanded)
            case .askTrackingID:
                size = CGSize(width: collectionView.bounds.width, height: 40.0)
            case let .trackingID(payload):
                switch (payload.trackingID, payload.returnID) {
                case (.some, .some):
                    size = CGSize(width: collectionView.bounds.width, height: 130.0)
                case (.some, nil), (nil, .some):
                    size = CGSize(width: collectionView.bounds.width, height: 90.0)
                default:
                    size = CGSize(width: collectionView.bounds.width, height: 90.0)
                }
            case let .didProductReceived(payload):
                let showDialog = receiveDialogVisibility.getValue(forKey: payload.orderID)
                size = WPDidReceiveProductCell.size(forSize: collectionView.bounds.size, payload: payload, showDialog: showDialog)
            case let .bid(payload):
                if message.user.isSender {
                    let isExpanded = outgoingBidDialogExpanded.getValue(forKey: payload.id)
                    size = WPOutgoingBidCell.size(forSize: collectionView.bounds.size, payload: payload, isExpanded: isExpanded)
                } else {
                    size = WPIncomingBidCell.size(forSize: collectionView.bounds.size, payload: payload)
                }
            case .itemReceived:
                size = CGSize(width: collectionView.bounds.width, height: 156)
            case .firstReply(let payload):
                size = getAutoreplyTextHeight(payload.string, in: collectionView)
            case let .media(payload):
                size = WPMediaCell.size(forSize: collectionView.bounds.size, payload: payload)
            case let .orderIncomplete(payload):
                let isExpanded = orderIncompleteDialogExpanded.getValue(forKey: payload.orderID)
                size = WPOrderIncompleteCell.size(forSize: collectionView.bounds.size, payload: payload, isExpanded: isExpanded)
            }
        default:
            size = CGSize(width: collectionView.bounds.width, height: 175)
        }

        return size
    }

    private func getTextBubble(_ body: String, in collectionView: UICollectionView) -> CGSize {
        let bubble = WPTextCell()
        bubble.message = MSGMessage(id: 1,
                                    body: MSGMessageBody.text(body),
                                    user: ChatUser(id: UUID(), displayName: "name", avatar: UIImage(), role: .subscriber),
                                    sentAt: Date())
        bubble.style = self
        let bubbleSize = bubble.calculatedSize(in: CGSize(width: collectionView.bounds.width, height: .infinity))
        return CGSize(width: collectionView.bounds.width, height: bubbleSize.height)
    }
    
    private func getAutoreplyTextHeight(_ body: String, in collectionView: UICollectionView) -> CGSize {
        let bubble = WPTextCell()
        bubble.message = MSGMessage(id: 1,
                                    body: MSGMessageBody.text(body),
                                    user: ChatUser(id: UUID(), displayName: "name", avatar: UIImage(), role: .subscriber),
                                    sentAt: Date())
        bubble.style = self
        let bubbleSize = bubble.calculatedSize(in: CGSize(width: collectionView.bounds.width - 16, height: .infinity))
        return CGSize(width: collectionView.bounds.width, height: bubbleSize.height)
    }

    // MARK: - Custom Properties

    var outgoingBubbleColor: UIColor = UIColor(hexString: "#E2E2E2")
    var incomingBubbleColor: UIColor = .lightBlue

    var footerFont: UIFont = UIFont.descriptionText
    var footerTextColor: UIColor = .steel
}
