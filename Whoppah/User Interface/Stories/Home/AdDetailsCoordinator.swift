//
//  AdDetailsCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 14/06/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import Resolver
import WhoppahUI
import SwiftUI

class AdDetailsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    weak var productDetailsViewController: ProductDetailHostingController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(adID: UUID) {
        let vc = ProductDetailHostingController(productId: adID, productSlug: nil)
        navigationController.pushViewController(vc, animated: true)
        productDetailsViewController = vc
    }
    
    func start(adSlug: String) {
        let vc = ProductDetailHostingController(productId: nil, productSlug: adSlug)
        navigationController.pushViewController(vc, animated: true)
        productDetailsViewController = vc
    }

    func showAssurance() {
        let coordinator = AssuranceCoordinator(navigationController: navigationController)
        coordinator.start()
    }

    func showPublicProfile(id: UUID) {
        let coordinator = PublicProfileCoordinator(navigationController: navigationController)
        coordinator.start(id: id)
    }

    func openChatThread(threadID: UUID) {
        let coordinator = ThreadCoordinator(navigationController: navigationController)
        coordinator.start(threadID: threadID)
    }

    func showSearch() {
        Navigator().navigate(route: Navigator.Route.search(input: .init()))
    }

    func showAd(id: UUID) {
        Navigator().navigate(route: Navigator.Route.ad(id: id))
    }

    func showMoreMenu(delegate: ReportDialogDelegate) {
        guard let topVC = navigationController.topViewController else { return }
        let reportDialog = ReportDialog()
        reportDialog.delegate = delegate
        topVC.present(reportDialog, animated: true, completion: nil)
    }

    func openShareSheet(text: String, url: URL, completion: @escaping ((String) -> Void)) {
        let activityItems = [text as Any, url]
        guard let topVC = navigationController.topViewController else { return }
        let vc = UIActivityViewController.createShareVC(activityItems: activityItems, sourceView: topVC.view) { activity in
            completion(activity.rawValue)
        }
        topVC.present(vc, animated: true, completion: nil)
    }

    func showUserReport(id: UUID) {
        guard let top = navigationController.topViewController else { return }
        let dialog = ReportUserDialog(merchantId: id)
        var helper = ReportServiceHelper()
        dialog.sendCallback = { [weak self] merchantId, reason, comment in
            guard let self = self else { return }
            guard let top = self.navigationController.topViewController else { return }
            helper.handleReportMerchantSend(merchantId: merchantId, reason: reason, comment: comment, vc: top)
        }
        top.present(dialog, animated: true, completion: nil)
    }

    func showProductReport(id: UUID) {
        guard let top = navigationController.topViewController else { return }
        let dialog = ReportProductDialog(itemId: id)
        var helper = ReportServiceHelper()
        dialog.sendCallback = { [weak self] productId, reason, comment in
            guard let self = self else { return }
            guard let top = self.navigationController.topViewController else { return }
            helper.handleReportProductSend(itemId: productId, reason: reason, comment: comment, vc: top)
        }
        top.present(dialog, animated: true, completion: nil)
    }

    func showCheckout(id: UUID, bidId: UUID, orderId: UUID?, backPressed: PaymentCoordinator.BackCallback?) {
        let payment = PaymentCoordinatorImpl(navigationController: navigationController, backPressed: backPressed)
        let paymentInput = PaymentInput(productId: id, bidId: bidId, orderId: orderId)
        payment.start(paymentInput: paymentInput, isBuyNow: true)
    }
}
