//
//  ChatMessageFactoryTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 25/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import MessengerKit
import XCTest

@testable import Testing_Debug
@testable import WhoppahCore
@testable import WhoppahDataStore
import Resolver

let mockOtherMember = MockMember(merchant: [MockMerchant(type: .business)])
let mockOtherMerchant = mockOtherMember.mainMerchant as! MockMerchant

class ChatMessageFactoryTests: XCTestCase {
    typealias MessageItem = GraphQL.GetMessagesQuery.Data.Message.Item
    typealias MessageBid = MessageItem.Item.AsBid
    typealias MessageBidAuction = MessageBid.BidAuction
    typealias MessageBidProduct = MessageBidAuction.Product

    typealias MessageOrder = MessageItem.Item.AsOrder
    typealias MessageShipment = MessageItem.Item.AsShipment

    lazy var factory = { ChatMessageFactory() }()

    override func setUp() {
        MockServiceInjector.register()
        let userService: LegacyUserService = Resolver.resolve()
        if let mockUserService = userService as? MockUserService {
            mockUserService.current = mockMember
        }
        mockMerchant.add(theMember: mockMember)
        mockIndividualMerchant.add(theMember: mockIndividualMember)
        mockOtherMerchant.add(theMember: mockOtherMember)
    }

    override func tearDown() {
        let userService: LegacyUserService = Resolver.resolve()
        if let mockUserService = userService as? MockUserService {
            mockUserService.current = nil
        }
    }

    func testIdGeneration() {
        let newId = UUID()
        let newMessageId = factory.generateMessageId(newId)
        XCTAssert(newMessageId >= 0)

        let newMessageId2 = factory.generateMessageId(newId)
        // Generation of message ids always returns a new one, regardless of whether it exists or not
        XCTAssertNotEqual(newMessageId, newMessageId2)

        let foundMessage = factory.getMessageId(newId)
        let foundMessage2 = factory.getMessageId(newId)

        XCTAssertEqual(foundMessage.first!, foundMessage2.first!)

        let disallowCreate = factory.getMessageId(UUID(), createIfMissing: false)
        XCTAssertTrue(disallowCreate.isEmpty)
    }

    func testMessageBidGeneration() {
        let text = "My message"
        let messageId = UUID()
        let newMessage = ChatMessageFactory.NewMessage(id: messageId, created: DateTime(), sender: GraphQL.SendMessageMutation.Data.SendMessage.Sender(id: UUID(), givenName: "John", familyName: "Doe"), merchant: GraphQL.SendMessageMutation.Data.SendMessage.Merchant(id: UUID(), name: "MerCo"), subscriber: GraphQL.SendMessageMutation.Data.SendMessage.Subscriber(id: UUID(), role: GraphQL.SubscriberRole.subscriber), body: text, unread: false)
        let msg = factory.createTextMessage(newMessage, user: ChatUser(id: UUID(), displayName: "Test User", avatar: UIImage(), role: .subscriber))
        XCTAssertFalse(msg.isUnread)
        guard case let MSGMessageBody.custom(body) = msg.msgMessage.body else { XCTFail("Expect custom message"); return }
        guard let dataMessage = body as? ChatMessage else { XCTFail("Expect body as ChatMessage"); return }
        guard case .text(let payload) = dataMessage.type else { XCTFail("Expect text payload"); return }
        XCTAssertEqual(payload.text, text)
    }

    private func getSender(merchant: MockMerchant) -> (MessageItem.Sender, MessageItem.Merchant, MessageItem.Subscriber) {
        let member = merchant.member.first!
        let sender = MessageItem.Sender(id: member.id,
                                        givenName: member.givenName,
                                        familyName: member.familyName)
        let merchant = MessageItem.Merchant(id: merchant.id,
                                            name: merchant.name,
                                            type: merchant.type,
                                            avatar: nil)
        let subscriber = MessageItem.Subscriber(id: merchant.id,
                                                role: .subscriber)
        return (sender, merchant, subscriber)
    }

    struct BidParams {
        let bidId: UUID
        let amount: Double
        let buyNowAmount: Double
        let state: GraphQL.BidState
        let seller: MockMerchant
        let buyer: MockMerchant
    }

