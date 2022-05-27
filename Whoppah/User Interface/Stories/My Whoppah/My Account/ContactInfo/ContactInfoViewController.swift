//
//  ContactInfoViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/26/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import FlagPhoneNumber
import RxSwift
import UIKit
import WhoppahCore

class ContactInfoViewController: UIViewController {
    let addressCellHeight: CGFloat = 60.0

    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var firstNameTextField: WPTextField!
    @IBOutlet var lastNameTextField: WPTextField!
    @IBOutlet var emailTextField: WPTextField!
    @IBOutlet var profileNameTextField: WPTextField!
    @IBOutlet var phoneNumberView: WPPhoneNumber!
    @IBOutlet var phoneNumberBottomSpacingView: UIView!
    @IBOutlet var companyNameTextField: WPTextField!
    @IBOutlet var websiteTextField: WPTextField!
    @IBOutlet var vatNumberTextField: WPTextField!
    @IBOutlet var taxNumberTextField: WPTextField!
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var businessStackView: UIStackView!
    @IBOutlet var saveButton: PrimaryLargeButton!
    @IBOutlet var myAddressesLabel: UILabel!
    @IBOutlet var myAddressesTableView: UITableView!
    @IBOutlet var addressesHeight: NSLayoutConstraint!
    @IBOutlet var addAddressButton: UIButton!
    @IBOutlet var emptyAddressLabel: UILabel!
    @IBOutlet var changesSavedToast: ToastMessage!
    @IBOutlet var whoppahIsNotAllowedLabel: UILabel!
    @IBOutlet var cannotBeEmptyLabel: UILabel!

    // MARK: - Properties

    private let bag = DisposeBag()
    var viewModel: ContactInfoViewModel!

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpTextFields()
        setUpBindings()
        setUpButtons()
        setUpTableView()
        
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Private

    private func setUpBindings() {
        viewModel.outputs.isBusiness.subscribe(onNext: { [weak self] isBusiness in
            guard let self = self else { return }
            self.businessStackView.subviews.forEach { $0.isVisible = isBusiness }
        }).disposed(by: bag)

        viewModel.outputs.addresses.bind(to: myAddressesTableView.rx.items(cellIdentifier: AddressCell.identifier, cellType: AddressCell.self)) { _, viewModel, cell in
            cell.configure(with: viewModel)
        }.disposed(by: bag)

        viewModel.outputs.addresses.map { [weak self] (addresses) -> CGFloat in
            guard let self = self else { return 0.0 }
            return CGFloat(addresses.count) * self.addressCellHeight
        }.bind(to: addressesHeight.rx.constant).disposed(by: bag)
    }

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = R.string.localizable.main_my_profile_contacts()
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setUpButtons() {
        saveButton.style = .primary
        viewModel.outputs.saveButton.bind(to: saveButton.rx.isEnabled).disposed(by: bag)
        viewModel.outputs.isSaving.bind(to: saveButton.rx.isAnimating).disposed(by: bag)
    }

