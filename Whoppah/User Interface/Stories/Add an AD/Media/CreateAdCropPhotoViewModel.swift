//
//  CreateAdCropPhotoViewModel.swift
//  Whoppah
//
//  Created by Jose Camallonga on 23/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import Resolver

class CreateAdCropPhotoViewModel {
    private let bag = DisposeBag()
    private let coordinator: CreateAdCropPhotoCoordinator
    private var snapshot: MediaSnapshot?
    private let photoIndex: Int
    @Injected var adCreator: ADCreator

    let inputs = Inputs()
    let outputs = Outputs()

    struct Inputs {
        let save = PublishSubject<UIImage?>()
    }

    struct Outputs {
        let image = PublishSubject<AdPhoto>()
    }

    init(coordinator: CreateAdCropPhotoCoordinator, photoIndex: Int) {
        self.coordinator = coordinator
        self.photoIndex = photoIndex
        snapshot = adCreator.mediaManager.getSnapshot()
    }

    func load() {
        setupInputs()
        setupOutputs()
    }

    func close() {
        coordinator.dismiss()
    }
}

private extension CreateAdCropPhotoViewModel {
    func setupInputs() {
        inputs.save.subscribe(onNext: { [weak self] image in
            guard let self = self, let image = image else { return }
            self.adCreator.mediaManager.replacePhoto(.new(data: image), at: self.photoIndex)
            self.coordinator.dismiss()
        }).disposed(by: bag)
    }

    func setupOutputs() {
        guard let image = adCreator.mediaManager.getOriginalPhoto(atPath: IndexPath(row: photoIndex, section: 0))
            ?? adCreator.mediaManager.getPhoto(atPath: IndexPath(row: photoIndex, section: 0))
        else { return }
        outputs.image.onNext(image)
    }
}
