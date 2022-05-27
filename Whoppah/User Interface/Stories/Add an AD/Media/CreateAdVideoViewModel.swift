//
//  CreateAdVideoViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 17/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver

class CreateAdVideoViewModel: CreateAdViewModelBase {
    let coordinator: CreateAdVideoCoordinator
    private let bag = DisposeBag()

    private var snapshot: MediaSnapshot?

    struct Inputs {}

    struct Outputs {
        var buttonTitle: Observable<String> { _buttonTitle.asObservable() }
        fileprivate let _buttonTitle = BehaviorRelay<String>(value: "")

        var video: Observable<AdVideo?> { _video.asObservable() }
        fileprivate let _video = BehaviorRelay<AdVideo?>(value: nil)
    }

    var inputs = Inputs()
    let outputs = Outputs()

    init(coordinator: CreateAdVideoCoordinator) {
        self.coordinator = coordinator
        super.init(coordinator: coordinator)
        snapshot = adCreator.mediaManager.getSnapshot()
        registerForNotifications()
        refreshMediaVideo()
    }

    func next() {
        if case .video = adCreator.validate(step: .video) {
            return
        }
        snapshot = nil
        coordinator.next()
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

    func createVideo() {
        coordinator.openCameraScreen { [weak self] in
            self?.refreshMediaVideo()
        }
        eventTracking.createAd.trackCreateVideoClicked()
    }

    func deleteVideo() {
        adCreator.mediaManager.deleteVideo(forAd: adCreator.template?.id)
    }

    func getBulletText() -> [String] {
        let screenBulletTitle = "create-ad-video"
        return BulletText.fetch(forScreen: screenBulletTitle, categories: adCreator.template!.categories)
    }

    // MARK: Privates

    private func registerForNotifications() {
        NotificationCenter.default.rx.notification(adVideoUpdated, object: nil).subscribe(onNext: { [weak self] _ in
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

extension CreateAdVideoViewModel {
    private func refreshMediaVideo() {
        outputs._video.accept(adCreator.mediaManager.videoSlot)
    }
}
