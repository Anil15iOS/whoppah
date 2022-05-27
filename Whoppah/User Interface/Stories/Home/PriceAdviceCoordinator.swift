//
//  PriceAdviceCoordinator.swift
//  Whoppah
//
//  Created by Jose Camallonga on 11/05/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import OpalImagePicker

class PriceAdviceCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        childCoordinators = [Coordinator]()
        self.navigationController = navigationController
    }

    func start() {
        let vc = PriceAdviceViewController(nibName: nil, bundle: nil)
        vc.viewModel = PriceAdviceViewModel(coordinator: self)
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { navigationController.modalPresentationStyle = .fullScreen }
        self.navigationController.present(navigationController, animated: true, completion: nil)
    }

    func selectExistingPhotos(_ delegate: OpalImagePickerControllerDelegate) {
        guard let top = navigationController.visibleViewController else { return }
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 1
        imagePicker.allowedMediaTypes = [.image]
        imagePicker.imagePickerDelegate = delegate
        imagePicker.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { imagePicker.modalPresentationStyle = .fullScreen }
        top.present(imagePicker, animated: true, completion: nil)
    }

    func openCameraScreen(onClose: (() -> Void)?) {
        let nav = WhoppahNavigationController()
        nav.isNavigationBarHidden = true
        nav.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
        let coordinator = CreateAdCameraCoordinatorImpl(navigationController: nav, mode: .photo)
        coordinator.start(onClose: onClose)
        guard let top = navigationController.visibleViewController else { return }
        top.present(nav, animated: true, completion: nil)
    }

    func showInvalidMedia() {
        guard let top = navigationController.visibleViewController else { return }
        let invalidMedia: InvalidMediaViewController = UIStoryboard(storyboard: .addAnAD).instantiateViewController()
        invalidMedia.mediaType = .image
        top.navigationController?.pushViewController(invalidMedia, animated: true)
    }

    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
