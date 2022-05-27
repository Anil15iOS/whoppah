//
//  PaymentService.swift
//  Whoppah
//
//  Created by Eddie Long on 10/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahDataStore

public protocol PaymentService {
    /// Fetch the Stripe ephemeral key from the backend
    ///
    /// - Parameter sdkVersion The SDK version of the Stripe iOS SDK
    /// - Returns: An observable with a JSON aka Dictionary for consumption by the Stripe SDK
    func getEphemeralKey(sdkVersion: String) -> Observable<JSON>

    /// Create a new order in the backend
    ///
    /// - Parameter input The order input data
    /// - Returns: An observable with the newly created order data
    func createOrder(input: GraphQL.OrderInput) -> Observable<GraphQL.CreateOrderMutation.Data.CreateOrder>

    /// Create a new payment for an order in the backend
    ///
    /// - Parameter orderId The order id to pay for
    /// - Parameter paymentMethod The payment method to use for payment
    /// - Parameter paymentMethodId The payment method id. This could may be nil if using a method like iDeal, or it can be a credit card Stripe method id
    /// - Returns: An observable with the newly created payment data
    func createPayment(orderId: UUID,
                       paymentMethod: GraphQL.PaymentMethod,
                       paymentMethodId: String?,
                       deliveryMethodId: GraphQL.DeliveryMethod?,
                       shippingMethodId: UUID?,
                       addressID: UUID?,
                       buyerProtection: Bool) -> Observable<GraphQL.CreatePaymentMutation.Data.CreatePayment>
    
    /// Checks the backend for the latest order status
    ///
    /// - Parameter orderId The order id to check
    /// - Returns: An observable with the order payment status
    func checkOrderStatus(orderId: UUID) -> Observable<GraphQL.CheckOrderPaymentMutation.Data.CheckOrderPayment>

    /// Creates 'feedback' for a given order.
    /// This in essence indicates whether a user has received the item in good or bad condition
    /// This moves the order into the 'completed' or 'disputed' state
    ///
    /// - Parameter orderId The order id to create feedback for
    /// - Returns: An observable with the order id
    func createFeedback(orderId: UUID, received: Bool, text: String?) -> Observable<UUID>

    /// Creates a 'shipment' for a given order.
    /// This in essence indicates whether a seller has shipped the item and it is now in transit
    /// This moves the order into the 'shipped' state
    ///
    /// - Parameter orderId The order id to create a shipment for
    /// - Parameter trackingCode The shipment tracking code
    /// - Parameter returnsCode The shipment returns code
    /// - Returns: An observable with the order id
    func createShipment(orderId: UUID, trackingCode: String, returnsCode: String?) -> Observable<UUID>
}
