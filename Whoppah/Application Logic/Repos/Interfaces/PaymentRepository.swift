//
//  PaymentRepository.swift
//  Whoppah
//
//  Created by Eddie Long on 11/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

enum PaymentError: String, Error, LocalizedError {
    case noPaymentFound = "no payment found"
    case noMatchingBidFound = "no matching bid found"
    case noPaymentMethodFound = "no payment method found"
    case missingStripePayment = "missing stripe payment"
    case missingOrder = "missing order"
    case missingPaymentIntent = "missing payment intent"
    case orderStatusNotUpdated = "order status not updated"
    case sourceStatusFailed = "source status = failed"
    case sourceStatusConsumed = "source status = consumed"

    public var errorDescription: String? {
        switch self {
        case .sourceStatusFailed:
            return R.string.localizable.common_generic_error_message()
        default:
            #if DEBUG || STAGING || TESTING
                return rawValue
            #else
                return R.string.localizable.common_generic_error_message()
            #endif
        }
    }
}

struct PaymentViewData {
    let productUrl: URL?
    let productTitle: String
    let deliveryMethod: GraphQL.DeliveryMethod
    let bidId: UUID
    let shippingMethod: ShippingMethod?
    let shippingCost: Price?
    let customShippingCost: Price?
    let originCountry: String
    let currency: GraphQL.Currency
}

struct PaymentTotals {
    let subtotal: PriceInput
    let shipping: PriceInput?
    let paymentCost: PriceInput
    let discount: PriceInput
    let total: PriceInput
    let buyerProtectionInclVat: PriceInput
    let buyerProtectionExclVat: PriceInput
}

protocol PaymentRepository {
    var paymentInfo: Observable<PaymentViewData> { get }
    func loadOrder(id: UUID) -> Observable<GraphQL.OrderQuery.Data.Order>
    func load(id: UUID, bidId: UUID)

    var totals: Observable<PaymentTotals> { get }
    func loadTotals(input: GraphQL.OrderInput, currency: GraphQL.Currency)
}
