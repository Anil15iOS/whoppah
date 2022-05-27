//
//  SignUpPasswordViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 2/25/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WhoppahCore

private extension RangeExpression where Bound == String.Index {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

class SignUpPasswordViewController: UIViewController {
    // MARK: - IBOutlets

    var closeButton: UIButton!
    var passwordStrongnessView: PasswordStrongnessView!
    private var validators = [ValidatorComponent]()

    private let stripeURL = "stripe"
    private let termsURL = "terms"
    private let privacyURL = "privacy"

    private var isPrivacyTermsOfUseAccepted = BehaviorRelay<Bool>(value: false)
    private var isStripeTermsAccepted = BehaviorRelay<Bool>(value: false)

    private var merchant: LegacyMerchantInput?
    private let bag = DisposeBag()
    var viewModel: RegistrationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.authSignUp2ScreenTitle(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.authSignUp2Title())
        root.addSubview(title)

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        let passwordViews = ViewFactory.createPassword(passwordPlaceholder: R.string.localizable.auth_new_pass_password(), bag: bag)
        let password = passwordViews.textfield
        let eye = passwordViews.eye

        root.addSubview(password)

        password.contentHeight = UIConstants.textfieldHeight
        password.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        password.rx.text.orEmpty.bind(to: viewModel.inputs.password).disposed(by: bag)

        password.alignBelow(view: title, withPadding: 16)
        validators.append(TextValidationComponent(password,
                                                  errorMessage: R.string.localizable.error_invalid_pass(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        root.addSubview(eye)
        eye.verticalPin(to: password, orientation: .top, padding: 22)
        eye.horizontalPin(to: password, orientation: .trailing, padding: -16)

        passwordStrongnessView = PasswordStrongnessView()
        passwordStrongnessView.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(passwordStrongnessView)
        passwordStrongnessView.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        passwordStrongnessView.setHeightAnchor(80)
        passwordStrongnessView.alignBelow(view: password, withPadding: 16)
        validators.append(PasswordStrongnessValidatorComponent(passwordStrongnessView,
                                                               errorMessage: R.string.localizable.authSignUp2PasswordMatchRequirementsError(),
                                                               textfield: password))

        let privacyCheckbox = addCheckbox(toView: root, alignBelow: passwordStrongnessView, text: "")
        privacyCheckbox.selectedSubject.bind(to: isPrivacyTermsOfUseAccepted).disposed(by: bag)

        let stripeCheckbox = addCheckbox(toView: root, alignBelow: privacyCheckbox, text: "")
        stripeCheckbox.selectedSubject.bind(to: isStripeTermsAccepted).disposed(by: bag)

        let termsText = ViewFactory.createTextview("")
        termsText.delegate = self
        termsText.isEditable = false
        termsText.isScrollEnabled = false
        termsText.textContainerInset = UIEdgeInsets.zero
        termsText.textContainer.lineFragmentPadding = 0
        root.addSubview(termsText)
        termsText.alignBelow(view: stripeCheckbox, withPadding: 16)
        termsText.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        termsText.attributedText = getTermsAttributedText()

        let step = StepView.createStepView(forStep: viewModel.currentStep, withTotal: viewModel.numberOfSteps)
        root.addSubview(step)
        step.alignBelow(view: termsText, withPadding: 16)
        step.horizontalPin(to: root, orientation: .trailing, padding: -UIConstants.margin)

        let registerButton = ViewFactory.createPrimaryButton(text: viewModel.actionButtonText)
        root.addSubview(registerButton)
        registerButton.alignBelow(view: step, withPadding: 8)
        registerButton.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        registerButton.setHeightAnchor(UIConstants.buttonHeight)
        registerButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            guard self.validateData() else { return }
            self.viewModel.next()
        }.disposed(by: bag)
        viewModel.outputs.loading.bind(to: registerButton.rx.isAnimating).disposed(by: bag)
        viewModel.outputs.loading.map { !$0 }.bind(to: registerButton.rx.isEnabled).disposed(by: bag)

        password.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.passwordStrongnessView.text = text
        }).disposed(by: bag)

        root.verticalPin(to: registerButton, orientation: .bottom, padding: UIConstants.margin)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.step = .password
    }

    // MARK: - Private