    private func setUpTextFields() {
        emailTextField.placeholder = R.string.localizable.set_profile_merchant1_contact_email()
        emailTextField.delegate = self

        let emailError = viewModel.outputs.email.filter { $0?.error != nil }
        emailError.map { $0?.error }.bind(to: emailTextField.rx.errorMessage).disposed(by: bag)
        emailError.compactMap { $0 }.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.emailTextField.frame.origin.y - 16.0), animated: true)
        }).disposed(by: bag)

        viewModel.outputs.email.filter { $0?.title.isEmpty == false }.map { $0?.title }.bind(to: emailTextField.rx.text).disposed(by: bag)
        emailTextField.rx.text.orEmpty.bind(to: viewModel.inputs.email).disposed(by: bag)

        phoneNumberView.textfield.delegate = self
        let phoneError = viewModel.outputs.phone.filter { $0?.error != nil }
        phoneError.compactMap { $0 }.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.phoneNumberView.frame.origin.y - 16.0), animated: true)
        }).disposed(by: bag)
        viewModel.outputs.phone.subscribe(onNext: { [weak self] number in
            guard let self = self else { return }
            if let number = number {
                self.phoneNumberView.textfield.set(phoneNumber: number.title)
            }
        }).disposed(by: bag)

        firstNameTextField.placeholder = R.string.localizable.set_profile_merchant1_contact_first_name()
        firstNameTextField.delegate = self

        let givenNameError = viewModel.outputs.givenName.filter { $0.error != nil }
        givenNameError.map { $0.error }.bind(to: firstNameTextField.rx.errorMessage).disposed(by: bag)
        givenNameError.compactMap { $0 }.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.firstNameTextField.frame.origin.y - 16.0), animated: true)
        }).disposed(by: bag)

        viewModel.outputs.givenName.filter { $0.title.isEmpty == false }.map { $0.title }.bind(to: firstNameTextField.rx.text).disposed(by: bag)
        firstNameTextField.rx.text.orEmpty.bind(to: viewModel.inputs.givenName).disposed(by: bag)

        lastNameTextField.placeholder = R.string.localizable.set_profile_merchant1_contact_last_name()
        lastNameTextField.delegate = self
        let lastNameError = viewModel.outputs.familyName.filter { $0.error != nil }
        lastNameError.map { $0.error }.bind(to: lastNameTextField.rx.errorMessage).disposed(by: bag)
        lastNameError.compactMap { $0 }.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.lastNameTextField.frame.origin.y - 16.0), animated: true)
        }).disposed(by: bag)

        viewModel.outputs.familyName.filter { $0.title.isEmpty == false }.map { $0.title }.bind(to: lastNameTextField.rx.text).disposed(by: bag)
        lastNameTextField.rx.text.orEmpty.bind(to: viewModel.inputs.familyName).disposed(by: bag)

        companyNameTextField.placeholder = R.string.localizable.set_profile_merchant1_company_name()
        companyNameTextField.delegate = self
        let businessNameError = viewModel.outputs.businessName.filter { $0.error != nil }
        businessNameError.map { $0.error }.bind(to: companyNameTextField.rx.errorMessage).disposed(by: bag)
        businessNameError.compactMap { $0 }.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.businessStackView.frame.origin.y - 16.0), animated: true)
        }).disposed(by: bag)
        viewModel.outputs.businessName.filter { $0.title.isEmpty == false }.map { $0.title }.bind(to: companyNameTextField.rx.text).disposed(by: bag)
        companyNameTextField.rx.text.orEmpty.bind(to: viewModel.inputs.businessName).disposed(by: bag)

        profileNameTextField.placeholder = R.string.localizable.set_profile_personal_username()
        profileNameTextField.delegate = self
        let companyNameError = viewModel.outputs.companyName.filter { $0.error != nil }
        companyNameError.map { $0.error }.bind(to: profileNameTextField.rx.errorMessage).disposed(by: bag)
        companyNameError.compactMap { $0 }.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.profileNameTextField.frame.origin.y - 16.0), animated: true)
        }).disposed(by: bag)
        viewModel.outputs.companyName.filter { $0.title.isEmpty == false }.map { $0.title }.bind(to: profileNameTextField.rx.text).disposed(by: bag)
        profileNameTextField.rx.text.orEmpty.bind(to: viewModel.inputs.companyName).disposed(by: bag)

        websiteTextField.placeholder = R.string.localizable.commonWebsite()
        websiteTextField.delegate = self
        let websiteError = viewModel.outputs.website.filter { $0?.error?.isEmpty == false }
        websiteError.map { $0?.error }.bind(to: websiteTextField.rx.errorMessage).disposed(by: bag)
        websiteError.compactMap { $0 }.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.businessStackView.frame.origin.y - 16), animated: true)
        }).disposed(by: bag)

        viewModel.outputs.website.filter { $0?.title.isEmpty == false }.compactMap { $0?.title }.bind(to: websiteTextField.rx.text).disposed(by: bag)
        websiteTextField.rx.text.orEmpty.bind(to: viewModel.inputs.website).disposed(by: bag)

        vatNumberTextField.placeholder = R.string.localizable.set_profile_merchant1_vat()
        vatNumberTextField.delegate = self
        viewModel.outputs.vatId.bind(to: vatNumberTextField.rx.text).disposed(by: bag)
        vatNumberTextField.rx.text.orEmpty.bind(to: viewModel.inputs.vatId).disposed(by: bag)

        taxNumberTextField.placeholder = R.string.localizable.set_profile_merchant1_kvk()
        taxNumberTextField.delegate = self
        viewModel.outputs.taxId.bind(to: taxNumberTextField.rx.text).disposed(by: bag)
        taxNumberTextField.rx.text.orEmpty.bind(to: viewModel.inputs.taxId).disposed(by: bag)
    }

    private func setUpTableView() {
        myAddressesTableView.delegate = self
        myAddressesTableView.register(UINib(nibName: AddressCell.nibName, bundle: nil), forCellReuseIdentifier: AddressCell.identifier)
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveAction(_: PrimaryLargeButton) {
        cannotBeEmptyLabel.isHidden = true
        whoppahIsNotAllowedLabel.isHidden = true
        
        if profileNameTextField.text?.isEmpty == true {
            cannotBeEmptyLabel.isHidden = false
            return
        }
        
        if profileNameTextField.text?.lowercased().contains("whoppah") == true {
            whoppahIsNotAllowedLabel.isHidden = false
            return
        }

        viewModel.save { [weak self] in
            guard let self = self else { return }
            self.changesSavedToast.show(in: self.view)
        }
    }

    @IBAction func addAddressAction(_: UIButton) {
        view.endEditing(true)
        viewModel.addAddress()
    }
}

// MARK: - UITextFieldDelegate

extension ContactInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let label = textField as? WPTextField {
            label.errorMessage = nil
        }
        if textField == phoneNumberView.textfield {
            phoneNumberView.textfield.textColor = .black
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneNumberView.textfield {
            phoneNumberView.textfield.textColor = phoneNumberView.textfield.isValid.value ? UIColor.black : UIColor.redInvalid
            let text = phoneNumberView.textfield.getNumber(format: .E164) ?? ""
            viewModel.inputs.phone.onNext(text)
        }
    }
}

// MARK: - UITableViewDelegate

extension ContactInfoViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        addressCellHeight
    }
}

extension ContactInfoViewController: FPNTextFieldDelegate {
    func fpnDisplayCountryList() {}

    func fpnDidSelectCountry(name _: String, dialCode _: String, code _: String) {}

    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        let wpTF = textField as? WPPhoneTextfield
        wpTF?.isValid.accept(isValid)
    }
}
