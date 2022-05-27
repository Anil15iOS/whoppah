//
//  ChatMessageFactory.swift
//  Whoppah
//
//  Created by Eddie Long on 25/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore
import Resolver

private enum GraphMessageData {
    case bid(data: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsBid)
    case product(data: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsProduct)
    case order(data: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder)
    case shipment(data: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsShipment)
    case image(data: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsImage)
    case video(data: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsVideo)
    case other(data: GraphQL.GetMessagesQuery.Data.Message.Item.Item)
}

extension GraphQL.GetMessagesQuery.Data.Message.Item.Item {
    fileprivate var messageData: GraphMessageData {
        if let bid = asBid {
            return .bid(data: bid)
        } else if let order = asOrder {
            return .order(data: order)
        } else if let product = asProduct {
            return .product(data: product)
        } else if let shipment = asShipment {
            return .shipment(data: shipment)
        } else if let image = asImage {
            return .image(data: image)
        } else if let video = asVideo {
            return .video(data: video)
        }
        return .other(data: self)
    }
}

final class ChatMessageFactory {
    private let courierMethodSlug = "courier"
    typealias GraphThread = GraphQL.GetThreadQuery.Data.Thread
    typealias GraphMessage = GraphQL.GetMessagesQuery.Data.Message.Item
    typealias NewMessage = GraphQL.SendMessageMutation.Data.SendMessage
    typealias GraphOrder = GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder
    typealias GraphBid = GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsBid
    typealias GraphShipment = GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsShipment
    typealias GraphImage = GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsImage
    typealias GraphVideo = GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsVideo

    // MSGMessage cannot store UUIDs, only Ints
    // So we map from UUID to Int and use this as a lookup to map back to original
    private var messageMap = [UUID: [Int]]()
    private var highestMessageID: Int = 0
    
    @LazyInjected private var userService: LegacyUserService

    private var merchantId: UUID? { userService.current?.merchantId }

    private let bot = ChatUser(id: UUID(),
                               displayName: "Whoppah",
                               avatar: R.image.whoppah_bot_avatar()!,
                               role: GraphQL.SubscriberRole.bot)

    func getMessageId(_ uuid: UUID, createIfMissing: Bool = true) -> [Int] {
        if let existing = messageMap[uuid] {
            return existing
        }

        if !createIfMissing { return [] }

        generateMessageId(uuid)
        return messageMap[uuid]!
    }

    func removeMessages(forId id: UUID) {
        messageMap.removeValue(forKey: id)
    }

    @discardableResult
    func generateMessageId(_ uuid: UUID) -> Int {
        highestMessageID += 1
        if messageMap.contains(where: { $0.key == uuid }) {
            messageMap[uuid]!.append(highestMessageID)
        } else {
            messageMap[uuid] = [highestMessageID]
        }
        return highestMessageID
    }

    // MARK: Message creation

    private func createBotMessage(_ message: GraphMessage, bid: UUID, text: String) -> ChatMessage {
        createMessage(message, user: bot, type: .text(payload: TextPayload(bid: bid, text: text)))
    }

    private func createAutoreplyBotMessage(_ message: GraphMessage, order: UUID, attributedPayload: NSAttributedString) -> ChatMessage {
        createMessage(message, user: bot, type: .itemReceived(payload: AutoreplyPayload(order: order, attributedPayload: attributedPayload)))
    }
    
    private func createBotMessage(_ message: GraphMessage, order: UUID, text: String) -> ChatMessage {
        createMessage(message, user: bot, type: .text(payload: TextPayload(order: order, text: text)))
    }

    private func createBotMessage(_ message: GraphMessage, shipment: UUID, text: String) -> ChatMessage {
        createMessage(message, user: bot, type: .text(payload: TextPayload(shipment: shipment, text: text)))
    }

    private func createTextMessage(_ message: GraphMessage, user: ChatUser, text: String) -> ChatMessage {
        createMessage(message, user: user, type: .text(payload: TextPayload(messageId: message.id, text: text)))
    }

