//
//  PriceAdviceViewModel.swift
//  Whoppah
//
//  Created by Jose Camallonga on 11/05/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import OpalImagePicker
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver

class PriceAdviceViewModel {
    private let coordinator: PriceAdviceCoordinator
    private let bag = DisposeBag()

    @Injected var adCreator: ADCreator
    let inputs = Inputs()
    let outputs = Outputs()

    struct Inputs {
        let camera = PublishSubject<Void>()
        let select = PublishSubject<Void>()
        let delete = PublishSubject<Void>()
    }

    struct Outputs {
        let image = BehaviorSubject<UIImage?>(value: nil)
    }

    init(coordinator: PriceAdviceCoordinator) {
        self.coordinator = coordinator
        setupInputs()
    }

    func dismiss() {
        coordinator.dismiss()
    }
}

// MARK: - Private

private extension PriceAdviceViewModel {
    func setupInputs() {
        inputs.camera.bind { [weak self] _ in self?.openCameraScreen() }.disposed(by: bag)
        inputs.select.bind { [weak self] _ in self?.selectExistingPhotos() }.disposed(by: bag)
        inputs.delete.bind { [weak self] _ in self?.removePhoto() }.disposed(by: bag)
    }

    func removePhoto() {
        adCreator.mediaManager.deletePhoto(atIndex: 0, forAd: adCreator.template?.id)
        outputs.image.onNext(nil)
    }

    func selectExistingPhotos() {
        coordinator.selectExistingPhotos(self)
    }

    func openCameraScreen() {
        coordinator.openCameraScreen { [weak self] in
            let photoViewModel = self?.adCreator.mediaManager.getPhotoCellViewModel(0)
            if case let .photo(image) = photoViewModel?.state {
                self?.outputs.image.onNext(image)
            }
        }
    }
}

// MARK: - OpalImagePickerControllerDelegate

extension PriceAdviceViewModel: OpalImagePickerControllerDelegate {
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        picker.dismiss(animated: true, completion: { [weak self] in
            guard let self = self, let image = images.first else { return }
            if image.size.width < 2500, image.size.height < 2500,
                let jpeg = image.jpegData(compressionQuality: 1.0), Double(jpeg.count) < ProductConfig.minimumImageSizeMB {
                DispatchQueue.main.async { self.coordinator.showInvalidMedia() }
            } else {
                let downsizedImage = image.scaledToMaxWidth(CGFloat(ProductConfig.maxImageLengthPixels))
                self.adCreator.mediaManager.addPhoto(AdPhoto.new(data: downsizedImage))
                self.outputs.image.onNext(downsizedImage)
            }
        })
    }
}
