//
//  EditBankDetailsViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 26/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

private let defaultDate = Date(timeIntervalSince1970: 1_041_382_801)
private let stripeMinAgeAllowed = 13

class EditBankDetailsViewController: UIViewController {
    var viewModel: BankDetailsViewModel!

    // MARK: - IBOutlets
    
    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var paymentDetailsLabel: UILabel!
    @IBOutlet var nameLabel: WPTextField!
    @IBOutlet var ibanLabel: WPTextField!
    @IBOutlet var saveButton: PrimaryLargeButton!
    @IBOutlet weak var dateOfBirthTextField: WPTextField!
    
    // MARK: - Properties
    
    private let datePicker = UIDatePicker()
    private let formatter = DateFormatter()
    
    private let bag = DisposeBag()

    // MARK: - ViewController's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current

        setUpNavigationBar()
        setUpBindings()
        setUpTextFields()
        setUpDatePicker()
    }
}

// MARK: Private

private extension EditBankDetailsViewController {
    func setUpNavigationBar() {
        navigationBar.backButton.rx.tap.bind { [weak self] in
            self?.viewModel.dismiss()
        }.disposed(by: bag)
    }

    func setUpBindings() {
        viewModel.outputs.title.bind(to: paymentDetailsLabel.rx.text).disposed(by: bag)

        viewModel.outputs.name.bind(to: nameLabel.rx.text).disposed(by: bag)
        nameLabel.rx.text.orEmpty.bind(to: viewModel.inputs.name).disposed(by: bag)
        viewModel.outputs.iban.bind(to: ibanLabel.rx.text).disposed(by: bag)
        ibanLabel.rx.text.orEmpty.bind(to: viewModel.inputs.iban).disposed(by: bag)

        viewModel.outputs.saveEnabled.bind(to: saveButton.rx.isEnabled).disposed(by: bag)

        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.save()
        }.disposed(by: bag)
    }

    func setUpTextFields() {
        nameLabel.placeholder = R.string.localizable.editBankNamePlaceholder()
        ibanLabel.placeholder = R.string.localizable.editBankIbanPlaceholder()
        
        viewModel.outputs.dob.compactMap { $0 ?? defaultDate }.bind(to: datePicker.rx.date).disposed(by: bag)
        
        viewModel.outputs.dob.compactMap { [weak self] (date) -> String in
            guard let date = date else { return "" }
            return self?.formatter.string(from: date) ?? ""
        }.bind(to: dateOfBirthTextField.rx.text).disposed(by: bag)
    }
    
    private func setUpDatePicker() {
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        let now = Date()
        var minusMinYears = DateComponents()
        minusMinYears.year = -stripeMinAgeAllowed
        let minDate = Calendar.current.date(byAdding: minusMinYears, to: now)
        datePicker.maximumDate = minDate
        datePicker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.placeholder = R.string.localizable.commonDateOfBirth()
    }
    
    // MARK: - Actions
    
    @objc func datePicked(picker: UIDatePicker) {
        viewModel.inputs.dob.onNext(picker.date)
        dateOfBirthTextField.text = formatter.string(from: picker.date)
    }
    
}
