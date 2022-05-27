//
//  BusinessContactViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 03/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import FlagPhoneNumber
import Foundation
import RxSwift
import WhoppahCore

class BusinessContactViewController: UIViewController {
    var viewModel: RegistrationViewModel!

    private var validators = [ValidatorComponent]()
    private let bag = DisposeBag()
    typealias CompletionBlock = (() -> Void)
    var onCompletion: CompletionBlock?

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.authSignUp4ScreenTitle().capitalizingFirstLetter(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.authSignUp4Title())
        root.addSubview(title)

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let description = ViewFactory.createLabel(text: R.string.localizable.authSignUp4Description(),
                                                  lines: 0,
                                                  font: .smallText)
        root.addSubview(description)

        description.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        description.alignBelow(view: title, withPadding: UIConstants.titleBottomTextMargin)

        let firstName = ViewFactory.createTextField(placeholder: R.string.localizable.commonFirstName())
        firstName.rx.text.orEmpty.bind(to: viewModel.inputs.firstName).disposed(by: bag)
        viewModel.outputs.firstName.bind(to: firstName.rx.text).disposed(by: bag)
        firstName.sendActions(for: .editingChanged) // without this event the text colour doesn't update

        firstName.textContentType = .givenName
        root.addSubview(firstName)
        firstName.contentHeight = UIConstants.textfieldHeight
        firstName.alignBelow(view: description, withPadding: 24)
        firstName.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(firstName,
                                                  errorMessage: R.string.localizable.commonMissingFirstName(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        let lastName = ViewFactory.createTextField(placeholder: R.string.localizable.commonLastName())
        lastName.rx.text.orEmpty.bind(to: viewModel.inputs.lastName).disposed(by: bag)
        viewModel.outputs.lastName.bind(to: lastName.rx.text).disposed(by: bag)
        lastName.sendActions(for: .editingChanged) // without this event the text colour doesn't update

        lastName.textContentType = .familyName
        root.addSubview(lastName)
        lastName.contentHeight = UIConstants.textfieldHeight
        lastName.alignBelow(view: firstName, withPadding: 16)
        lastName.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(lastName,
                                                  errorMessage: R.string.localizable.commonMissingLastName(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        let step = StepView.createStepView(forStep: viewModel.currentStep, withTotal: viewModel.numberOfSteps)
        root.addSubview(step)
        step.alignBelow(view: lastName, withPadding: 24)
        step.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)

        let nextButton = ViewFactory.createPrimaryButton(text: viewModel.actionButtonText)
        root.addSubview(nextButton)
        nextButton.alignBelow(view: step, withPadding: 8)
        nextButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        nextButton.setHeightAnchor(UIConstants.buttonHeight)
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard self.validateData() else { return }
            self.viewModel.next()
        }.disposed(by: bag)

        root.verticalPin(to: nextButton, orientation: .bottom, padding: UIConstants.margin)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.step = .merchantContact
    }

    private func validateData() -> Bool {
        var isValid = true
        for validator in validators {
            isValid = validator.validate() && isValid
        }
        return isValid
    }
}
