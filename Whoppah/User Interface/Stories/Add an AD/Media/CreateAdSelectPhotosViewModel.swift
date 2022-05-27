//
//  CreateAdSelectPhotoViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 17/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import OpalImagePicker
import RxCocoa
import RxSwift
import WhoppahCore
import TLPhotoPicker
import Resolver

class CreateAdSelectPhotosViewModel: CreateAdViewModelBase {
    private let bag = DisposeBag()
    let coordinator: CreateAdSelectPhotosCoordinator

    private var snapshot: MediaSnapshot?

    struct Inputs {}

    struct Outputs {
        var mediaCells: Observable<[SelectPhotoMediaCellViewModel]> { _mediaCells.asObservable() }
        fileprivate let _mediaCells = BehaviorRelay<[SelectPhotoMediaCellViewModel]>(value: [])

        var mediaError: Observable<Bool> { _mediaError.asObservable() }
        fileprivate let _mediaError = BehaviorRelay<Bool>(value: false)

        var saveEnabled: Observable<Bool> { _saveEnabled.asObservable() }
        fileprivate let _saveEnabled = BehaviorRelay<Bool>(value: true)
    }

    var inputs = Inputs()
    let outputs = Outputs()

    init(coordinator: CreateAdSelectPhotosCoordinator) {
        self.coordinator = coordinator
        super.init(coordinator: coordinator)
    }

    func load() {
        snapshot = adCreator.mediaManager.getSnapshot()
        registerForNotifications()
        // Don't display an error when we first enter the screen when creating
        switch adCreator.mode {
        case .edit:
            updateCells(true)
        default:
            updateCells(false)
        }
    }

    override func close() {
        super.close()
        onDismiss()
    }

    func onDismiss() {
        if let snapshot = snapshot {
            adCreator.mediaManager.restoreSnapshot(snapshot)
        }
        eventTracking.createAd.trackBackPressedAdCreation()
    }

    func openCameraScreen() {
        coordinator.openCameraScreen { [weak self] in self?.updateCells() }
    }

    func getBulletText() -> [String] {
        let screenBulletTitle = "create-ad-select-photos"
        return BulletText.fetch(forScreen: screenBulletTitle, categories: adCreator.template!.categories)
    }

    func next() {
        if case .photos = adCreator.validate(step: .photos) {
            outputs._mediaError.accept(true)
            outputs._saveEnabled.accept(false)
            return
        }
        snapshot = nil
        coordinator.next()
    }

    // MARK: Privates

    private func registerForNotifications() {
        NotificationCenter.default.rx.notification(adPhotoUpdated, object: nil).subscribe(onNext: { [weak self] _ in
            self?.refreshMediaVideo()
        }).disposed(by: bag)
        NotificationCenter.default.rx.notification(adMediaChanged, object: nil).subscribe(onNext: { [weak self] _ in
            self?.refreshMediaVideo()
        }).disposed(by: bag)
        NotificationCenter.default.rx.notification(adMediaError, object: nil).subscribe(onNext: { [weak self] notification in
            self?.showMediaFetchError(notification)
        }).disposed(by: bag)
    }

    @objc private func showMediaFetchError(_ notification: Notification) {
        if let userInfo = notification.userInfo, let message = userInfo["message"] as? String {
            coordinator.showError(UserMessageError(message: message))
        }
    }
}

extension CreateAdSelectPhotosViewModel {
    func canSelectPhoto(_ row: Int) -> Bool {
        row < adCreator.mediaManager.photoCount
    }

    func addPhoto(adPhoto: AdPhoto) {
        adCreator.mediaManager.addPhoto(adPhoto)
        updateCells()
    }

    func removePhoto(at: Int) {
        adCreator.mediaManager.deletePhoto(atIndex: at, forAd: adCreator.template?.id)
        updateCells()
    }

    func cropPhoto(at: Int) {
        coordinator.cropPhoto(index: at)
    }

    func movePhoto(from: Int, to: Int) {
        adCreator.mediaManager.movePhoto(from: from, to: to)
        updateCells()
    }

    func canMovePhoto(at: Int) -> Bool {
        adCreator.mediaManager.canMovePhoto(at: at)
    }

    func canMovePhoto(at: Int, to: Int) -> Bool {
        adCreator.mediaManager.canMovePhoto(at: at, to: to)
    }

    func selectExistingPhotos(_ delegate: TLPhotosPickerViewControllerDelegate) {
        coordinator.selectExistingPhotos(delegate)
    }

    private func refreshMediaVideo() {
        updateCells()
    }

    private func updateCells(_ displayError: Bool = true) {
        var cells = [SelectPhotoMediaCellViewModel]()
        let photoCount = adCreator.mediaManager.photoCount
        if photoCount > 0 {
            for i in 0 ... photoCount - 1 {
                cells.append(adCreator.mediaManager.getSelectPhotoCellViewModel(i))
            }
        }
        outputs._mediaCells.accept(cells)
        outputs._saveEnabled.accept(adCreator.mediaManager.hasEnoughPhotos)

        if displayError {
            if adCreator.mediaManager.hasEnoughPhotos {
                outputs._mediaError.accept(false)
            } else {
                outputs._mediaError.accept(true)
            }
        }
    }
}