    private func createMediaMessage(_ message: GraphMessage, user: ChatUser, id: UUID, url: URL, type: MediaPayload.MediaType) -> ChatMessage {
        createMessage(message, user: user, type: .media(payload: MediaPayload(id: id, data: .existing(url: url), type: type)))
    }

    func createBotFirstReplyMessage() -> ChatMessage {
        
        let autoreplyBoldLine1 = R.string.localizable.chatAutoreply1LineBoldText()
        let autoreplyBoldLine2 = R.string.localizable.chatAutoreply2LineBoldText()
        let autoreplyBoldLine3 = R.string.localizable.chatAutoreply3LineBoldText()
        let autoreplyBoldLine4 = R.string.localizable.chatAutoreply4LineBoldText()
        let autoreplyNormalLine1 = R.string.localizable.chatAutoreply1LineNormalText()
        let autoreplyNormalLine2 = R.string.localizable.chatAutoreply2LineNormalText()
        let autoreplyNormalLine3 = R.string.localizable.chatAutoreply3LineNormalText()
        let autoreplyNormalLine4 = R.string.localizable.chatAutoreply4LineNormalText()
        
        let attributedText = NSMutableAttributedString()
            .normal("👍 ")
            .bold(" \(autoreplyBoldLine1) ")
            .normal(autoreplyNormalLine1 + "\n\n")
            .normal("💳 ")
            .bold(" \(autoreplyBoldLine2) ")
            .normal(autoreplyNormalLine2 + "\n\n")
            .normal("🏆 ")
            .bold(" \(autoreplyBoldLine3) ")
            .normal(autoreplyNormalLine3 + "\n\n")
            .normal("📦 ")
            .bold(" \(autoreplyBoldLine4) ")
            .normal(autoreplyNormalLine4)

        return createManualMessage(id: UUID(), user: bot, type: .firstReply(payload: attributedText))
    }
    
    func createMediaMessage(id: UUID,
                            user: ChatUser,
                            mediaId: UUID,
                            mediaData: Data,
                            mediaType: MediaPayload.MediaType) -> ChatMessage {
        createManualMessage(id: id,
                            user: user,
                            type: .media(payload: MediaPayload(id: mediaId, data: .local(data: mediaData), type: mediaType)))
    }
    
    func getMediaId(_ message: GraphMessage) -> UUID? {
        guard let item = message.item else { return nil }
        switch item.messageData {
        case let .image(data):
            guard !data.url.isEmpty else { return nil }
            return data.id
        case let .video(data):
            guard !data.url.isEmpty else { return nil }
            return data.id
        default: return nil
        }
    }

    /**
     Creates a list of messages based off the server 'GraphMessage'
     It creates 1...* messages as there are bot messages amongst other messages that map to a single server message
     */
    func create(message: GraphMessage,
                thread: GraphThread,
                user: ChatUser,
                showsAutoreply: Bool) -> [ChatMessage] {
        var messages = [ChatMessage]()
        if user.isBot(), let body = message.body {
            messages.append(createTextMessage(message, user: user, text: body))
        } else {
            if let item = message.item {
                switch item.messageData {
                case let .bid(bid):
                    messages = handleBid(bid, message: message, user: user, thread: thread)
                case let .order(order):
                    messages = handleOrder(order, message: message, user: user, thread: thread)
                case let .shipment(shipment):
                    messages = handleShipment(shipment, message: message, user: user)
                case .product:
                    if let body = message.body {
                        messages.append(createTextMessage(message, user: user, text: body))
                    }
                case let .image(image):
                    guard let url = URL(string: image.url) else { return messages }
                    messages.append(createMediaMessage(message, user: user, id: image.id, url: url, type: .image))
                case let .video(video):
                    guard let url = URL(string: video.url) else { return messages }
                    messages.append(createMediaMessage(message, user: user, id: video.id, url: url, type: .video))
                case .other:
                    if let body = message.body {
                        messages.append(createTextMessage(message, user: user, text: body))
                    }
                }
            } else {
                if let body = message.body {
                    messages.append(createTextMessage(message, user: user, text: body))
                    if showsAutoreply {
                        messages.append(createBotFirstReplyMessage())
                    }
                }
            }
        }

        return messages
    }
}

