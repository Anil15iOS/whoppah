//
//  PaymentViewModelTests.swift
//  WhoppahTests
//
//  Created by Eddie Long on 20/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import Stripe

@testable import Testing_Debug
@testable import WhoppahCore

class MockPaymentCoordinator: PaymentCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init() {
        navigationController = UINavigationController()
    }
    func start(paymentInput: PaymentInput,
               isBuyNow: Bool?,
               delegate: PaymentDelegate?) {}

    func selectAddress(delegate: AddEditAddressViewControllerDelegate) {}

    func openChatThread(threadID: UUID) {}
    func dismiss() {}

    func showPaymentProcessingDialog() {}

    func hidePaymentProcessingDialog(_ completion: (() -> Void)? = nil) {}
    func dismissAll(withError error: Error) {}

    func startPaymentRedirectFlow(_ redirectContext: STPRedirectContext) {}

    func setContextHost(_ context: STPPaymentContext) {}
}

class MockPaymentRepo: PaymentRepository {
    let paymentInfo: Observable<PaymentViewData> = PublishSubject<PaymentViewData>()
    func loadOrder(id: UUID) -> Observable<GraphQL.OrderQuery.Data.Order> {
        return Observable.just(GraphQL.OrderQuery.Data.Order.init(id: UUID(), state: .accepted, expiryDate: DateTime(), deliveryMethod: .delivery, currency: .eur, subtotalInclVat: 121, subtotalExclVat: 100, shippingInclVat: 1.21, shippingExclVat: 1, paymentInclVat: 12.1, paymentExclVat: 10, discountInclVat: 0, discountExclVat: 0, totalInclVat: 134.31, totalExclVat: 111, feeInclVat: 12.1, feeExclVat: 10, payout: 100, product: GraphQL.OrderQuery.Data.Order.Product(id: UUID(), state: .accepted, merchant: GraphQL.OrderQuery.Data.Order.Product.Merchant(id: UUID(), name: "Merchant"), auction: GraphQL.OrderQuery.Data.Order.Product.Auction(id: UUID(), state: .published))))
    }
    func load(id: UUID, bidId: UUID) {}

    var totals: Observable<PaymentTotals> = PublishSubject<PaymentTotals>()
    func loadTotals(input: GraphQL.OrderInput, currency: GraphQL.Currency) {}
}

class PaymentViewModelTests: XCTestCase {
    var serviceProvider = MockServiceProvider()
    var repo = MockPaymentRepo()
    let coordinator = MockPaymentCoordinator()

    func testDunno() {
        let input = PaymentInput(productId: UUID(), bidId: UUID(), orderId: UUID())
        let vm = PaymentViewModel(provider: serviceProvider, coordinator: coordinator, delegate: nil, repo: repo, paymentInput: input, isBuyNow: true)
    }
}
