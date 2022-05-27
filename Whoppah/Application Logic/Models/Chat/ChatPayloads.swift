//
//  Payload.swift
//  Whoppah
//
//  Created by Boris Sagan on 1/23/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

// Needed for tests for easy processing of payloads with some common code
protocol BasePayload {}

private func bidHash(into hasher: inout Hasher, id: UUID, status: GraphQL.BidState, orderId: UUID?) {
    hasher.combine("bid".hashValue)
    hasher.combine(id.hashValue)
    hasher.combine(status.rawValue.hashValue)
    if let id = orderId {
        hasher.combine(id.hashValue)
    }
}

private func orderHash(into hasher: inout Hasher, id: UUID, state: GraphQL.OrderState? = nil) {
    hasher.combine("order".hashValue)
    hasher.combine(id.hashValue)
    if let state = state {
        hasher.combine(state.hashValue)
    }
}

public struct AutoreplyPayload: Hashable, BasePayload {
    // MARK: - Properties

    public var attributedPayload: NSAttributedString
    private let id: UUID

    // Still need to be able to distinguish between a message associated with a bid/order/user
    init(messageId: UUID, attributedPayload: NSAttributedString) {
        self.attributedPayload = attributedPayload
        id = messageId
    }

    init(bid: UUID, attributedPayload: NSAttributedString) {
        id = bid
        self.attributedPayload = attributedPayload
    }

    init(order: UUID, attributedPayload: NSAttributedString) {
        id = order
        self.attributedPayload = attributedPayload
    }

    init(shipment: UUID, attributedPayload: NSAttributedString) {
        id = shipment
        self.attributedPayload = attributedPayload
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
        hasher.combine(attributedPayload.hashValue)
    }
}

public struct TextPayload: Hashable, BasePayload {
    // MARK: - Properties

    public var text: String
    private let id: UUID

    // Still need to be able to distinguish between a message associated with a bid/order/user
    init(messageId: UUID, text: String) {
        self.text = text
        id = messageId
    }

    init(bid: UUID, text: String) {
        id = bid
        self.text = text
    }

    init(order: UUID, text: String) {
        id = order
        self.text = text
    }

    init(shipment: UUID, text: String) {
        id = shipment
        self.text = text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
        hasher.combine(text.hashValue)
    }
}

public struct MediaPayload: Hashable, BasePayload {
    public enum MediaType {
        case video
        case image
    }

    public enum MediaData {
        case existing(url: URL)
        case local(data: Data)
    }

    public let text: String?
    public let data: MediaData

    private let id: UUID
    public let type: MediaType
    init(id: UUID, data: MediaData, type: MediaType, text: String? = nil) {
        self.id = id
        self.data = data
        self.type = type
        self.text = text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
        hasher.combine(type.hashValue)
        if let text = text {
            hasher.combine(text.hashValue)
        }
    }

    public static func == (lhs: MediaPayload, rhs: MediaPayload) -> Bool {
        lhs.id == rhs.id
    }
}

public struct AskTrackingPayload: Hashable, BasePayload {
    // MARK: - Properties

    public var order: UUID
    public var hasTrackingCode: Bool

    public func hash(into hasher: inout Hasher) {
        orderHash(into: &hasher, id: order)
        hasher.combine(hasTrackingCode.hashValue)
    }
}

struct BidPayload: Hashable, BasePayload {
    static func == (lhs: BidPayload, rhs: BidPayload) -> Bool {
        lhs.id == rhs.id && lhs.status == rhs.status
    }

    // MARK: - Properties

    public var id: UUID
    public var amount: PriceInput
    public var status: GraphQL.BidState
    public var buyerId: UUID
    public var productId: UUID
    public var auctionId: UUID
    public var orderId: UUID?
    public var biddingEnabled: Bool

    public func hash(into hasher: inout Hasher) {
        bidHash(into: &hasher, id: id, status: status, orderId: orderId)
        hasher.combine(biddingEnabled.hashValue)
    }
}

struct AskPayPayload: Hashable, BasePayload {
    // MARK: - Properties

    public var bidId: UUID
    public var bidStatus: GraphQL.BidState
    public var orderId: UUID?
    public var paymentInput: PaymentInput
    public var isPaid: Bool
    public var bidAmount: PriceInput

    public func hash(into hasher: inout Hasher) {
        bidHash(into: &hasher, id: bidId, status: bidStatus, orderId: orderId)
        hasher.combine(isPaid.hashValue)
    }

    static func == (lhs: AskPayPayload, rhs: AskPayPayload) -> Bool {
        lhs.bidId == rhs.bidId
    }
}