// MARK: Orders

extension ChatMessageFactory {
    private func handleOrder(_ order: GraphOrder,
                             message: GraphMessage,
                             user: ChatUser,
                             thread: GraphThread) -> [ChatMessage] {
        let isBuyer = order.buyer.id == merchantId
        let isSeller = order.merchant.id == merchantId
        if isBuyer {
            return handleOrderBuyer(order, message: message, user: user, thread: thread)
        } else if isSeller {
            return handleOrderSeller(order, message: message, user: user, thread: thread)
        }
        return []
    }

    private func getOrderIncompleteCell(_ order: GraphOrder,
                                        message: GraphMessage,
                                        text: String,
                                        thread: GraphThread) -> ChatMessage {
        var biddingEnabled = false
        if let state = order.product.orderAuction?.state {
            biddingEnabled = bidEnabled(state, thread: thread)
        }
        let payload = OrderIncompletePayload(state: order.orderState,
                                             orderID: order.id,
                                             text: text,
                                             biddingEnabled: biddingEnabled)
        return createMessage(message, user: bot, type: .orderIncomplete(payload: payload))
    }

    private func handleOrderBuyer(_ order: GraphOrder,
                                  message: GraphMessage,
                                  user: ChatUser,
                                  thread: GraphThread) -> [ChatMessage] {
        var messages = [ChatMessage]()
        switch order.orderState {
        case .new:
            if let bid = order.bid {
                messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidSentAcceptedBuyer()))
                let paymentInput = PaymentInput(productId: order.product.id, bidId: bid.id, orderId: order.id)
                let bidAmount = PriceInput(currency: bid.amount.currency, amount: bid.amount.amount)
                let payload = AskPayPayload(bidId: bid.id, bidStatus: bid.state, orderId: order.id, paymentInput: paymentInput, isPaid: false, bidAmount: bidAmount)
                messages.append(createMessage(message, user: bot, type: .askPay(payload: payload)))
            }
        case .accepted, .shipped:
            messages.append(contentsOf: getOrderStatementBuyer(order, message: message, user: user))

