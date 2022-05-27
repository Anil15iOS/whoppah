//
//  AddEditAddressViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/13/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore

protocol AddEditAddressViewControllerDelegate: AnyObject {
    func addEditAddressViewController(didDelete address: LegacyAddressInput)
    func addEditAddressViewController(didSave address: LegacyAddressInput)
}

class AddEditAddressViewController: UIViewController {
    private var validators = [ValidatorComponent]()
    private let bag = DisposeBag()

    private var countryTextfield: WPCountryTextField!
    private var postalCodeTextField: WPTextField!
    private var line1Textfield: WPTextField!
    private var cityTextField: WPTextField!
    private var deleteButton: TextButton!
    private var saveButton: PrimaryLargeButton!

    weak var delegate: AddEditAddressViewControllerDelegate?
    var address = LegacyAddressInput(line1: "",
                               line2: nil,
                               postalCode: "",
                               city: "",
                               state: nil,
                               country: Country.netherlands.rawValue,
                               point: nil)

    var isDeleteButtonHidden: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar(title: R.string.localizable.add_address_button_title().capitalizingFirstLetter(), enabled: true)

        let scrollView = ViewFactory.createScrollView()
        view.addSubview(scrollView.scroll)
        scrollView.scroll.pinToAllEdges(of: view)

        let root = scrollView.root

        let title = ViewFactory.createTitle(R.string.localizable.authSignUp5Title())
        root.addSubview(title)

        title.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        title.verticalPin(to: root, orientation: .top, padding: UIConstants.titleTopMargin)

        countryTextfield = ViewFactory.createCountryTextField(placeholder: R.string.localizable.add_address_country_placeholder())
        line1Textfield = ViewFactory.createTextField(placeholder: R.string.localizable.add_address_street_placeholder())
        postalCodeTextField = ViewFactory.createTextField(placeholder: R.string.localizable.add_address_postcode_placeholder())
        cityTextField = ViewFactory.createTextField(placeholder: R.string.localizable.add_address_city_placeholder())
        configure(with: address)

        root.addSubview(countryTextfield)
        countryTextfield.alignBelow(view: title, withPadding: UIConstants.titleBottomMargin)
        countryTextfield.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        countryTextfield.sendActions(for: .editingChanged) // without this event the text colour doesn't update

        countryTextfield.picker.rx.itemSelected
            .map { Country.allCases[$0.0].rawValue }
            .subscribe(onNext: { [weak self] country in self?.address.country = country })
            .disposed(by: bag)

        countryTextfield.picker.rx.itemSelected
            .map { Country.allCases[$0.0].title }
            .bind(to: countryTextfield.rx.text).disposed(by: bag)

        line1Textfield.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.address.line1 = text
        }).disposed(by: bag)
        line1Textfield.sendActions(for: .editingChanged) // without this event the text colour doesn't update
        line1Textfield.textContentType = .streetAddressLine1
        root.addSubview(line1Textfield)
        line1Textfield.contentHeight = UIConstants.textfieldHeight
        line1Textfield.alignBelow(view: countryTextfield, withPadding: 16)
        line1Textfield.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(line1Textfield,
                                                  errorMessage: R.string.localizable.commonMissingAddressStreet(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        postalCodeTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.address.postalCode = text
        }).disposed(by: bag)
        postalCodeTextField.sendActions(for: .editingChanged) // without this event the text colour doesn't update

        postalCodeTextField.textContentType = .postalCode
        root.addSubview(postalCodeTextField)
        postalCodeTextField.contentHeight = UIConstants.textfieldHeight
        postalCodeTextField.alignBelow(view: line1Textfield, withPadding: 16)
        postalCodeTextField.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(postalCodeTextField,
                                                  errorMessage: R.string.localizable.commonInvalidAddressPostcode(),
                                                  validator: { textfield -> Bool in
                                                    !textfield.text!.isEmpty
        }))

        cityTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.address.city = text
        }).disposed(by: bag)
        cityTextField.sendActions(for: .editingChanged) // without this event the text colour doesn't update

        cityTextField.textContentType = .addressCity
        root.addSubview(cityTextField)
        cityTextField.contentHeight = UIConstants.textfieldHeight
        cityTextField.alignBelow(view: postalCodeTextField, withPadding: 16)
        cityTextField.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        validators.append(TextValidationComponent(cityTextField,
                                                  errorMessage: R.string.localizable.commonMissingAddressCity(),
                                                  validator: { textfield -> Bool in
                                                      !textfield.text!.isEmpty
        }))

        let horiz = ViewFactory.createHorizontalStack(spacing: 16)
        root.addSubview(horiz)
        horiz.alignBelow(view: cityTextField, withPadding: 16)
        horiz.pinToEdges(of: root, orientation: .horizontal, padding: UIConstants.margin)
        horiz.distribution = .fillEqually
        horiz.alignment = .fill

        if !isDeleteButtonHidden {
            let deleteButton = ViewFactory.createButton(text: R.string.localizable.delete_button_title())
            deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            deleteButton.rx.tap.bind { [weak self] in
                self?.deleteAction()
            }.disposed(by: bag)
            deleteButton.setTitleColor(UIColor.space, for: .normal)
            deleteButton.setImage(R.image.trashSimple(), for: .normal)
            deleteButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            deleteButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            deleteButton.setHeightAnchor(UIConstants.buttonHeight)
            horiz.addArrangedSubview(deleteButton)
            deleteButton.pinToEdges(of: horiz, orientation: .vertical)
        }

        let saveButton = ViewFactory.createPrimaryButton(text: R.string.localizable.save_button_title())
        saveButton.style = .shinyBlue
        saveButton.setHeightAnchor(UIConstants.buttonHeight)
        saveButton.rx.tap.bind { [weak self] in
            self?.saveAction()
        }.disposed(by: bag)
        horiz.addArrangedSubview(saveButton)
        saveButton.pinToEdges(of: horiz, orientation: .vertical)

        root.verticalPin(to: horiz, orientation: .bottom, padding: 16)

        configure(with: address)
    }
}

// MARK: - Private

private extension AddEditAddressViewController {
    func configure(with address: LegacyAddressInput?) {
        guard let address = address else { return }
        postalCodeTextField.text = address.postalCode
        line1Textfield.text = address.line1
        cityTextField.text = address.city
        countryTextfield.text = Country(rawValue: address.country)?.title
    }

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    func deleteAction() {
        delegate?.addEditAddressViewController(didDelete: address)
        navigationController?.popViewController(animated: true)
    }

    func saveAction() {
        guard validateData() else { return }
        delegate?.addEditAddressViewController(didSave: address)
        navigationController?.popViewController(animated: true)
    }

    func validateData() -> Bool {
        var isValid = true
        for validator in validators {
            isValid = validator.validate() && isValid
        }
        return isValid
    }
}