struct PaymentCompletedBuyerPayload: Hashable, BasePayload {
    // MARK: - Properties

    public var orderId: UUID
    public var state: GraphQL.OrderState
    public var adPrice: PriceInput
    public var shippingCost: PriceInput?
    public var shippingSlug: String?
    public var paymentFee: PriceInput
    public var totalPrice: PriceInput
    public var address: LegacyAddressInput?
    public var buyerName: String
    public var deliveryMethod: GraphQL.DeliveryMethod

    public func hash(into hasher: inout Hasher) {
        orderHash(into: &hasher, id: orderId, state: state)
    }

    static func == (lhs: PaymentCompletedBuyerPayload, rhs: PaymentCompletedBuyerPayload) -> Bool {
        lhs.orderId == rhs.orderId
    }
}

struct PaymentCompletedSellerPayload: Hashable, BasePayload {
    // MARK: - Properties

    public var orderId: UUID
    public var state: GraphQL.OrderState
    public var adPrice: PriceInput
    public var shippingCost: PriceInput?
    public var shippingSlug: String?
    public var whoppahFee: PriceInput
    public var whoppahFeeType: GraphQL.CalculationMethod?
    public var whoppahFeePercent: Double? // Can be a percentage or fixed value (still use order total for display)
    public var payout: PriceInput
    public var address: LegacyAddressInput?
    public var buyerName: String
    public var deliveryMethod: GraphQL.DeliveryMethod

    public func hash(into hasher: inout Hasher) {
        orderHash(into: &hasher, id: orderId, state: state)
    }

    static func == (lhs: PaymentCompletedSellerPayload, rhs: PaymentCompletedSellerPayload) -> Bool {
        lhs.orderId == rhs.orderId
    }
}

struct PaymentCompletedMerchantPayload: Hashable, BasePayload {
    // MARK: - Properties

    public var orderId: UUID
    public var state: GraphQL.OrderState
    public var adPrice: PriceInput
    public var shippingCost: PriceInput?
    public var shippingSlug: String?
    public var buyerName: String
    public var discountInclVAT: PriceInput
    public var discountExclVAT: PriceInput
    public var vatFee: PriceInput
    public var vatPercent: Double
    public var whoppahFee: PriceInput
    public var whoppahFeeExclVAT: PriceInput
    public var whoppahFeeType: GraphQL.CalculationMethod?
    public var whoppahFeePercent: Double? // Can be a percentage or fixed value (still use order total for display)
    public var totalInclVAT: PriceInput
    public var totalExclVAT: PriceInput
    public var address: LegacyAddressInput?
    public var payout: PriceInput
    public var deliveryMethod: GraphQL.DeliveryMethod

    public func hash(into hasher: inout Hasher) {
        orderHash(into: &hasher, id: orderId, state: state)
    }

    static func == (lhs: PaymentCompletedMerchantPayload, rhs: PaymentCompletedMerchantPayload) -> Bool {
        lhs.orderId == rhs.orderId
    }
}

struct TrackIDPayload: Hashable, BasePayload {
    // MARK: - Properties

    public var orderId: UUID
    public var trackingID: String?
    public var returnID: String?
    public var isCourier: Bool = false

    public func hash(into hasher: inout Hasher) {
        orderHash(into: &hasher, id: orderId)
    }

    static func == (lhs: TrackIDPayload, rhs: TrackIDPayload) -> Bool {
        lhs.orderId == rhs.orderId
    }
}

struct ProductReceivedPayload: Hashable, BasePayload {
    enum ReceiveState {
        case received
        case notReceived
    }

    // MARK: - Properties

    public var deliveryMethod: GraphQL.DeliveryMethod
    public var orderID: UUID
    public var receiveState: ReceiveState

    public func hash(into hasher: inout Hasher) {
        orderHash(into: &hasher, id: orderID)
        hasher.combine(receiveState.hashValue)
    }

    static func == (lhs: ProductReceivedPayload, rhs: ProductReceivedPayload) -> Bool {
        lhs.orderID == rhs.orderID
    }
}

// This could be made generic to be a different style of cell
struct OrderIncompletePayload: Hashable, BasePayload {
    public var state: GraphQL.OrderState
    public var orderID: UUID
    public var text: String
    public var biddingEnabled: Bool

    public func hash(into hasher: inout Hasher) {
        orderHash(into: &hasher, id: orderID)
        hasher.combine(state.hashValue)
        hasher.combine(text)
        hasher.combine(biddingEnabled)
    }

    static func == (lhs: OrderIncompletePayload, rhs: OrderIncompletePayload) -> Bool {
        lhs.orderID == rhs.orderID
    }
}
