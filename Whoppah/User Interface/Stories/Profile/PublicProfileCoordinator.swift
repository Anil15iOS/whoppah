//
//  PublicProfileCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 17/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import TLPhotoPicker
import WhoppahCore
import Photos
import Resolver
import WhoppahDataStore

class PublicProfileCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let model = PublicProfileViewModel(coordinator: self)
        let vc: PublicProfileViewController = UIStoryboard.storyboard(storyboard: .profile).instantiateViewController()
        vc.viewModel = model
        navigationController.pushViewController(vc, animated: true)
    }

    func start(id: UUID) {
        let model = PublicProfileViewModel(coordinator: self,
                                           id: id)
        let vc: PublicProfileViewController = UIStoryboard.storyboard(storyboard: .profile).instantiateViewController()
        vc.viewModel = model
        navigationController.pushViewController(vc, animated: true)
    }

    func editProfile(merchant: LegacyMerchant) {
        let coordinator = EditProfileCoordinator(navigationController: navigationController)
        coordinator.start(merchant: merchant)
    }

    func editProfileAvatar(delegate: ProfileAvatarPickerDelegate?) {
        let vc: ProfileAvatarPickerViewController = UIStoryboard.storyboard(storyboard: .profile).instantiateViewController()
        vc.delegate = delegate
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
        guard let top = navigationController.topViewController else { return }
        top.present(nav, animated: true, completion: nil)
    }

    func editProfileCover(delegate: TLPhotosPickerViewControllerDelegate?) {
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = false
        configure.mediaType = .image
        configure.maxSelectedAssets = 1
        
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

    func showReportMenu(merchantId: UUID) {
        let vc = ReportUserDialog(merchantId: merchantId)
        var helper = ReportServiceHelper()
        vc.sendCallback = { [weak self] merchantId, reason, comment in
            guard let self = self else { return }
            guard let top = self.navigationController.topViewController else { return }
            helper.handleReportMerchantSend(merchantId: merchantId, reason: reason, comment: comment, vc: top)
        }
        guard let top = navigationController.topViewController else { return }
        top.present(vc, animated: true, completion: nil)
    }

    func dismiss() {
        if navigationController.viewControllers.count == 1 {
            guard let top = navigationController.topViewController else { return }
            top.dismiss(animated: true, completion: nil)
        } else {
            navigationController.popViewController(animated: true)
        }
    }
}
