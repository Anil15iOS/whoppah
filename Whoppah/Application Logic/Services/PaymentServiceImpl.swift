//
//  PaymentService.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/4/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class PaymentServiceImpl: PaymentService {

    @Injected private var apollo: ApolloService
    
    func getEphemeralKey(sdkVersion: String) -> Observable<JSON> {
        apollo.fetch(query: GraphQL.GetStripeEphemeralKeyQuery(version: sdkVersion)).compactMap { $0.data?.getStripeEphemeralKey }
    }

    func createPayment(orderId: UUID,
                       paymentMethod: GraphQL.PaymentMethod,
                       paymentMethodId: String?,
                       deliveryMethodId: GraphQL.DeliveryMethod?,
                       shippingMethodId: UUID?,
                       addressID: UUID?,
                       buyerProtection: Bool) -> Observable<GraphQL.CreatePaymentMutation.Data.CreatePayment>
    {
        let input = GraphQL.PaymentInput(paymentMethod: paymentMethod,
                                         paymentMethodId: paymentMethodId,
                                         deliveryMethod: deliveryMethodId,
                                         shippingMethodId: shippingMethodId,
                                         addressId: addressID,
                                         buyerProtection: buyerProtection)
        let createPayment = GraphQL.CreatePaymentMutation(id: orderId, values: input)
        return apollo.apply(mutation: createPayment).compactMap { $0.data?.createPayment }
    }

    func createOrder(input: GraphQL.OrderInput) -> Observable<GraphQL.CreateOrderMutation.Data.CreateOrder> {
        let createOrder = GraphQL.CreateOrderMutation(input: input)
        return apollo.apply(mutation: createOrder).compactMap { $0.data?.createOrder }
    }

    func checkOrderStatus(orderId: UUID) -> Observable<GraphQL.CheckOrderPaymentMutation.Data.CheckOrderPayment> {
        let mutation = GraphQL.CheckOrderPaymentMutation(id: orderId)
        return apollo.apply(mutation: mutation).compactMap { $0.data?.checkOrderPayment }
    }

    func createFeedback(orderId: UUID, received: Bool, text: String?) -> Observable<UUID> {
        let mutation = GraphQL.CreateFeedbackMutation(id: orderId, received: received, text: text)
        return apollo.apply(mutation: mutation).compactMap { $0.data?.createFeedback.id }
    }

    func createShipment(orderId: UUID, trackingCode: String, returnsCode: String?) -> Observable<UUID> {
        let input = GraphQL.ShipmentInput(orderId: orderId, trackingCode: trackingCode, returnCode: returnsCode)
        let mutation = GraphQL.CreateShipmentMutation(input: input)
        return apollo.apply(mutation: mutation).compactMap { $0.data?.createShipment.id }
    }
}