            switch order.deliveryMethod {
            case .delivery, .pickupDelivery:
                if let shipping = order.shippingMethod {
                    if shipping.slug != courierMethodSlug {
                        let orderNewPackageBuyer1 = R.string.localizable.orderAcceptedPackageBuyer()
                        messages.append(createBotMessage(message, order: order.id, text: orderNewPackageBuyer1))
                    } else {
                        let orderNewCourierBuyer1 = R.string.localizable.orderAcceptedCourierBuyer1()
                        let orderNewCourierBuyer2 = R.string.localizable.orderAcceptedCourierBuyer2()
                        messages.append(createBotMessage(message, order: order.id, text: orderNewCourierBuyer1))
                        messages.append(createBotMessage(message, order: order.id, text: orderNewCourierBuyer2))
                    }
                    
                    if order.orderState == .shipped {
                        // Fix for scenario where orders go straight from accepted->shipped
                        // Previously there was a 'shipment' objecct sent alongside a message
                        // Now we no longer receive the shipment chat message
                        // We just get told that the order is shipped without the shipment message
                        // No real (nice) way for us to know if this behaviour is present or not (i.e. we get the shipment chat message)
                        // So it is possible if it is re-instated we'd see two productreceived views
                        let receivedPayload = ProductReceivedPayload(deliveryMethod: order.deliveryMethod,
                                                                     orderID: order.id,
                                                                     receiveState: .notReceived)
                        messages.append(createMessage(message, user: bot, type: .didProductReceived(payload: receivedPayload)))
                    }
                }
            case .pickup:
                messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedPickupBuyer()))
                let receivedPayload = ProductReceivedPayload(deliveryMethod: order.deliveryMethod,
                                                             orderID: order.id,
                                                             receiveState: .notReceived)
                messages.append(createMessage(message, user: bot, type: .didProductReceived(payload: receivedPayload)))
 
            default: break
            }
        case .completed:
            messages.append(contentsOf: getOrderStatementBuyer(order, message: message, user: user))
            
            if order.orderState == .completed {
               
                let attributedPlainText = NSMutableAttributedString()
                    .normal("Whoppah!\n")
                    .normal(R.string.localizable.chatItemReceivedMessage1Line() + "\n")
                
                attributedPlainText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], range: NSRange(location: 0, length: attributedPlainText.length))
                    
                let attributedBoldText = NSMutableAttributedString()
                    .bold(R.string.localizable.chatItemReceivedMessage2Line())
                attributedBoldText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)], range: NSRange(location: 0, length: attributedBoldText.length))
                
                attributedPlainText.append(attributedBoldText)
                
                messages.append(createAutoreplyBotMessage(message, order: order.id, attributedPayload: attributedPlainText))
            }
            
            // For delivery we show the order completed message when the shipment order is flagged as completed
            if order.deliveryMethod == .pickup {
                messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderCompletedBuyer()))
            }
        case .disputed:
            messages.append(contentsOf: getOrderStatementBuyer(order, message: message, user: user))
            if order.deliveryMethod == .pickup {
                messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderDisputedBuyer()))
            }
        case .canceled:
            messages.append(getOrderIncompleteCell(order, message: message, text: R.string.localizable.orderCancelledBuyer(), thread: thread))
        case .expired:
            messages.append(getOrderIncompleteCell(order, message: message, text: R.string.localizable.orderExpiredBuyer(), thread: thread))
        case .delivered: break
        case .__unknown:
            assertionFailure()
        }
        return messages
    }

    private func handleOrderSeller(_ order: GraphOrder,
                                   message: GraphMessage,
                                   user: ChatUser,
                                   thread: GraphThread) -> [ChatMessage] {
        var messages = [ChatMessage]()
        switch order.orderState {
        case .new, .delivered:
            break
        case .accepted, .shipped:
            messages.append(contentsOf: getOrderStatementSeller(order, message: message, user: user))

            switch order.deliveryMethod {
            case .delivery, .pickupDelivery:
                if let shipping = order.shippingMethod {
                    if shipping.slug == courierMethodSlug {
                        messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedCourierSeller1()))
                        messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedCourierSeller2()))
                        messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedCourierSeller3()))
                        messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedCourierSeller4()))

                        // Whoppah handles the courier service on the user's behalf so no message to ask for tracking code
                    } else {
                        messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedPackageSeller1()))
                        messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedPackageSeller2()))
                        messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedPackageSeller3()))
                        messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedPackageSeller4()))

                        let hasTracking = (order.shipment != nil)
                        // Only send the tracking message if delivery is not courier
                        let payload = AskTrackingPayload(order: order.id,
                                                         hasTrackingCode: hasTracking)
                        let message = createMessage(message, user: bot, type: .askTrackingID(payload: payload))
                        messages.append(message)
                    }
                }
            case .pickup:
                messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedPickupSeller()))
            default: break
            }
        case .completed:
            messages.append(contentsOf: getOrderStatementSeller(order, message: message, user: user))
            messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderCompletedSeller()))
        case .disputed:
            messages.append(contentsOf: getOrderStatementSeller(order, message: message, user: user))
            if order.deliveryMethod == .pickup {
                messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderDisputedPickupSeller()))
            } else {
                messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderDisputedDeliverySeller()))
            }
        case .canceled:
            messages.append(getOrderIncompleteCell(order, message: message, text: R.string.localizable.orderCancelledSeller(), thread: thread))
        case .expired:
            messages.append(getOrderIncompleteCell(order, message: message, text: R.string.localizable.orderExpiredSeller(), thread: thread))
        case .__unknown:
            assertionFailure()
        }
        return messages
    }

    private func getOrderAddress(_ order: GraphOrder) -> LegacyAddressInput? {
        guard let orderAddress = order.address else { return nil }
        return LegacyAddressInput(line1: orderAddress.line1,
                            line2: orderAddress.line2,
                            postalCode: orderAddress.postalCode,
                            city: orderAddress.city,
                            state: orderAddress.state,
                            country: orderAddress.country,
                            point: nil)
    }

    private func getOrderStatementSeller(_ order: GraphOrder,
                                         message: GraphMessage,
                                         user _: ChatUser) -> [ChatMessage] {
        var messages = [ChatMessage]()
        let name = getMerchantDisplayName(type: order.buyer.type,
                                          businessName: order.buyer.businessName,
                                          name: order.buyer.name)

        let address = getOrderAddress(order)

        // Assumes same currency for all
        let currency = order.currency
        let basePriceInclVat = PriceInput(currency: currency, amount: order.subtotalInclVat)
        let whoppahFeeInclVAT = PriceInput(currency: currency, amount: order.feeInclVat)
        var shippingPrice: PriceInput!
        if order.shippingMethod?.slug == courierMethodSlug {
            shippingPrice = PriceInput(currency: currency, amount: 0)
        } else {
            shippingPrice = PriceInput(currency: currency, amount: order.shippingInclVat)
        }
        let payout = PriceInput(currency: currency, amount: order.payout)

        if userService.current?.isProfessional == true {
            let basePriceExVat = PriceInput(currency: currency, amount: order.subtotalInclVat)

            let discountInclVAT = PriceInput(currency: currency, amount: order.discountInclVat)
            let discountExclVAT = PriceInput(currency: currency, amount: order.discountInclVat)
            let whoppahFeeExclVAT = PriceInput(currency: currency, amount: order.feeExclVat)
            let totalInclVAT = PriceInput(currency: currency, amount: order.totalInclVat)
            let totalExclVAT = PriceInput(currency: currency, amount: order.totalExclVat)
            let totalVat = order.feeInclVat - order.feeExclVat
            let vatPercent = (totalVat / order.feeExclVat) * 100
            let vatFee = PriceInput(currency: currency, amount: totalVat)
            let payload = PaymentCompletedMerchantPayload(orderId: order.id,
                                                          state: order.orderState,
                                                          adPrice: basePriceExVat,
                                                          shippingCost: shippingPrice,
                                                          shippingSlug: order.shippingMethod?.slug,
                                                          buyerName: name,
                                                          discountInclVAT: discountInclVAT,
                                                          discountExclVAT: discountExclVAT,
                                                          vatFee: vatFee,
                                                          vatPercent: vatPercent,
                                                          whoppahFee: whoppahFeeInclVAT,
                                                          whoppahFeeExclVAT: whoppahFeeExclVAT,
                                                          whoppahFeeType: order.merchant.fee?.type,
                                                          whoppahFeePercent: order.merchant.fee?.amount,
                                                          totalInclVAT: totalInclVAT,
                                                          totalExclVAT: totalExclVAT,
                                                          address: address,
                                                          payout: payout,
                                                          deliveryMethod: order.deliveryMethod)

            let type = ChatMessage.ContentType.paymentCompletedMerchant(payload: payload)
            let message = createMessage(message, user: bot, type: type)
            messages.append(message)
        } else {
            let payload = PaymentCompletedSellerPayload(orderId: order.id,
                                                        state: order.orderState,
                                                        adPrice: basePriceInclVat,
                                                        shippingCost: shippingPrice,
                                                        shippingSlug: order.shippingMethod?.slug,
                                                        whoppahFee: whoppahFeeInclVAT,
                                                        whoppahFeeType: order.merchant.fee?.type,
                                                        whoppahFeePercent: order.merchant.fee?.amount,
                                                        payout: payout,
                                                        address: address,
                                                        buyerName: name,
                                                        deliveryMethod: order.deliveryMethod)
            let type = ChatMessage.ContentType.paymentCompletedSeller(payload: payload)
            let message = createMessage(message, user: bot, type: type)
            messages.append(message)
        }
        return messages
    }

    private func getOrderStatementBuyer(_ order: GraphOrder,
                                        message: GraphMessage,
                                        user _: ChatUser) -> [ChatMessage] {
        var messages = [ChatMessage]()
        let name = getMerchantDisplayName(type: order.buyer.type,
                                          businessName: order.buyer.businessName,
                                          name: order.buyer.name)

        let address = getOrderAddress(order)

        // Assumes same currency for all
        let currency = order.currency
        let basePriceInclVat = PriceInput(currency: currency, amount: order.subtotalInclVat)
        let shippingPrice = PriceInput(currency: currency, amount: order.shippingInclVat)
        let paymentFee = PriceInput(currency: currency, amount: order.paymentInclVat)
        let total = PriceInput(currency: currency, amount: order.totalInclVat)
        let payload = PaymentCompletedBuyerPayload(orderId: order.id,
                                                   state: order.orderState,
                                                   adPrice: basePriceInclVat,
                                                   shippingCost: shippingPrice,
                                                   shippingSlug: order.shippingMethod?.slug,
                                                   paymentFee: paymentFee,
                                                   totalPrice: total,
                                                   address: address,
                                                   buyerName: name,
                                                   deliveryMethod: order.deliveryMethod)
        let type = ChatMessage.ContentType.paymentCompletedBuyer(payload: payload)
        messages.append(createMessage(message, user: bot, type: type))
        return messages
    }
}

