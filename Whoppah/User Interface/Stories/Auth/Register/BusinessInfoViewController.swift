//
//  MerchantBusinessDetailsViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/13/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

class BusinessInfoViewController: UIViewController {
    var viewModel: RegistrationViewModel!

    private var validators = [ValidatorComponent]()
    private let bag = DisposeBag()
    private var phone: WPPhoneNumber!
    typealias CompletionBlock = (() -> Void)
    var onCompletion: CompletionBlock?

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.authSignUp3ScreenTitle().capitalizingFirstLetter(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.authSignUp3Title())
        root.addSubview(title)

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let companyName = ViewFactory.createTextField(placeholder: R.string.localizable.authSignUp3CompanyName())
        companyName.delegate = self
        companyName.rx.text.orEmpty.bind(to: viewModel.inputs.companyName).disposed(by: bag)
        viewModel.outputs.companyName.bind(to: companyName.rx.text).disposed(by: bag)
        companyName.sendActions(for: .editingChanged) // without this event the text colour doesn't update

        companyName.textContentType = .organizationName
        root.addSubview(companyName)
        companyName.contentHeight = UIConstants.textfieldHeight
        companyName.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)
        companyName.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(companyName,
                                                  errorMessage: R.string.localizable.commonMissingCompanyName(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        let phone = ViewFactory.createPhoneNumber(placeholder: R.string.localizable.commonInvalidPhoneNumber())
        root.addSubview(phone)

        viewModel.outputs.phone.subscribe(onNext: { number in
            phone.textfield.set(phoneNumber: number)
        }).disposed(by: bag)
        self.phone = phone
        validators.append(PhoneValidationComponent(phone, validator: { phone -> Bool in
            phone.textfield.isValid.value
        }))

        // Any change resets the color back to default
        phone.textfield.rx.text.orEmpty.map { _ -> UIColor? in nil }.subscribe(onNext: { color in
            phone.borderColor = color
        }).disposed(by: bag)

        phone.textfield.rx.text.orEmpty
            .compactMap { _ in phone.textfield.getNumber(format: .E164) }
            .bind(to: viewModel.inputs.phone).disposed(by: bag)
        phone.textfield.sendActions(for: .editingChanged)
        phone.setHeightAnchor(UIConstants.textfieldHeight)
        phone.alignBelow(view: companyName, withPadding: 16)
        phone.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)

        let phoneDescription = ViewFactory.createLabel(text: R.string.localizable.authSignUp3PhoneNumberDescription(),
                                                       lines: 0,
                                                       font: .smallText)
        root.addSubview(phoneDescription)
        phoneDescription.alignBelow(view: phone)
        phoneDescription.pinToEdges(of: phone, orientation: .horizontal, padding: 4)

        let step = StepView.createStepView(forStep: viewModel.currentStep, withTotal: viewModel.numberOfSteps)
        root.addSubview(step)
        step.alignBelow(view: phoneDescription, withPadding: 24)
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
        viewModel.step = .merchantDetail
    }

    private func validateData() -> Bool {
        var isValid = true
        for validator in validators {
            isValid = validator.validate() && isValid
        }
        return isValid
    }
}

// MARK: - UITextFieldDelegate

extension BusinessInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_: UITextField) {}

    func textFieldDidEndEditing(_: UITextField) {}
}
