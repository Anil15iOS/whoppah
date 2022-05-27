//
//  PaymentCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 13/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import Stripe
import WhoppahCore

class PaymentCoordinatorImpl: PaymentCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private var backPressedCB: BackCallback?

    init(navigationController: UINavigationController,
         backPressed: BackCallback?) {
        self.navigationController = navigationController
        backPressedCB = backPressed
    }

    func start(paymentInput: PaymentInput,
               isBuyNow: Bool?,
               delegate: PaymentDelegate? = nil) {
        let vc = PaymentContactShippingViewController()
        let repo = PaymentRepositoryImpl()
        let viewModel = PaymentViewModel(coordinator: self,
                                         delegate: delegate,
                                         repo: repo,
                                         paymentInput: paymentInput,
                                         isBuyNow: isBuyNow)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    func openCheckoutScreen(viewModel: PaymentViewModel) {
        let vc = PaymentCheckoutViewController()
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    func selectAddress(delegate: AddEditAddressViewControllerDelegate) {
        let addressVC = AddEditAddressViewController()
        addressVC.delegate = delegate
        addressVC.isDeleteButtonHidden = true
        navigationController.pushViewController(addressVC, animated: true)
    }

    func openChatThread(threadID: UUID) {
        let coordinator = ThreadCoordinator(navigationController: navigationController)
        let rootVcIndex = navigationController.viewControllers.firstIndex(where: { type(of: $0) == PaymentContactShippingViewController.self })
        if let index = rootVcIndex {
            coordinator.start(threadID: threadID, insertAtIndex: index)
        } else {
            coordinator.start(threadID: threadID)
        }
    }

    func backPressed() {
        backPressedCB?()
        dismiss()
    }

    func dismiss() {
        let rootVcIndex = navigationController.viewControllers.firstIndex(where: { type(of: $0) == PaymentContactShippingViewController.self })
        if let index = rootVcIndex, index - 1 > 0 {
            let rootVC = navigationController.viewControllers[index - 1]
            navigationController.popToViewController(rootVC, animated: true)
        } else {
            navigationController.popViewController(animated: true)
        }
    }

    func showPaymentProcessingDialog() {
        guard let top = navigationController.topViewController else { return }
        let dialog = PaymentProcessingDialog()
        top.present(dialog, animated: true, completion: nil)
    }

    func hidePaymentProcessingDialog(_ completion: (() -> Void)? = nil) {
        guard let top = navigationController.presentedViewController as? PaymentProcessingDialog else { completion?(); return }
        top.dismiss(animated: true, completion: completion)
    }

    func dismissAll(withError error: Error) {
        navigationController.popToRootViewController(animated: true) {
            guard let top = self.navigationController.topViewController, let tabs = top.getTabsVC() else { return }
            tabs.showError(error)
        }
    }

    func startPaymentRedirectFlow(_ redirectContext: STPRedirectContext) {
        guard let top = navigationController.topViewController else { return }
        redirectContext.startRedirectFlow(from: top)
    }

    func setContextHost(_ context: STPPaymentContext) {
        guard let top = navigationController.topViewController else { return }
        context.hostViewController = top
    }
}