    private func showActivateAccountDialog() {
        let title = R.string.localizable.auth_sign_up_activate_dialog_title()
        let messageText = R.string.localizable.auth_sign_up_activate_dialog_message()
        let message = messageText
        let dialogVC = MessageDialog(title: title, message: message, image: R.image.accountCreatedIcon())
        dialogVC.delegate = self
        present(dialogVC, animated: true, completion: nil)
    }

    private func getTermsAttributedText() -> NSAttributedString {
        let link = R.string.localizable.auth_sign_up2_terms_part1() + " " +
            R.string.localizable.auth_sign_up2_terms_part2() + " " +
            R.string.localizable.auth_sign_up2_terms_part3() + " " +
            R.string.localizable.auth_sign_up2_terms_part4() + " " +
            R.string.localizable.auth_sign_up2_terms_part5() + " " +
            R.string.localizable.auth_sign_up2_terms_part6()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                          NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedString = NSMutableAttributedString(string: link, attributes: attributes)
        attributedString.addAttribute(.link, value: termsURL, range: link.range(of: R.string.localizable.auth_sign_up2_terms_part2())!.nsRange(in: link))
        attributedString.addAttribute(.link, value: privacyURL, range: link.range(of: R.string.localizable.auth_sign_up2_terms_part4())!.nsRange(in: link))
        attributedString.addAttribute(.link, value: stripeURL, range: link.range(of: R.string.localizable.auth_sign_up2_terms_part6())!.nsRange(in: link))
        return attributedString
    }

    @discardableResult
    private func addCheckbox(toView root: UIView, alignBelow: UIView, text: String) -> CheckBox {
        let stack = ViewFactory.createHorizontalStack(spacing: 16)
        stack.alignment = .center
        stack.distribution = .fill
        root.addSubview(stack)
        stack.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        stack.alignBelow(view: alignBelow, withPadding: 24)
        let checkbox = ViewFactory.createCheckbox(width: 24)
        checkbox.selectedSubject.bind(to: isPrivacyTermsOfUseAccepted).disposed(by: bag)
        stack.addArrangedSubview(checkbox)
        let text = ViewFactory.createLabel(text: text, lines: 0, font: .bodySmall)
        stack.addArrangedSubview(text)
        text.isUserInteractionEnabled = true
        checkbox.associatedTapView = text
        text.center(withView: checkbox, orientation: .vertical)
        stack.setHeightAnchor(35)
        validators.append(CheckboxValidatorComponent(checkbox, errorColor: R.color.redInvalidLight(), validator: { checkbox -> Bool in
            checkbox.isSelected
        }))
        return checkbox
    }

    private func validateData() -> Bool {
        var isValid = true
        for validator in validators {
            isValid = validator.validate() && isValid
        }
        return isValid
    }

    // MARK: - Actions

    @IBAction func closeAction(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    private func termsLinkAction() {
        let documentVC: DocumentViewController = createTermsVC()
        documentVC.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { documentVC.modalPresentationStyle = .fullScreen }
        present(documentVC, animated: true, completion: nil)
    }

    private func stripeLinkAction() {
        let documentVC: DocumentViewController = createStripeVC()
        documentVC.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { documentVC.modalPresentationStyle = .fullScreen }
        present(documentVC, animated: true, completion: nil)
    }

    private func privacyLinkAction() {
        let documentVC: DocumentViewController = createPrivacyVC()
        documentVC.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { documentVC.modalPresentationStyle = .fullScreen }
        present(documentVC, animated: true, completion: nil)
    }

    // MARK: -
}

// MARK: - MessageDialogViewControllerDelegate

extension SignUpPasswordViewController: MessageDialogDelegate {
    func messageDialogDidPresented(_: MessageDialog) {}

    func messageDialogDidDismissed(_: MessageDialog) {
        dismiss(animated: true) {
            if self.viewModel.isMerchant {
                Navigator().navigate(route: Navigator.Route.profileCompletion)
            } else {
                Navigator().navigate(route: Navigator.Route.accountCreated)
            }
        }
    }
}

extension SignUpPasswordViewController: UITextViewDelegate {
    func textView(_: UITextView, shouldInteractWith URL: URL, in _: NSRange, interaction _: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case termsURL:
            termsLinkAction()
        case privacyURL:
            privacyLinkAction()
        case stripeURL:
            stripeLinkAction()
        default:
            UIApplication.shared.open(URL)
        }
        return false
    }
}