    private func createBid(params: BidParams) -> ChatMessageFactory.GraphMessage {

        let messageSender = getSender(merchant: params.buyer)
        let buyNowPrice = MessageBidAuction.BuyNowPrice(currency: .eur, amount: params.buyNowAmount)
        let auction = MessageBid.BidAuction(id: UUID(),
                                            state: .published,
                                            buyNowPrice: buyNowPrice,
                                            product: MessageBidProduct(id: UUID(),
                                                                       title: "Some product",
                                                                       auction: MessageBidProduct.Auction(state: .published)))
        let buyer = MessageBid.Buyer(id: params.buyer.id)
        let bid = ChatMessageFactory.GraphMessage.Item.makeBid(id: params.bidId,
                                                               state: params.state,
                                                               amount: MessageBid.Amount(currency: .eur, amount: params.amount),
                                                               buyer: buyer,
                                                               bidAuction: auction, merchant: MessageBid.Merchant(id: params.seller.id))
        return ChatMessageFactory.GraphMessage(id: UUID(),
                                               created: DateTime(),
                                               sender: messageSender.0,
                                               merchant: messageSender.1,
                                               subscriber: messageSender.2,
                                               item: bid,
                                               unread: true)
    }

    private func filterMessage(_ messages: [ChatMessage]) -> [ChatMessage.ContentType] {
        let foundMessages = messages.compactMap({ (msg) -> ChatMessage.ContentType? in
            guard case let MSGMessageBody.custom(body) = msg.msgMessage.body else { XCTFail("Expect custom message"); return nil }
            guard let dataMessage = body as? ChatMessage else { XCTFail("Expect body as ChatMessage"); return nil }
            return dataMessage.type
        })
        return foundMessages
    }

    private func getChatThread() -> ChatMessageFactory.GraphThread {
        let product = ChatMessageFactory.GraphThread.Item.makeProduct(id: UUID(),
                                                                      title: "Some item",
                                                                      merchant: GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct.Merchant(id: UUID(), name: "Test merchant", type: .individual),
                                                                      shippingCost: GraphQL.GetThreadQuery.Data.Thread.Item.AsProduct.ShippingCost(amount: 5, currency: GraphQL.Currency.eur),
                                                                      deliveryMethod: .delivery,
                                                                      thumbnails: [])
        return ChatMessageFactory.GraphThread(id: UUID(),
                                              created: DateTime(date: Date()),
                                              updated: DateTime(date: Date()),
                                              item: product,
                                              startedBy: GraphQL.GetThreadQuery.Data.Thread.StartedBy(id: UUID(), name: "Test", type: .individual),
                                              subscribers: [])
    }

    private func getBidPayloads(params: BidParams) -> [BasePayload] {
        let message = createBid(params: params)
        let user = ChatUser(id: UUID(), displayName: "Testing", avatar: UIImage.init(), role: .subscriber)
        let messages = factory.create(message: message, thread: getChatThread(), user: user, showsAutoreply: false)
        let foundMessages = filterMessage(messages).compactMap({ (type) -> BasePayload? in
            if case .bid(let payload) = type { return payload }
            if case .askPay(let payload) = type { return payload }
            return nil
        })
        XCTAssertGreaterThan(foundMessages.count, 0)
        return foundMessages
    }

    // MARK: Bids from me i.e. 'mock merchant' to other users
    func testNewBidFromMe() {
        let params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .new, seller: mockOtherMerchant, buyer: mockMerchant)
        let payloads = getBidPayloads(params: params)
        let payload = payloads.compactMap({ $0 as? BidPayload }).first!
        XCTAssertEqual(params.amount, payload.amount.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(params.bidId.uuidString, payload.id.uuidString)
        XCTAssertEqual(params.state, payload.status)
    }

