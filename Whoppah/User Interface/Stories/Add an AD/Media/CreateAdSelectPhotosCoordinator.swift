//
//  SelectPhotosCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 17/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import OpalImagePicker
import WhoppahCore
import WhoppahCoreNext
import TLPhotoPicker
import Photos
import Resolver

protocol CreateAdSelectPhotosCoordinator: CreateAdBaseCoordinator {
    func start()
    func next()
    func openCameraScreen(onClose: (() -> Void)?)
    func selectExistingPhotos(_ delegate: TLPhotosPickerViewControllerDelegate)
    func cropPhoto(index: Int)
}

class CreateAdSelectPhotosCoordinatorImpl: CreateAdSelectPhotosCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let mode: CreateAdStepMode
    @Injected private var adCreator: ADCreator
    
    required init(navigationController: UINavigationController, mode: CreateAdStepMode) {
        self.navigationController = navigationController
        self.mode = mode
    }

    func start() {
        let vc = CreateAdSelectPhotosViewController()
        vc.viewModel = CreateAdSelectPhotosViewModel(coordinator: self)
        navigationController.pushViewController(viewController: vc, animated: true, completion: nil)
    }

    func next() {
        switch mode {
        case .flow:
            let coordinator = CreateAdVideoCoordinatorImpl(navigationController: navigationController, mode: .flow)
            coordinator.start()
        case .pop:
            navigationController.popViewController(animated: true)
        case .dismiss:
            dismiss()
        }
    }

    func openCameraScreen(onClose: (() -> Void)?) {
        let nav = WhoppahNavigationController()
        nav.isNavigationBarHidden = true
        nav.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
        let coordinator = CreateAdCameraCoordinatorImpl(navigationController: nav, mode: .photo)
        coordinator.start(onClose: onClose)
        guard let top = navigationController.topViewController else { return }
        top.present(nav, animated: true, completion: nil)
    }

    func selectExistingPhotos(_ delegate: TLPhotosPickerViewControllerDelegate) {
        guard let top = navigationController.topViewController else { return }
        
        var configure = TLPhotosPickerConfigure()
        configure.usedCameraButton = false
        configure.mediaType = .image
        configure.maxSelectedAssets = adCreator.mediaManager.maxPhotoSelectionAllowed
       
        let imagePicker = TLPhotosPickerViewController()
        imagePicker.configure = configure
        imagePicker.delegate = delegate
   
        imagePicker.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { imagePicker.modalPresentationStyle = .fullScreen }
        top.present(imagePicker, animated: true, completion: nil)
      
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == PHAuthorizationStatus.limited {
            imagePicker.presentAlert(title: "", message: R.string.localizable.photo_gallery_limited_access_message())
        }
    }

    func cropPhoto(index: Int) {
        let coordinator = CreateAdCropPhotoCoordinator(navigationController: navigationController, photoIndex: index)
        coordinator.start()
    }
}
