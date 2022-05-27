//
//  ViewBankDetailsViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 28/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore

class ViewBankDetailsViewController: UIViewController {
    var viewModel: BankDetailsViewModel!
    private let bag = DisposeBag()
    private let formatter = DateFormatter()

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var nameLabel: WPTextField!
    @IBOutlet var ibanLabel: WPTextField!
    @IBOutlet weak var dateOfBirthTextField: WPTextField!
    @IBOutlet var adjustButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current

        setUpNavigationBar()
        setUpBindings()
        setUpTextFields()
    }
}

private extension ViewBankDetailsViewController {
    func setUpBindings() {
        viewModel.outputs.name.bind(to: nameLabel.rx.text).disposed(by: bag)
        nameLabel.rx.text.orEmpty.bind(to: viewModel.inputs.name).disposed(by: bag)
        
        viewModel.outputs.iban.bind(to: ibanLabel.rx.text).disposed(by: bag)
        ibanLabel.rx.text.orEmpty.bind(to: viewModel.inputs.iban).disposed(by: bag)
       
        viewModel.outputs.dob.compactMap { [weak self] (date) -> String in
            guard let date = date else { return "" }
            return self?.formatter.string(from: date) ?? ""
        }.bind(to: dateOfBirthTextField.rx.text).disposed(by: bag)

        adjustButton.rx.tap.bind { [weak self] in
            self?.viewModel.editDetails()
        }.disposed(by: bag)
    }

    func setUpNavigationBar() {
        navigationBar.backButton.rx.tap.bind { [weak self] in
            self?.viewModel.dismiss()
        }.disposed(by: bag)
    }

    func setUpTextFields() {
        nameLabel.placeholder = R.string.localizable.editBankNamePlaceholder()
        ibanLabel.placeholder = R.string.localizable.editBankIbanPlaceholder()
        dateOfBirthTextField.placeholder = R.string.localizable.commonDateOfBirth()
    }
}