// MARK: Bids

extension ChatMessageFactory {
    private func handleBid(_ bid: GraphBid,
                           message: GraphMessage,
                           user: ChatUser,
                           thread: GraphThread) -> [ChatMessage] {
        let isSender = message.merchant.id == merchantId
        let isReceiver = !isSender && (bid.merchant.id == merchantId || bid.buyer.id == merchantId)
        if isSender {
            return handleBidSender(bid, message: message, user: user, thread: thread)
        } else if isReceiver {
            return handleBidReceiver(bid, message: message, user: user, thread: thread)
        }
        return handleBidOther(bid, message: message, user: user, thread: thread)
    }

    private func bidEnabled(_ auctionStatus: GraphQL.AuctionState,
                            thread: GraphThread) -> Bool {
        // Unable to bid if the auction is not published (e.g. reserved)
        guard auctionStatus == .published else { return false }
        // Or if there's been an accepted bid already
        guard let auction = thread.item.asProduct?.auction else { return false }
        // If the accepted bid has an order that's expired/cancelled then we can
        let acceptedBid = auction.bids.first { bid -> Bool in
            // If the bid is new, expired or canceled then bidding is allowed
            // If there's an accepted bid then ensure that the order is valid, if not then bidding is allowed
            switch bid.state {
            case .accepted, .processing, .completed:
                if let order = bid.order {
                    switch order.state {
                    case .expired, .canceled:
                        return false
                    default:
                        return true
                    }
                } else {
                    return true
                }
            default:
                return false
            }
        }
        return acceptedBid == nil
    }

