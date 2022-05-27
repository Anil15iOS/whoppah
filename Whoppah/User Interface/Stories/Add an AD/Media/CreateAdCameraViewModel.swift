//
//  CreateAdCameraViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 03/02/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import TLPhotoPicker
import Resolver

class CreateAdCameraViewModel {
    enum CameraMode {
        case photo
        case video
    }

    @Injected private var adCreator: ADCreator
    @Injected private var eventTracking: EventTrackingService
    let coordinator: CreateAdCameraCoordinator
    private var snapshot: MediaSnapshot?

    private let bag = DisposeBag()

    struct Inputs {}

    private(set) var mode: CameraMode
    var isEditing: Bool {
        guard case .edit = adCreator.mode else { return false }
        return true
    }

    struct Outputs {
        var mediaCells: Observable<[MediaCellViewModel]> { _mediaCells.asObservable() }
        fileprivate let _mediaCells = BehaviorRelay<[MediaCellViewModel]>(value: [])

        var cameraButtonEnabled: Observable<Bool> { _cameraButtonEnabled.asObservable() }
        fileprivate let _cameraButtonEnabled = BehaviorRelay<Bool>(value: false)
    }

    var inputs = Inputs()
    let outputs = Outputs()

    init(coordinator: CreateAdCameraCoordinator, mode: CameraMode) {
        self.coordinator = coordinator
        self.mode = mode

        snapshot = adCreator.mediaManager.getSnapshot()
        setupNotifications()
        updateCells()
    }

    func dismiss() {
        if let snapshot = snapshot {
            adCreator.mediaManager.restoreSnapshot(snapshot)
        }

        coordinator.dismiss()
    }

    func next() {
        snapshot = nil
        coordinator.dismiss()
    }

    func openGallery(delegate: TLPhotosPickerViewControllerDelegate) {
        coordinator.openGallery(delegate: delegate)
    }

    private func updateCells() {
        var cells = [MediaCellViewModel]()
        guard let mediaManager = adCreator.mediaManager else { return }
        let photoCount = mediaManager.photoCount
        switch mode {
        case .photo:
            if photoCount > 0 {
                for i in 0 ... photoCount - 1 {
                    guard let cell = mediaManager.getPhotoCellViewModel(i) else { continue }
                    cells.append(cell)
                }
            }
            outputs._cameraButtonEnabled.accept(!mediaManager.hasMaxPhotos)
        case .video:
            if let cell = mediaManager.getVideoCellViewModel(0) {
                cells.append(cell)
            }
            outputs._cameraButtonEnabled.accept(true)
        }
        outputs._mediaCells.accept(cells)
    }

    private func setupNotifications() {
        NotificationCenter.default.rx.notification(adPhotoUpdated, object: nil).subscribe(onNext: { [weak self] _ in
            self?.refreshMediaVideo()
        }).disposed(by: bag)
        NotificationCenter.default.rx.notification(adVideoUpdated, object: nil).subscribe(onNext: { [weak self] _ in
            self?.refreshMediaVideo()
        }).disposed(by: bag)
        NotificationCenter.default.rx.notification(adMediaError, object: nil).subscribe(onNext: { [weak self] notification in
            self?.showMediaFetchError(notification)
        }).disposed(by: bag)
        NotificationCenter.default.addObserver(self, selector: #selector(showMediaFetchError(_:)), name: adMediaError, object: nil)
    }

    @objc private func refreshMediaVideo() {
        updateCells()
    }

    @objc private func showMediaFetchError(_ notification: Notification) {
        if let userInfo = notification.userInfo, let message = userInfo["message"] as? String {
            let error = UserMessageError(message: message)
            coordinator.showError(error)
        }
    }
}

extension CreateAdCameraViewModel {
    func selectViewModel(atPath path: IndexPath, videoFilePath: URL?, viewModel _: MediaCellViewModel) {
        switch mode {
        case .photo:
            selectPhoto(atPath: path)
        case .video:
            selectVideo(atPath: path, videoFilePath: videoFilePath)
        }
    }

