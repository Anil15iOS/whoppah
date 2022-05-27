//
//  CreateAdCameraCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 03/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahCoreNext
import TLPhotoPicker
import Photos
import Resolver

protocol CreateAdCameraCoordinator: Coordinator {
    func didSelectPhoto(atPath indexPath: IndexPath, photo: AdPhoto, delegate: MediaReviewDelegate?)
    func didSelectVideo(video: AdVideo, videoFilePath: URL?, delegate: MediaReviewDelegate?)

    typealias OnCloseCallback = (() -> Void)
    func start(onClose: OnCloseCallback?)
    func next()
    func dismiss()
    func showNoPermissionDialog()
    func openGallery(delegate: TLPhotosPickerViewControllerDelegate)
    func showPoorMediaView(type: InvalidMediaViewController.MediaType)
}

class CreateAdCameraCoordinatorImpl: CreateAdCameraCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let mode: CreateAdCameraViewModel.CameraMode
    var onClose: OnCloseCallback?
    
    @Injected private var adCreator: ADCreator
    
    required init(navigationController: UINavigationController, mode: CreateAdCameraViewModel.CameraMode) {
        self.navigationController = navigationController
        self.mode = mode
    }

    func start(onClose: OnCloseCallback?) {
        self.onClose = onClose
        let vc: CreateAdCameraViewController = UIStoryboard.storyboard(storyboard: .addAnAD).instantiateViewController()
        vc.viewModel = CreateAdCameraViewModel(coordinator: self, mode: mode)
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss() {
        onClose?()
        guard let top = navigationController.topViewController else { return }
        top.dismiss(animated: true, completion: {
            self.navigationController.viewControllers.removeAll()
        })
    }

    func showNoPermissionDialog() {
        let dialog = MissingPermissionDialog.create(forPermission: MissingPermissionType.camera)
        guard let top = navigationController.topViewController else { return }
        top.present(dialog, animated: true, completion: nil)
    }

    func didSelectPhoto(atPath indexPath: IndexPath, photo: AdPhoto, delegate: MediaReviewDelegate?) {
        let reviewVC: MediaReviewViewController = UIStoryboard.storyboard(storyboard: .addAnAD).instantiateViewController()
        reviewVC.delegate = delegate
        reviewVC.photoIndexPath = indexPath
        reviewVC.photo = photo
        guard let top = navigationController.topViewController else { return }
        top.present(reviewVC, animated: true, completion: nil)
    }

    func didSelectVideo(video: AdVideo, videoFilePath: URL? = nil, delegate: MediaReviewDelegate?) {
        let reviewVC: MediaReviewViewController = UIStoryboard.storyboard(storyboard: .addAnAD).instantiateViewController()
        reviewVC.delegate = delegate
        reviewVC.videoFileUrl = videoFilePath
        reviewVC.video = video
        guard let top = navigationController.topViewController else { return }
        top.present(reviewVC, animated: true, completion: nil)
    }

    func next() {}

    func openGallery(delegate: TLPhotosPickerViewControllerDelegate) {
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = false
        configure.mediaType = .image
        configure.maxSelectedAssets = adCreator.mediaManager.maxPhotoSelectionAllowed
        
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

    func showPoorMediaView(type: InvalidMediaViewController.MediaType) {
        let invalidMedia: InvalidMediaViewController = UIStoryboard(storyboard: .addAnAD).instantiateViewController()
        invalidMedia.mediaType = type
        navigationController.pushViewController(invalidMedia, animated: true)
    }
}
