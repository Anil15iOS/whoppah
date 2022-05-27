//
//  CreateAdHowItWorksViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 14/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CreateAdHowItWorksViewController: UIViewController {
    private let bag = DisposeBag()
    var viewModel: CreateAdOnboardingViewModel!
    private var videoView: MediaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let root = ViewFactory.createView()
        view.addSubview(root)
        root.pinToEdges(of: view, orientation: .horizontal)
        root.verticalPin(to: view, orientation: .top)

        let screenScale = min(UIScreen.main.bounds.width / 414, 1.0)
        let spark = ViewFactory.createImage(image: R.image.sparkOrange())
        root.addSubview(spark)
        spark.verticalPin(to: root, orientation: .top, padding: 18 * screenScale)
        spark.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)

        let title = ViewFactory.createTitle(R.string.localizable.createAdHowWorksTitle())
        title.font = UIFont.systemFont(ofSize: screenScale * 32, weight: .bold)
        title.textColor = .orange
        root.addSubview(title)
        title.numberOfLines = 0

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.alignBelow(view: spark, withPadding: 8)

        let description = ViewFactory.createLabel(text: R.string.localizable.createAdHowWorksVideoLabel(), font: .descriptionLabel)
        root.addSubview(description)
        description.numberOfLines = 0
        description.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        description.alignBelow(view: title, withPadding: screenScale * 16)
        
        let mediaView = ViewFactory.createMediaView()

        mediaView.configure(videoUrl: R.file.createAdVideoMp4()!)
        mediaView.showScrubber = false
        mediaView.isMuted = false
        root.addSubview(mediaView)
        mediaView.alignBelow(view: description, withPadding: screenScale * 32)
        mediaView.horizontalPin(to: root, orientation: .leading, padding: UIConstants.margin)
        let screenWidth = screenScale * UIScreen.main.bounds.width - UIConstants.margin * 2 - 32
        let videoSize = screenWidth
        mediaView.setSize(videoSize, videoSize * 0.5625)
        mediaView.play()
        self.videoView = mediaView
        
        root.verticalPin(to: mediaView, orientation: .bottom, padding: 8)

        let tipsButton = ViewFactory.createSecondaryButton(text: R.string.localizable.createAdHowWorksSeeTipsButton())
        view.addSubview(tipsButton)
        tipsButton.verticalPin(to: view, orientation: .bottom, padding: -UIConstants.margin)
        tipsButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        tipsButton.setHeightAnchor(UIConstants.buttonHeight)
        tipsButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.showTips()
        }.disposed(by: bag)

        let nextButton = ViewFactory.createPrimaryButton(text: R.string.localizable.createAdCommonCreateAdButton())
        view.addSubview(nextButton)
        nextButton.alignAbove(view: tipsButton, withPadding: -8.0)
        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.createAd()
        }.disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNavBar(transparent: true)

        addCloseButton(image: R.image.ic_close(), orientation: .right).rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.dismiss()
        }.disposed(by: bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoView.pause()
    }
}
