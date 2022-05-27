//
//  SignUpViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/25/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WhoppahCore
import WhoppahRepository

class SignUpViewController: UIViewController {
    private let bag = DisposeBag()
    private var validators = [ValidatorComponent]()
    var viewModel: RegistrationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.authSignUp1ScreenTitle(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.authSignUp1Title())
        root.addSubview(title)
        title.numberOfLines = 0

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let profile = ViewFactory.createTextField(placeholder: R.string.localizable.my_account_username_placeholder())
        profile.delegate = self
        viewModel.outputs.profileName.bind(to: profile.rx.text).disposed(by: bag)
        profile.rx.text.orEmpty.bind(to: viewModel.inputs.profileName).disposed(by: bag)
        profile.sendActions(for: .editingChanged) // without this event the text colour doesn't update
        profile.textContentType = .givenName
        root.addSubview(profile)
        profile.contentHeight = UIConstants.textfieldHeight
        profile.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)
        profile.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(profile,
                                                  errorMessage: R.string.localizable.authSignUp1ProfileError(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        let email = ViewFactory.createEmail(placeholder: R.string.localizable.auth_sign_in_email())
        email.delegate = self
        viewModel.outputs.email.bind(to: email.rx.text).disposed(by: bag)
        email.rx.text.orEmpty.map { $0.trimmingCharacters(in: CharacterSet(charactersIn: " ")) }.bind(to: viewModel.inputs.email).disposed(by: bag)
        email.sendActions(for: .editingChanged) // without this event the text colour doesn't update
        email.contentHeight = UIConstants.textfieldHeight
        root.addSubview(email)
        email.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        email.alignBelow(view: profile, withPadding: 16)
        let emptyTextCheck = TextValidationComponent(email,
                                                     errorMessage: R.string.localizable.authSignUp1EmailError(),
                                                     validator: { textfield -> Bool in
                                                         !textfield.text!.isEmpty
        })
        let emailCheck = TextValidationComponent(email,
                                                 errorMessage: R.string.localizable.auth_sign_in_invalid_email(),
                                                 validator: { textfield -> Bool in
                                                     textfield.text!.isValidEmail()
        })
        validators.append(AggregateValidator(emptyTextCheck, emailCheck))

        var stepAlignView: UIView = email
        if viewModel.allowSocial {
            let socialViews = ViewFactory.createSocialLoginView(root: root, isLogin: false, bag: bag) { [weak self] network in
                self?.socialAction(network)
            }
            socialViews.stack.alignBelow(view: email, withPadding: 48)
            stepAlignView = socialViews.google
        }

        let step = StepView.createStepView(forStep: viewModel.currentStep, withTotal: viewModel.numberOfSteps)
        root.addSubview(step)
        step.alignBelow(view: stepAlignView, withPadding: 24)
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
        viewModel.step = .email
    }

    private func socialAction(_ network: SocialNetwork) {
        viewModel.register(via: network)
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

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_: UITextField) {}

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