    func testNewToAcceptedBidFromMe() {
        // given
        var params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .new, seller: mockOtherMerchant, buyer: mockMerchant)
        // when
        _ = getBidPayloads(params: params)
        params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .accepted, seller: mockOtherMerchant, buyer: mockMerchant)
        let payloads = getBidPayloads(params: params)
        let payload = payloads.compactMap({ $0 as? BidPayload }).first!

        // then
        XCTAssertEqual(params.amount, payload.amount.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(params.bidId.uuidString, payload.id.uuidString)
        XCTAssertEqual(params.state, payload.status)

        let askPayPayload = payloads.compactMap({ $0 as? AskPayPayload }).first!

        XCTAssertEqual(params.bidId.uuidString, askPayPayload.bidId.uuidString)
        XCTAssertEqual(payload.amount.amount, askPayPayload.bidAmount.amount, accuracy: Double.ulpOfOne)
        XCTAssertFalse(askPayPayload.isPaid)
    }

    func testNewToRejectedBidFromMe() {
        // given
        var params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .new, seller: mockOtherMerchant, buyer: mockMerchant)
        // when
        _ = getBidPayloads(params: params)
        params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .rejected, seller: mockOtherMerchant, buyer: mockMerchant)
        let payloads = getBidPayloads(params: params)
        let payload = payloads.compactMap({ $0 as? BidPayload }).first!

        // then
        XCTAssertEqual(params.amount, payload.amount.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(params.bidId.uuidString, payload.id.uuidString)
        XCTAssertEqual(params.state, payload.status)

        let askPayPayload = payloads.compactMap({ $0 as? AskPayPayload })
        XCTAssertTrue(askPayPayload.isEmpty)
    }

    func testNewToExpiredBidFromMe() {
        // given
        var params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .new, seller: mockOtherMerchant, buyer: mockMerchant)
        // when
        _ = getBidPayloads(params: params)
        params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .expired, seller: mockOtherMerchant, buyer: mockMerchant)
        let payloads = getBidPayloads(params: params)
        let payload = payloads.compactMap({ $0 as? BidPayload }).first!

        // then
        XCTAssertEqual(params.amount, payload.amount.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(params.bidId.uuidString, payload.id.uuidString)
        XCTAssertEqual(params.state, payload.status)

        let askPayPayload = payloads.compactMap({ $0 as? AskPayPayload })
        XCTAssertTrue(askPayPayload.isEmpty)
    }

    func testAcceptedBuyNowFromMe() {
        let params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 100.0, state: .accepted, seller: mockMerchant, buyer: mockOtherMerchant)
        let payloads = getBidPayloads(params: params)
        let payload = payloads.compactMap({ $0 as? BidPayload }).first!
        XCTAssertEqual(params.amount, payload.amount.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(params.bidId.uuidString, payload.id.uuidString)
        XCTAssertEqual(params.state, payload.status)

        let askPayPayload = payloads.compactMap({ $0 as? AskPayPayload })
        XCTAssertTrue(askPayPayload.isEmpty)
    }

    func testNewToAcceptedBidFromOther() {
        // given
        var params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .new, seller: mockMerchant, buyer: mockOtherMerchant)
        // when
        _ = getBidPayloads(params: params)
        params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .accepted, seller: mockMerchant, buyer: mockOtherMerchant)
        let payloads = getBidPayloads(params: params)
        let payload = payloads.compactMap({ $0 as? BidPayload }).first!

        // then
        XCTAssertEqual(params.amount, payload.amount.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(params.bidId.uuidString, payload.id.uuidString)
        XCTAssertEqual(params.state, payload.status)

        let askPayPayload = payloads.compactMap({ $0 as? AskPayPayload })
        XCTAssertTrue(askPayPayload.isEmpty)
    }

    func testAcceptedBidFromOther() {
       var params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .new, seller: mockOtherMerchant, buyer: mockMerchant)
        // when
        _ = getBidPayloads(params: params)
        params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .accepted, seller: mockOtherMerchant, buyer: mockMerchant)
        let payloads = getBidPayloads(params: params)
        let payload = payloads.compactMap({ $0 as? BidPayload }).first!

        // then
        XCTAssertEqual(params.amount, payload.amount.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(params.bidId.uuidString, payload.id.uuidString)
        XCTAssertEqual(params.state, payload.status)

        let askPayPayload = payloads.compactMap({ $0 as? AskPayPayload }).first!

        XCTAssertEqual(params.bidId.uuidString, askPayPayload.bidId.uuidString)
        XCTAssertEqual(payload.amount.amount, askPayPayload.bidAmount.amount, accuracy: Double.ulpOfOne)
        XCTAssertFalse(askPayPayload.isPaid)
    }

    // MARK: Bids from 'other' i.e. not the mock merchant
    func testNewToRejectedBidFromOther() {
        // given
        var params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .new, seller: mockMerchant, buyer: mockOtherMerchant)
        // when
        _ = getBidPayloads(params: params)
        params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .rejected, seller: mockMerchant, buyer: mockOtherMerchant)
        let payloads = getBidPayloads(params: params)
        let payload = payloads.compactMap({ $0 as? BidPayload }).first!

        // then
        XCTAssertEqual(params.amount, payload.amount.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(params.bidId.uuidString, payload.id.uuidString)
        XCTAssertEqual(params.state, payload.status)

        let askPayPayload = payloads.compactMap({ $0 as? AskPayPayload })
        XCTAssertTrue(askPayPayload.isEmpty)
    }

    func testNewToExpiredBidFromOther() {
        // given
        var params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .new, seller: mockMerchant, buyer: mockOtherMerchant)
        // when
        _ = getBidPayloads(params: params)
        params = BidParams(bidId: UUID(), amount: 100.0, buyNowAmount: 150.0, state: .expired, seller: mockMerchant, buyer: mockOtherMerchant)
        let payloads = getBidPayloads(params: params)
        let payload = payloads.compactMap({ $0 as? BidPayload }).first!

        // then
        XCTAssertEqual(params.amount, payload.amount.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(params.bidId.uuidString, payload.id.uuidString)
        XCTAssertEqual(params.state, payload.status)

        let askPayPayload = payloads.compactMap({ $0 as? AskPayPayload })
        XCTAssertTrue(askPayPayload.isEmpty)
    }

    // MARK: Orders

    struct OrderTestParams {
        let orderId: UUID
        let state: GraphQL.OrderState
        let method: GraphQL.DeliveryMethod
        let shippingMethod: MessageOrder.ShippingMethod?
        let subtotal: Double
        let vat: Double = 0.21
        let shipping: Double
        let discount: Double
        let payment: Double
        let total: Double
        let fee: Double
        let payout: Double
        let seller: MockMerchant
        let buyer: MockMerchant
    }

    private func exclVat(_ amount: Double, _ percentage: Double) -> Double { (amount / (100.0 + percentage * 100.0)) * 100.0 }

    private func createOrder(params: OrderTestParams) -> ChatMessageFactory.GraphMessage {

        let messageSender = getSender(merchant: params.buyer)
        var fee: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder.Merchant.Fee?
        if let fees = params.seller.fees {
            fee = GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder.Merchant.Fee(type: fees.type, amount: fees.amount)
        }
        let order = ChatMessageFactory.GraphMessage.Item.makeOrder(id: params.orderId,
                                                                   orderState: params.state,
                                                                   merchant: MessageOrder.Merchant(id: params.seller.id, fee: fee),
                                                                   buyer: MessageOrder.Buyer(id: params.buyer.id, name: "Test User", type: .business),
                                                                   bid: MessageOrder.Bid(id: UUID(), state: .accepted, amount: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder.Bid.Amount(currency: .eur, amount: params.subtotal)),
                                                                   product: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder.Product(id: UUID(), orderAuction: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder.Product.OrderAuction(id: UUID(), state: .completed)),
                                                       currency: .eur,
                                                       deliveryMethod: params.method,
                                                       shippingMethod: params.shippingMethod,
                                                       expiryDate: DateTime(date: Date.distantFuture),
                                                       subtotalInclVat: params.subtotal,
                                                       subtotalExclVat: exclVat(params.subtotal, params.vat),
                                                       shippingInclVat: params.shipping,
                                                       shippingExclVat: exclVat(params.shipping, params.vat),
                                                       discountInclVat: params.discount,
                                                       paymentInclVat: params.payment,
                                                       paymentExclVat: exclVat(params.payment, params.vat),
                                                       totalInclVat: params.total,
                                                       totalExclVat: exclVat(params.total, params.vat),
                                                       feeInclVat: params.fee,
                                                       feeExclVat: exclVat(params.fee, params.vat),
                                                       payout: params.payout)
        return ChatMessageFactory.GraphMessage(id: UUID(),
                                               created: DateTime(),
                                               sender: messageSender.0,
                                               merchant: messageSender.1,
                                               subscriber: messageSender.2,
                                               item: order,
                                               unread: true)
    }

    private func getOrderPayloads(params: OrderTestParams) -> [BasePayload] {
        let message = createOrder(params: params)
        let user = ChatUser(id: UUID(), displayName: "Testing", avatar: UIImage.init(), role: .subscriber)
        let messages = factory.create(message: message, thread: getChatThread(), user: user, showsAutoreply: false)
        let foundMessages = filterMessage(messages).compactMap({ (type) -> BasePayload? in
            if case .paymentCompletedBuyer(let payload) = type { return payload }
            if case .paymentCompletedSeller(let payload) = type { return payload }
            if case .paymentCompletedMerchant(let payload) = type { return payload }
            if case .askPay(let payload) = type { return payload }
            if case .askTrackingID(let payload) = type { return payload }
            if case .didProductReceived(let payload) = type { return payload }
            return nil
        })
        XCTAssertGreaterThan(foundMessages.count, 0)
        return foundMessages
    }

    func testAcceptedOrderBusinessFromMePickup() {
        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let order = OrderTestParams(orderId: UUID(), state: .accepted, method: .pickup, shippingMethod: nil, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockOtherMerchant, buyer: mockMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedBuyerPayload }).first!
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.totalPrice.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.totalPrice.amount, total, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, shipping, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.paymentFee.amount, payment, accuracy: Double.ulpOfOne)

        XCTAssertTrue(payloads.compactMap({ $0 as? AskTrackingPayload }).isEmpty)
        let productReceivedPayload = payloads.compactMap({ $0 as? ProductReceivedPayload }).first!
        XCTAssertEqual(productReceivedPayload.deliveryMethod, order.method)
        XCTAssertEqual(productReceivedPayload.orderID.uuidString, order.orderId.uuidString)
        XCTAssertEqual(productReceivedPayload.receiveState, .notReceived)

    }

    func testNewOrderBusinessFromMeAskPay() {
        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let order = OrderTestParams(orderId: UUID(), state: .new, method: .pickup, shippingMethod: nil, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockOtherMerchant, buyer: mockMerchant)

        let payloads = getOrderPayloads(params: order)
        let askPayPayload = payloads.compactMap({ $0 as? AskPayPayload }).first!
        XCTAssertEqual(askPayPayload.orderId!.uuidString, order.orderId.uuidString)
    }

    func testCompletedOrderBusinessFromMePickup() {
        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let order = OrderTestParams(orderId: UUID(), state: .completed, method: .pickup, shippingMethod: nil, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockOtherMerchant, buyer: mockMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedBuyerPayload }).first!
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.totalPrice.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.totalPrice.amount, total, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, shipping, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.paymentFee.amount, payment, accuracy: Double.ulpOfOne)

        XCTAssertTrue(payloads.compactMap({ $0 as? AskTrackingPayload }).isEmpty)
        XCTAssertTrue(payloads.compactMap({ $0 as? ProductReceivedPayload }).isEmpty)
    }

    func testAcceptedOrderBusinessFromMeShipping() {
        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let shippingMethod = MessageOrder.ShippingMethod(id: UUID(), title: "Super couriers", slug: "super-couriers", price: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder.ShippingMethod.Price(currency: .eur, amount: 10))
        let order = OrderTestParams(orderId: UUID(), state: .accepted, method: .delivery, shippingMethod: shippingMethod, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockOtherMerchant, buyer: mockMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedBuyerPayload }).first!
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.totalPrice.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.totalPrice.amount, total, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, shipping, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.paymentFee.amount, payment, accuracy: Double.ulpOfOne)

        XCTAssertTrue(payloads.compactMap({ $0 as? AskTrackingPayload }).isEmpty)
        XCTAssertTrue(payloads.compactMap({ $0 as? ProductReceivedPayload }).isEmpty)
    }

    func testAcceptedOrderBusinessFromOtherPickup() {
        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let order = OrderTestParams(orderId: UUID(), state: .accepted, method: .pickup, shippingMethod: nil, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockMerchant, buyer: mockOtherMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedMerchantPayload }).first!
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.totalInclVAT.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.totalInclVAT.amount, total, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.discountInclVAT.amount, discount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.payout.amount, payout, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, shipping, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.whoppahFee.amount, fee, accuracy: Double.ulpOfOne)
        XCTAssertTrue(payloads.compactMap({ $0 as? AskTrackingPayload }).isEmpty)
        XCTAssertTrue(payloads.compactMap({ $0 as? ProductReceivedPayload }).isEmpty)
    }

    func testCompletedOrderBusinessFromOtherPickup() {
        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let order = OrderTestParams(orderId: UUID(), state: .completed, method: .pickup, shippingMethod: nil, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockMerchant, buyer: mockOtherMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedMerchantPayload }).first!
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.totalInclVAT.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.totalInclVAT.amount, total, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.discountInclVAT.amount, discount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.payout.amount, payout, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, shipping, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.whoppahFee.amount, fee, accuracy: Double.ulpOfOne)
        XCTAssertTrue(payloads.compactMap({ $0 as? AskTrackingPayload }).isEmpty)
        XCTAssertTrue(payloads.compactMap({ $0 as? ProductReceivedPayload }).isEmpty)
    }

    func testAcceptedOrderBusinessFromOtherShippingCourier() {
        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let shippingMethod = MessageOrder.ShippingMethod(id: UUID(), title: "Whoppah Courier", slug: "courier", price: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder.ShippingMethod.Price(currency: .eur, amount: 10))
        let order = OrderTestParams(orderId: UUID(), state: .accepted, method: .delivery, shippingMethod: shippingMethod, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockMerchant, buyer: mockOtherMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedMerchantPayload }).first!
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.totalInclVAT.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.totalInclVAT.amount, total, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.discountInclVAT.amount, discount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.payout.amount, payout, accuracy: Double.ulpOfOne)
        // Whoppah takes the shipping fee
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, 0.0, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.whoppahFee.amount, fee, accuracy: Double.ulpOfOne)

        XCTAssertTrue(payloads.compactMap({ $0 as? AskTrackingPayload }).isEmpty)
    }

    func testAcceptedOrderBusinessFromOtherShippingPackage() {
        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let shippingMethod = MessageOrder.ShippingMethod(id: UUID(), title: "Standard", slug: "standard", price: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder.ShippingMethod.Price(currency: .eur, amount: 10))
        let order = OrderTestParams(orderId: UUID(), state: .accepted, method: .delivery, shippingMethod: shippingMethod, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockMerchant, buyer: mockOtherMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedMerchantPayload }).first!
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.totalInclVAT.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.totalInclVAT.amount, total, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.discountInclVAT.amount, discount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.payout.amount, payout, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, shipping, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.whoppahFee.amount, fee, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.whoppahFeeType!, mockMerchant.fees!.type)
        XCTAssertEqual(payload.whoppahFeePercent!, mockMerchant.fees!.amount, accuracy: Double.ulpOfOne)

        let askTrackingPayload = payloads.compactMap({ $0 as? AskTrackingPayload }).first!
        XCTAssertFalse(askTrackingPayload.hasTrackingCode)
        XCTAssertEqual(askTrackingPayload.order.uuidString, order.orderId.uuidString)
        XCTAssertTrue(payloads.compactMap({ $0 as? ProductReceivedPayload }).isEmpty)
    }

    func testAcceptedOrderIndividualSellerFromOtherPickup() throws {
        let userService: LegacyUserService = Resolver.resolve()
        let mockUserService = try XCTUnwrap(userService as? MockUserService)
        mockUserService.current = mockIndividualMember
        defer {
            mockUserService.current = mockMember
        }

        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let order = OrderTestParams(orderId: UUID(), state: .accepted, method: .pickup, shippingMethod: nil, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockIndividualMerchant, buyer: mockOtherMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedSellerPayload }).first!
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.adPrice.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.payout.amount, payout, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, shipping, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.whoppahFeeType!, mockIndividualMerchant.fees!.type)
        XCTAssertEqual(payload.whoppahFeePercent!, mockIndividualMerchant.fees!.amount, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.whoppahFee.amount, fee, accuracy: Double.ulpOfOne)

        XCTAssertTrue(payloads.compactMap({ $0 as? AskTrackingPayload }).isEmpty)
        XCTAssertTrue(payloads.compactMap({ $0 as? ProductReceivedPayload }).isEmpty)
    }

    func testAcceptedOrderIndividualSellerFromOtherShipping() throws {
        let userService: LegacyUserService = Resolver.resolve()
        let mockUserService = try XCTUnwrap(userService as? MockUserService)
        mockUserService.current = mockIndividualMember
        defer {
            mockUserService.current = mockMember
        }

        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let shippingMethod = MessageOrder.ShippingMethod(id: UUID(), title: "Super couriers", slug: "super-couriers", price: GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsOrder.ShippingMethod.Price(currency: .eur, amount: 10))
        let order = OrderTestParams(orderId: UUID(), state: .accepted, method: .delivery, shippingMethod: shippingMethod, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockIndividualMerchant, buyer: mockOtherMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedSellerPayload }).first!
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.adPrice.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.payout.amount, payout, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, shipping, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.whoppahFee.amount, fee, accuracy: Double.ulpOfOne)

        let askTrackingPayload = payloads.compactMap({ $0 as? AskTrackingPayload }).first!
        XCTAssertFalse(askTrackingPayload.hasTrackingCode)
        XCTAssertEqual(askTrackingPayload.order.uuidString, order.orderId.uuidString)
        XCTAssertTrue(payloads.compactMap({ $0 as? ProductReceivedPayload }).isEmpty)
    }

    func testCompletedOrderIndividualSellerFromOtherPickup() throws {
        let userService: LegacyUserService = Resolver.resolve()
        let mockUserService = try XCTUnwrap(userService as? MockUserService)
        mockUserService.current = mockIndividualMember
        defer {
            mockUserService.current = mockMember
        }

        let sub = 100.0
        let shipping = 20.0
        let discount = 0.0
        let payment = 4.0
        let fee = 10.0
        let payout = 110.0
        let total = sub + shipping + payment + fee
        let order = OrderTestParams(orderId: UUID(), state: .completed, method: .pickup, shippingMethod: nil, subtotal: sub, shipping: shipping, discount: discount, payment: payment, total: total, fee: fee, payout: payout, seller: mockIndividualMerchant, buyer: mockOtherMerchant)
        let payloads = getOrderPayloads(params: order)
        let payload = payloads.compactMap({ $0 as? PaymentCompletedSellerPayload }).first!
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload.deliveryMethod, order.method)
        XCTAssertEqual(payload.orderId, order.orderId)
        XCTAssertEqual(payload.adPrice.currency, .eur)
        XCTAssertEqual(payload.adPrice.amount, sub, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.payout.amount, payout, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.shippingCost?.amount ?? 0.0, shipping, accuracy: Double.ulpOfOne)
        XCTAssertEqual(payload.whoppahFee.amount, fee, accuracy: Double.ulpOfOne)

        XCTAssertTrue(payloads.compactMap({ $0 as? AskTrackingPayload }).isEmpty)
        XCTAssertTrue(payloads.compactMap({ $0 as? ProductReceivedPayload }).isEmpty)
    }

    // MARK: Shipment

    struct ShipmentTestParams {
        let shipmentId: UUID
        let orderId: UUID
        let existingFeedback: String?
        let trackingCode: String
        let returnsCode: String
        let deliveryMethod: GraphQL.DeliveryMethod
        let orderState: GraphQL.OrderState
        let seller: MockMerchant
        let buyer: MockMerchant
    }

    private func createShipment(params: ShipmentTestParams) -> ChatMessageFactory.GraphMessage {
        let messageSender = getSender(merchant: params.buyer)

        let order = MessageShipment.ShipmentOrder(id: params.orderId,
                                                  state: .shipped,
                                                  deliveryFeedback: params.existingFeedback,
                                                  deliveryMethod: params.deliveryMethod,
                                                  buyer: MessageShipment.ShipmentOrder.Buyer(id: params.buyer.id),
                                                  merchant: MessageShipment.ShipmentOrder.Merchant(id: params.seller.id))
        let shipment = ChatMessageFactory.GraphMessage.Item.makeShipment(id: params.shipmentId,
                                                                         trackingCode: params.trackingCode,
                                                                         returnCode: params.returnsCode,
                                                                         shipmentOrder: order)
        return ChatMessageFactory.GraphMessage(id: UUID(),
                                               created: DateTime(),
                                               sender: messageSender.0,
                                               merchant: messageSender.1,
                                               subscriber: messageSender.2,
                                               item: shipment,
                                               unread: true)
    }

    private func getTrackIdPayload(params: ShipmentTestParams) -> TrackIDPayload {
        let message = createShipment(params: params)
        let user = ChatUser(id: UUID(), displayName: "Testing", avatar: UIImage.init(), role: .subscriber)
        let messages = factory.create(message: message, thread: getChatThread(), user: user, showsAutoreply: false)
        let foundMessages = filterMessage(messages).compactMap({ (type) -> TrackIDPayload? in
            guard case .trackingID(let payload) = type else { return nil }
            return payload
        })
        XCTAssertGreaterThan(foundMessages.count, 0)
        return foundMessages.first!
    }

    func testShippingFromOther() {
        // given
        let params = ShipmentTestParams(shipmentId: UUID(),
                                        orderId: UUID(),
                                        existingFeedback: nil,
                                        trackingCode: "123456789",
                                        returnsCode: "987654321",
                                        deliveryMethod: .delivery,
                                        orderState: .shipped,
                                        seller: mockOtherMerchant,
                                        buyer: mockMerchant)
        // when
        let payload = getTrackIdPayload(params: params)
        // then
        XCTAssertEqual(payload.orderId.uuidString, params.orderId.uuidString)
        XCTAssertEqual(payload.trackingID, params.trackingCode)
        XCTAssertEqual(payload.returnID, params.returnsCode)
    }

    // MARK: Text

    struct TextParams {
        let text: String
        let isBot: Bool
        let sender: MockMerchant
    }
    private func createText(params: TextParams) -> ChatMessageFactory.GraphMessage {

        let messageSender = getSender(merchant: params.sender)
        return ChatMessageFactory.GraphMessage(id: UUID(),
                                               created: DateTime(),
                                               sender: messageSender.0,
                                               merchant: messageSender.1,
                                               subscriber: messageSender.2,
                                               body: params.text,
                                               unread: true)
    }

    private func getTextPayload(params: TextParams) -> TextPayload {
        let message = createText(params: params)
        let user = ChatUser(id: UUID(), displayName: "Testing", avatar: UIImage.init(), role: params.isBot ? .bot : .subscriber)
        let messages = factory.create(message: message, thread: getChatThread(), user: user, showsAutoreply: false)
        let foundMessages = filterMessage(messages).compactMap({ (type) -> TextPayload? in
            guard case .text(let payload) = type else { return nil }
            return payload
        })
        XCTAssertGreaterThan(foundMessages.count, 0)
        return foundMessages.first!
    }

    func testMyUserMessage() {
        // given
        let params = TextParams(text: "Some Text", isBot: false, sender: mockMerchant)
        // when
        let payload = getTextPayload(params: params)
        // then
        XCTAssertEqual(payload.text, params.text)
    }

    func testOtherUserMessage() {
        // given
        let params = TextParams(text: "Some Text", isBot: false, sender: mockOtherMerchant)
        // when
        let payload = getTextPayload(params: params)
        // then
        XCTAssertEqual(payload.text, params.text)
    }

    func testBotMessage() {
        // given
        let params = TextParams(text: "Some Text", isBot: true, sender: mockMerchant)
        // when
        let payload = getTextPayload(params: params)
        // then
        XCTAssertEqual(payload.text, params.text)
    }
}