    private func handleAcceptedBidBuyer(_ bid: GraphBid,
                                        message: GraphMessage,
                                        bidPayload _: BidPayload,
                                        user _: ChatUser) -> [ChatMessage] {
        var messages = [ChatMessage]()

        let bidAmount = PriceInput(currency: bid.amount.currency, amount: bid.amount.amount)
        let paymentInput = PaymentInput(productId: bid.bidAuction.product.id, bidId: bid.id, orderId: bid.order?.id)

        var isPaid = false
        var showPay = false
        // If an order is in 'new' state then we show the ask pay button against the order
        // This is primarily so we can handle failed order payment via iDeal for example
        // The server will still create a chat thread for the
        if let order = bid.order {
            isPaid = order.state != .new
            showPay = order.state != .new
        } else {
            showPay = true
        }

        messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidSentAcceptedBuyer()))
        let payload = AskPayPayload(bidId: bid.id,
                                    bidStatus: bid.state,
                                    orderId: bid.order?.id,
                                    paymentInput: paymentInput,
                                    isPaid: isPaid,
                                    bidAmount: bidAmount)

        if showPay {
            messages.append(createMessage(message, user: bot, type: .askPay(payload: payload)))
        }
        return messages
    }

    private func handleBidSender(_ bid: GraphBid,
                                 message: GraphMessage,
                                 user: ChatUser,
                                 thread: GraphThread) -> [ChatMessage] {
        var messages = [ChatMessage]()
        let amount = PriceInput(currency: bid.amount.currency, amount: bid.amount.amount)
        let bidPayload = BidPayload(id: bid.id,
                                    amount: amount,
                                    status: bid.state,
                                    buyerId: bid.buyer.id,
                                    productId: bid.bidAuction.product.id,
                                    auctionId: bid.bidAuction.id,
                                    orderId: bid.order?.id,
                                    biddingEnabled: bidEnabled(bid.bidAuction.state, thread: thread))
        switch bid.state {
        case .new:
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))

            if UserDefaultsConfig.willShowNewBidText(bid.id) {
                if bid.merchant.id == user.id {
                    messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidSentNewSeller1()))
                } else {
                    messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidSentNewBuyer1()))
                }
                messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidSentNewBuyer2()))
            } else {
                messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidSentNewSimple()))
            }
        case .rejected:
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))
        case .accepted:
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))
            let isSeller = bid.merchant.id == merchantId
            if isSeller {
                messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidAcceptedSeller()))
            } else {
                messages.append(contentsOf: handleAcceptedBidBuyer(bid, message: message, bidPayload: bidPayload, user: user))
            }
        case .expired:
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))
            messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidExpired()))
        default:
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))
        }
        return messages
    }

    private func handleBidReceiver(_ bid: GraphBid,
                                   message: GraphMessage,
                                   user: ChatUser,
                                   thread: GraphThread) -> [ChatMessage] {
        var messages = [ChatMessage]()
        let amount = PriceInput(currency: bid.amount.currency, amount: bid.amount.amount)
        let bidPayload = BidPayload(id: bid.id,
                                    amount: amount,
                                    status: bid.state,
                                    buyerId: bid.buyer.id,
                                    productId: bid.bidAuction.product.id,
                                    auctionId: bid.bidAuction.id,
                                    orderId: bid.order?.id,
                                    biddingEnabled: bidEnabled(bid.bidAuction.state, thread: thread))
        switch bid.state {
        case .new:
            if bid.merchant.id == merchantId {
                var showMessage = false
                if let botMessage = UserDefaultsConfig.sellerBotMessageId {
                    showMessage = botMessage == message.id.uuidString
                } else {
                    UserDefaultsConfig.sellerBotMessageId = message.id.uuidString
                    showMessage = true
                }

                if showMessage {
                    messages.append(createBotMessage(message,
                                                     bid: bid.id,
                                                     text: R.string.localizable.bidReceivedTipNew(user.displayName, bid.bidAuction.product.title)))
                }
            } else if bid.buyer.id == merchantId {
                var showMessage = false
                if let botMessage = UserDefaultsConfig.buyerBotMessageId {
                    showMessage = botMessage == message.id.uuidString
                } else {
                    UserDefaultsConfig.buyerBotMessageId = message.id.uuidString
                    showMessage = true
                }

                if showMessage {
                    messages.append(createBotMessage(message,
                                                     bid: bid.id,
                                                     text: R.string.localizable.bidReceivedTipNew(user.displayName, bid.bidAuction.product.title)))
                }
            }
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))
            if bid.merchant.id == user.id {
                messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidReceivedNewSeller()))
            } else {
                messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidReceivedNewBuyer()))
            }
        case .rejected:
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))
        case .accepted:
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))

            let isSeller = bid.merchant.id == merchantId
            if isSeller {
                messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidAcceptedSeller()))
            } else {
                messages.append(contentsOf: handleAcceptedBidBuyer(bid, message: message, bidPayload: bidPayload, user: user))
            }
        case .expired:
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))
            messages.append(createBotMessage(message, bid: bid.id, text: R.string.localizable.bidExpired()))
        default:
            messages.append(createMessage(message, user: user, type: .bid(payload: bidPayload)))
        }
        return messages
    }

    private func handleBidOther(_ bid: GraphBid,
                                message: GraphMessage,
                                user: ChatUser,
                                thread: GraphThread) -> [ChatMessage] {
        let amount = PriceInput(currency: bid.amount.currency, amount: bid.amount.amount)
        let bidPayload = BidPayload(id: bid.id,
                                    amount: amount,
                                    status: bid.state,
                                    buyerId: bid.buyer.id,
                                    productId: bid.bidAuction.product.id,
                                    auctionId: bid.bidAuction.id,
                                    orderId: bid.order?.id,
                                    biddingEnabled: bidEnabled(bid.bidAuction.state, thread: thread))
        let newMessage = createMessage(message, user: user, type: .bid(payload: bidPayload))
        return [newMessage]
    }
}

