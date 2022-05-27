//
//  ChatCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 25/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import TLPhotoPicker
import Photos
import Resolver

class ChatCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    @Injected private var eventTracking: EventTrackingService

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func dismiss(_: Bool = false) {
        guard let top = navigationController.topViewController else { return }
        top.dismiss(animated: true) { [weak self] in
            self?.openReviewDialog()
        }
    }

    func openProfile(_ id: UUID) {
        Navigator().navigate(route: Navigator.Route.userProfile(id: id))
    }

    func openAskTrackingCode(_ delegate: TrackCodeDialogDelegate, orderId: UUID) {
        guard let top = navigationController.topViewController else { return }
        let askSentDialog = YesNoDialog.create(withMessage: R.string.localizable.askSentItemBody(),
                                               andTitle: R.string.localizable.commonDialogTitle())
        askSentDialog.noText = R.string.localizable.askSentItemNo()
        askSentDialog.yesText = R.string.localizable.askSentItemYes()
        askSentDialog.onButtonPressed = { button in
            if button == .yes {
                let dialog = TrackCodeDialog()
                dialog.delegate = delegate
                dialog.orderId = orderId
                top.present(dialog, animated: true, completion: nil)
            }
        }
        top.present(askSentDialog, animated: true, completion: nil)
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

    func openReviewDialog() {
        guard let top = navigationController.topViewController, let tabsVC = top.getTabsVC() else { return }
        RequestReviewDialog.create(fromVC: tabsVC, eventTracking: eventTracking)
    }

    func openPaymentCompletedDialog(_ delegate: PaymentConfirmationDialogDelegate) {
        let dialog = PaymentConfirmationDialog()
        dialog.delegate = delegate
        dialog.onComplete = { [weak self] in
            self?.openReviewDialog()
        }
        navigationController.present(dialog, animated: true, completion: nil)
    }

    func openPayment(input: PaymentInput, isBuyNow: Bool, delegate: PaymentDelegate) {
        guard let top = navigationController.topViewController else { return }
        guard let nav = top.navigationController else { return }
        
        if isBuyNow {
            eventTracking.trackBeginCheckout(source: .chatBuyBow)
        } else {
            eventTracking.trackBeginCheckout(source: .chatAcceptBid)
        }
        
        let coordinator = PaymentCoordinatorImpl(navigationController: nav, backPressed: nil)
        coordinator.start(paymentInput: input, isBuyNow: isBuyNow, delegate: delegate)
    }

    func openPaymentFailedDialog(input: PaymentInput, isBuyNow: Bool, delegate: PaymentDelegate) {
        let dialog = PaymentFailedDialog()
        dialog.onPaymentButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.openPayment(input: input, isBuyNow: isBuyNow, delegate: delegate)
        }
        navigationController.present(dialog, animated: true, completion: nil)
    }

    func openProductReceivedConfirmationDialog(received: Bool) {
        let dialog = ResultConfirmationReceiptDialog()
        dialog.received = received
        let navVC = UINavigationController(rootViewController: dialog)
        navVC.isNavigationBarHidden = true
        navigationController.present(navVC, animated: true, completion: nil)
    }

    func selectPhoto(delegate: TLPhotosPickerViewControllerDelegate?) {
        var configure = TLPhotosPickerConfigure()
        configure.maxSelectedAssets = 1
        configure.mediaType = .image
        configure.usedCameraButton = false
      
        let imagePicker = TLPhotosPickerViewController()
        imagePicker.configure = configure
        imagePicker.delegate = delegate
        
        imagePicker.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { imagePicker.modalPresentationStyle = .fullScreen }
        guard let top = navigationController.topViewController else { return }
        top.present(imagePicker, animated: true, completion: nil)
        
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == PHAuthorizationStatus.limited {
            imagePicker.presentAlert(title: "", message: R.string.localizable.photo_gallery_limited_access_message())
        }
    }

    func selectCamera(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            // Could display some error here if needed
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        guard let top = navigationController.topViewController else { return }
        top.present(imagePicker, animated: true, completion: nil)
    }
}
