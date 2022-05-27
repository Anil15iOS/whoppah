//
//  ThreadCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 02/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit
import WhoppahCore
import Resolver

class ThreadCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private var chatViewController: ChatViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(threadID: UUID, insertAtIndex: Int? = nil, route: Navigator.Route? = nil) {
        let threadVC: ThreadViewController = UIStoryboard.storyboard(storyboard: .chat).instantiateViewController()
        let chat: ChatViewController = UIStoryboard.storyboard(storyboard: .chat).instantiateViewController()
        let threadRepo = ThreadRepositoryImpl()
        threadVC.viewModel = ThreadViewModel(threadID: threadID,
                                             repo: threadRepo,
                                             coordinator: self)
        if let index = insertAtIndex {
            navigationController.viewControllers.insert(threadVC, at: index)
        } else {
            navigationController.pushViewController(threadVC, animated: true)
        }
        let messageRepo = ThreadMessageRepositoryImpl(threadId: threadID)
        let coordinator = ChatCoordinator(navigationController: navigationController)
        chat.viewModel = ChatViewModel(coordinator: coordinator,
                                       threadRepo: threadRepo,
                                       messageRepo: messageRepo)
        chatViewController = chat

        chatViewController?.route = route
    }

    func getAndClearChatVC() -> UIViewController? {
        defer {
            chatViewController = nil
        }
        return chatViewController
    }

    func reportUser(userID: UUID) {
        let vc = ReportUserDialog(merchantId: userID)
        var helper = ReportServiceHelper()
        vc.sendCallback = { [weak self] merchantId, reason, comment in
            guard let self = self else { return }
            guard let top = self.navigationController.topViewController else { return }
            helper.handleReportMerchantSend(merchantId: merchantId, reason: reason, comment: comment, vc: top)
        }
        guard let top = navigationController.topViewController else { return }
        top.present(vc, animated: true, completion: nil)
    }

    func reportProduct(itemID: UUID) {
        guard let top = navigationController.topViewController else { return }
        let dialog = ReportProductDialog(itemId: itemID)
        var helper = ReportServiceHelper()
        dialog.sendCallback = { [weak self] productId, reason, comment in
            guard let self = self else { return }
            guard let top = self.navigationController.topViewController else { return }
            helper.handleReportProductSend(itemId: productId, reason: reason, comment: comment, vc: top)
        }
        top.present(dialog, animated: true, completion: nil)
    }

    func showMore(reportUser: Bool, reportProduct: Bool) {
        guard let vc = navigationController.topViewController else { return }
        guard let delegate = vc as? ReportDialogDelegate else { return }
        let reportDialog = ReportDialog()
        reportDialog.reportUser = reportUser
        reportDialog.reportProduct = reportProduct
        reportDialog.delegate = delegate
        vc.present(reportDialog, animated: true, completion: nil)
    }
    
    func showDeliveryInfo(data: DeliveryUIData) {
        guard let top = navigationController.topViewController else { return }
        let dialog = DeliveryInfoDialog.create(with: data)

        top.present(dialog, animated: true, completion: nil)
    }

    func showHowItWorks() {
        guard let top = navigationController.topViewController else { return }
        let dialog = HowItWorksDialog()

        top.present(dialog, animated: true, completion: nil)
    }
    
    func showHelp() {
        let coordinator = HelpCoordinatorImpl(navigationController: navigationController)
        let config = HelpConfig(navTitle: R.string.localizable.chatHelpScreenTitle(),
                                title: R.string.localizable.chatHelpTitle(),
                                mode: .bullets,
                                prefix: "chat-help")
        coordinator.start(withConfig: config)
    }

    func dismiss() {
        navigationController.popToRootViewController(animated: true)
    }

    func openAd(adID: UUID) {
        Navigator().navigate(route: Navigator.Route.ad(id: adID))
    }

    func openProfile(id: UUID) {
        Navigator().navigate(route: Navigator.Route.userProfile(id: id))
    }
}