extension ChatMessageFactory {
    private func handleShipment(_ shipment: GraphShipment,
                                message: GraphMessage,
                                user: ChatUser) -> [ChatMessage] {
        let order = shipment.shipmentOrder
        let isBuyer = order.buyer.id == merchantId
        let isSeller = order.merchant.id == merchantId
        if isBuyer {
            return handleShipmentBuyer(shipment, message: message, user: user)
        } else if isSeller {
            return handleShipmentSeller(shipment, message: message, user: user)
        }
        return []
    }

    private func handleShipmentBuyer(_ shipment: GraphShipment,
                                     message: GraphMessage,
                                     user: ChatUser) -> [ChatMessage] {
        var messages = [ChatMessage]()
        let order = shipment.shipmentOrder
        var isCourier = false
        if let shipping = order.shippingMethod, shipping.slug == courierMethodSlug {
            isCourier = true
        }
        if shipment.trackingCode?.isEmpty == false {
            let payload = TrackIDPayload(orderId: order.id,
                                         trackingID: shipment.trackingCode,
                                         returnID: shipment.returnCode,
                                         isCourier: isCourier)
            messages.append(createMessage(message, user: user, type: .trackingID(payload: payload)))
        }
        let isPending = shipment.shipmentOrder.state == .shipped
        // Note - this makes the message disappear
        if isPending {
            messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderAcceptedPickupBuyer()))
            let receivedPayload = ProductReceivedPayload(deliveryMethod: order.deliveryMethod,
                                                         orderID: order.id,
                                                         receiveState: isPending ? .notReceived : .received)
            messages.append(createMessage(message, user: bot, type: .didProductReceived(payload: receivedPayload)))
        }

        // Send through the order completion message here instead of the order completion
        // This is so the logical order of order->shipment is kept in place.
        if order.deliveryMethod != .pickup {
            switch order.state {
            case .completed:
                messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderCompletedBuyer()))
            case .disputed:
                messages.append(createBotMessage(message, order: order.id, text: R.string.localizable.orderDisputedBuyer()))
            default: break
            }
        }

        return messages
    }

    private func handleShipmentSeller(_: GraphShipment,
                                      message _: GraphMessage,
                                      user _: ChatUser) -> [ChatMessage] {
        []
    }
}
