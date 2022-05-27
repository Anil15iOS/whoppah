//
//  CreateAdVideoViewController.swift
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
import Resolver

class CreateAdVideoViewController: CreateAdViewControllerBase {
    var viewModel: CreateAdVideoViewModel!
    @Injected var adCreator: ADCreator

    override func viewDidLoad() {
        super.viewDidLoad()

        analyticsKey = "AdCreation_VideoSection"
        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.createAdVideoTitle())
        root.addSubview(title)
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let mediaBannerViewContainer = ViewFactory.createView()
        root.addSubview(mediaBannerViewContainer)
        mediaBannerViewContainer.pinToEdges(of: root, orientation: .horizontal)
        mediaBannerViewContainer.alignBelow(view: title, withPadding: 16)

        let banner = createBanner()
        mediaBannerViewContainer.addSubview(banner.root)
        banner.root.pinToEdges(of: root, orientation: .horizontal)
        banner.root.verticalPin(to: mediaBannerViewContainer, orientation: .top)

        let bottomBannerConstraint = mediaBannerViewContainer.verticalPin(to: banner.root, orientation: .bottom)

        // Video
        let mediaVideo = ViewFactory.createMediaView()
        mediaVideo.showScrubber = true
        mediaBannerViewContainer.addSubview(mediaVideo)
        mediaVideo.verticalPin(to: mediaBannerViewContainer, orientation: .top)
        mediaVideo.horizontalPin(to: mediaBannerViewContainer, orientation: .leading)
        let screenWidth = UIScreen.main.bounds.width
        let videoSize = screenWidth
        mediaVideo.setSize(videoSize, videoSize)
        let bottomMediaVideoConstraint = mediaVideo.verticalPin(to: mediaBannerViewContainer, orientation: .bottom)
        bottomMediaVideoConstraint.isActive = false

        viewModel.outputs.video
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] video in
                let hasVideo = video != nil
                bottomBannerConstraint.isActive = hasVideo
                bottomMediaVideoConstraint.isActive = hasVideo
                banner.root.isHidden = hasVideo
                mediaVideo.isHidden = !hasVideo
                UIView.animate(withDuration: 0.1) {
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: bag)

        viewModel.outputs.video.compactMap { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] video in
                switch video {
                case let .new(data, _, _):
                    mediaVideo.configure(data: data)
                case let .existing(_, data, _, path):
                    if let data = data {
                        mediaVideo.configure(data: data)
                    } else {
                        guard let url = path else { return }
                        mediaVideo.configure(videoUrl: url)
                    }
                }

                UIView.animate(withDuration: 0.1) {
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: bag)

        let trashButton = ViewFactory.createButton(image: R.image.ic_trash_blue())
        mediaVideo.addSubview(trashButton)
        trashButton.setSize(24, 24)
        trashButton.verticalPin(to: mediaVideo, orientation: .top, padding: 4)
        trashButton.horizontalPin(to: mediaVideo, orientation: .trailing, padding: -4)
        trashButton.rx.tap.bind { [weak self] in
            self?.viewModel.deleteVideo()
        }.disposed(by: bag)

        let addVideoButton = ViewFactory.createSecondaryButton(text: "",
                                                               icon: R.image.createAdMovieButton(),
                                                               buttonColor: R.color.shinyBlue())
        root.addSubview(addVideoButton)
        viewModel.outputs.buttonTitle.bind(to: addVideoButton.rx.title(for: .normal)).disposed(by: bag)

        addVideoButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        let bannerConstraint = addVideoButton.alignBelow(view: banner.root, withPadding: 24)
        let mediaViewConstraint = addVideoButton.alignBelow(view: mediaVideo, withPadding: 40)
        mediaViewConstraint.isActive = false

        addVideoButton.analyticsKey = "CreateNewVideo"
        addVideoButton.setHeightAnchor(UIConstants.buttonHeight)
        addVideoButton.rx.tap.bind { [weak self] in
            self?.viewModel.createVideo()
        }.disposed(by: bag)

        let bulletsView = ViewFactory.getBulletsView(title: R.string.localizable.createAdVideoBulletTitle(),
                                                     bullets: viewModel.getBulletText())
        let bulletTitle = bulletsView.0
        let bullets = bulletsView.1

        root.addSubview(bulletTitle)
        bulletTitle.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        bulletTitle.alignBelow(view: addVideoButton, withPadding: 16)

        root.addSubview(bullets)
        bullets.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        bullets.alignBelow(view: bulletTitle, withPadding: 6)

        let buttonText = nextButtonText(viewModel, R.string.localizable.commonNextStepButton())
        let nextButton = ViewFactory.createPrimaryButton(text: buttonText)
        nextButton.analyticsKey = "NextStep"
        root.addSubview(nextButton)
        nextButton.alignBelow(view: bullets, withPadding: 40)
        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.next()
        }.disposed(by: bag)

        viewModel.outputs.video
            .map { $0 != nil }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] hasVid in
                guard let self = self else { return }
                mediaVideo.isVisible = hasVid
                banner.root.isVisible = !hasVid
                bannerConstraint.isActive = !hasVid
                mediaViewConstraint.isActive = hasVid
                addVideoButton.setTitle(hasVid ? R.string.localizable.createAdVideoReplaceVideoButton() : R.string.localizable.createAdVideoNewVideoButton(), for: .normal)
                nextButton.setTitle(hasVid ? R.string.localizable.createAdVideoSaveNextButton() : R.string.localizable.commonSkipButton(), for: .normal)
                self.view.updateConstraints()
                UIView.animate(withDuration: 0.1) {
                    self.view.layoutIfNeeded()
                }
            }).disposed(by: bag)

        root.verticalPin(to: nextButton, orientation: .bottom, padding: UIConstants.margin)

        addCloseButtonIfRequired(viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNavBar(title: R.string.localizable.createAdCommonYourAdTitle(),
                  enabled: true,
                  transparent: false)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        viewModel.onDismiss()
    }

    private func createBanner() -> ViewFactory.BannerView {
        ViewFactory.createTextBanner(title: R.string.localizable.createAdVideoNoVideoBannerTitle())
    }
}
