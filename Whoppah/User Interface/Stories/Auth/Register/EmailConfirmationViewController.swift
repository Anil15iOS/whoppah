//
//  EmailConfirmationViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 03/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCoreNext
import Resolver

class EmailConfirmationViewController: UIViewController {
    var viewModel: RegistrationViewModel!

    private let bag = DisposeBag()
    typealias CompletionBlock = (() -> Void)
    var onCompletion: CompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isModalInPresentation = true

        setNavBar(title: R.string.localizable.authEmailConfirmScreenTitle().capitalizingFirstLetter(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let closeButton = ViewFactory.createLargeButton(image: R.image.ic_close()!)
        view.addSubview(closeButton)
        closeButton.verticalPin(to: view, orientation: .top, padding: 0)
        closeButton.horizontalPin(to: view, orientation: .leading, padding: 0)
        closeButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.dismiss()
        }.disposed(by: bag)

        let root = scrollView.root

        let image = ViewFactory.createImage(image: R.image.accountConfirmImage())
        root.addSubview(image)
        image.center(withView: root, orientation: .horizontal)
        image.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let title = ViewFactory.createTitle(R.string.localizable.authEmailConfirmTitle())
        root.addSubview(title)
        title.textAlignment = .center
        title.alignBelow(view: image, withPadding: 16)
        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)

        let description = ViewFactory.createLabel(text: "",
                                                  lines: 0,
                                                  alignment: .center,
                                                  font: .descriptionLabel)

        viewModel.outputs.email.subscribe(onNext: { _ in
            description.text = R.string.localizable.authEmailConfirmDescription()
        }).disposed(by: bag)

        root.addSubview(description)
        description.alignBelow(view: title, withPadding: 8)
        description.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)

        if EmailClient.allCases.first(where: { $0.exists() }) != nil {
            let mailButton = ViewFactory.createPrimaryButton(text: R.string.localizable.authEmailConfirmOpenMailButton())
            root.addSubview(mailButton)
            mailButton.alignBelow(view: description, withPadding: 32)
            mailButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
            mailButton.setHeightAnchor(UIConstants.buttonHeight)
            mailButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                let coordinator = CheckEmailDialogCoordinator(viewController: self)
                coordinator.start(title: R.string.localizable.authEmailSelectClientTitle(), message: R.string.localizable.authEmailSelectClientDescription()) {
                    self.dismiss()
                }
            }.disposed(by: bag)

            let whoppahButton = ViewFactory.createSecondaryButton(text: R.string.localizable.authEmailConfirmOpenWhoppahButton())
            root.addSubview(whoppahButton)
            whoppahButton.alignBelow(view: mailButton, withPadding: 16)
            whoppahButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
            whoppahButton.setHeightAnchor(UIConstants.buttonHeight)
            whoppahButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                self.dismiss()
            }.disposed(by: bag)

            root.verticalPin(to: whoppahButton, orientation: .bottom, padding: UIConstants.margin)
        } else {
            let whoppahButton = ViewFactory.createPrimaryButton(text: R.string.localizable.authEmailConfirmNoEmailClientContinue())
            root.addSubview(whoppahButton)
            whoppahButton.alignBelow(view: description, withPadding: 32)
            whoppahButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
            whoppahButton.setHeightAnchor(UIConstants.buttonHeight)
            whoppahButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                self.dismiss()
            }.disposed(by: bag)

            root.verticalPin(to: whoppahButton, orientation: .bottom, padding: UIConstants.margin)
        }
    }

    private func dismiss() {
        dismiss(animated: true, completion: onCompletion)
    }
}
