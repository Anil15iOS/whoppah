//
//  PaymentCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 20/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import Stripe

protocol PaymentCoordinator: Coordinator {
    typealias BackCallback = (() -> Void)

    func start(paymentInput: PaymentInput,
               isBuyNow: Bool?,
               delegate: PaymentDelegate?)

    func selectAddress(delegate: AddEditAddressViewControllerDelegate)

    func openChatThread(threadID: UUID)
    func backPressed()
    func dismiss()

    func showPaymentProcessingDialog()
    func openCheckoutScreen(viewModel: PaymentViewModel)
    func hidePaymentProcessingDialog(_ completion: (() -> Void)?)
    func dismissAll(withError error: Error)

    func startPaymentRedirectFlow(_ redirectContext: STPRedirectContext)

    func setContextHost(_ context: STPPaymentContext)
}