    func shouldSelectItem(at path: IndexPath) -> Bool {
        switch mode {
        case .photo:
            return adCreator.mediaManager.canSelectPhoto(path.row)
        case .video:
            return true
        }
    }

    private func selectPhoto(atPath path: IndexPath) {
        guard let photo = adCreator.mediaManager.getPhoto(atPath: path) else { return }
        coordinator.didSelectPhoto(atPath: path, photo: photo, delegate: self)
    }

    private func selectVideo(atPath _: IndexPath, videoFilePath: URL?) {
        guard let video = adCreator.mediaManager.getVideo() else { return }
        coordinator.didSelectVideo(video: video, videoFilePath: videoFilePath, delegate: self)
    }
}

extension CreateAdCameraViewModel {
    func addPhoto(_ photo: AdPhoto) {
        adCreator.mediaManager.addPhoto(photo)
        updateCells()
    }

    func onImagesPicked(_ images: [UIImage]) {
        DispatchQueue.global().async {
            for image in images {
                // Scale down to reduce bandwidth
                let downsizedImage = image.scaledToMaxWidth(CGFloat(ProductConfig.maxImageLengthPixels)) // Threadsafe!
                self.addPhoto(AdPhoto.new(data: downsizedImage))
                self.updateCells()
            }
        }
    }

    func deleteMedia(atPath path: IndexPath) {
        switch mode {
        case .video:
            adCreator.mediaManager.deleteVideo(forAd: adCreator.template?.id)
        case .photo:
            adCreator.mediaManager.deletePhoto(atIndex: path.row, forAd: adCreator.template?.id)
        }
        updateCells()
    }

    func cameraTip() -> String? {
        var text: String?
        switch adCreator.mediaManager.photoCount {
        case 1:
            text = R.string.localizable.create_ad_camera_tip_1()
        case 2:
            text = R.string.localizable.create_ad_camera_tip_2()
        case 3:
            text = R.string.localizable.create_ad_camera_tip_3()
        case 4:
            text = R.string.localizable.create_ad_camera_tip_4()
        case 5:
            text = R.string.localizable.create_ad_camera_tip_5()
        case 6:
            text = R.string.localizable.create_ad_camera_tip_6()
        case 7:
            text = R.string.localizable.create_ad_camera_tip_7()
        case 8:
            text = R.string.localizable.create_ad_camera_tip_8()
        case 9:
            text = R.string.localizable.create_ad_camera_tip_9()
        case 10:
            text = R.string.localizable.create_ad_camera_tip_10()
        case 11:
            text = R.string.localizable.create_ad_camera_tip_11()
        case 12:
            text = R.string.localizable.create_ad_camera_tip_12()
        case 13:
            text = R.string.localizable.create_ad_camera_tip_13()
        case 14:
            text = R.string.localizable.create_ad_camera_tip_14()
        case 15:
            text = R.string.localizable.create_ad_camera_tip_15()
        default:
            text = nil
        }
        guard text?.isEmpty == false else { return nil }
        return text
    }
}

extension CreateAdCameraViewModel: MediaReviewDelegate {
    func photoDeleted(_: AdPhoto, atPath: IndexPath?) {
        if let index = atPath {
            switch mode {
            case .photo:
                adCreator.mediaManager.deletePhoto(atIndex: index.row, forAd: adCreator.template?.id)
            case .video:
                adCreator.mediaManager.deleteVideo(forAd: adCreator.template?.id)
            }
            updateCells()
        }
    }

    func photoAccepted(_: AdPhoto, atPath _: IndexPath?) {
        // Nothing to do
    }

    func videoDeleted(_: AdVideo) {
        adCreator.mediaManager.deleteVideo(forAd: adCreator.template?.id)
        updateCells()
    }

    func videoAccepted(_ video: AdVideo) {
        video.removeTemporaryVideo()
    }
}
