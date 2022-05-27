//
//  ContinueAdDialog.swift
//  Whoppah
//
//  Created by Eddie Long on 28/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxSwift

class ContinueAdDialog: BaseDialog {
    private let bag = DisposeBag()
    var onContinueClicked: (() -> Void)?

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.dialogBackground()

        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        background.backgroundColor = .white
        background.layer.cornerRadius = 6.0
        background.pinToEdges(of: view, orientation: .horizontal, padding: UIConstants.margin)
        background.center(withView: view, orientation: .vertical)

        let closeButton = ViewFactory.createLargeButton(image: R.image.ic_close()!)
        background.addSubview(closeButton)
        closeButton.horizontalPin(to: background, orientation: .leading)
        closeButton.verticalPin(to: background, orientation: .top)
        closeButton.rx.tap.bind { [weak self] in
            self?.dismiss()
        }.disposed(by: bag)

        let icon = ViewFactory.createImage(image: R.image.sparkOrange())
        background.addSubview(icon)
        icon.horizontalPin(to: background, orientation: .leading, padding: UIConstants.margin)
        icon.verticalPin(to: background, orientation: .top, padding: 48)

        let title = ViewFactory.createTitle(R.string.localizable.continueAdDialogTitle())
        background.addSubview(title)
        title.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        title.numberOfLines = 2
        title.textColor = .orange
        title.textAlignment = .left
        title.pinToEdges(of: background, orientation: .horizontal, padding: UIConstants.margin)
        title.alignBelow(view: icon, withPadding: 8)

        let description = ViewFactory.createLabel(text: R.string.localizable.continueAdDialogDescription(), lines: 0, font: .descriptionLabel)
        description.textAlignment = .left
        background.addSubview(description)
        description.pinToEdges(of: background, orientation: .horizontal, padding: UIConstants.margin)
        description.alignBelow(view: title, withPadding: 16)

        let createAdButton = ViewFactory.createPrimaryButton(text: R.string.localizable.continueAdDialogButton())
        background.addSubview(createAdButton)
        createAdButton.setHeightAnchor(UIConstants.buttonHeight)
        createAdButton.pinToEdges(of: background, orientation: .horizontal, padding: UIConstants.margin)
        createAdButton.alignBelow(view: description, withPadding: 64)
        createAdButton.rx.tap.bind { [weak self] in
            self?.continueAd()
        }.disposed(by: bag)

        background.verticalPin(to: createAdButton, orientation: .bottom, padding: 32)
    }

    private func continueAd() {
        dismiss(animated: true) {
            self.onContinueClicked?()
        }
    }
}
