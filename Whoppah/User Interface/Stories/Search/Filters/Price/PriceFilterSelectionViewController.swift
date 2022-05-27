//
//  PriceFilterSelectionViewController.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import WhoppahCore

class PriceFilterSelectionViewController: UIViewController {
    var viewModel: PriceFilterSelectionViewModel!
    private let bag = DisposeBag()

    lazy var navigationBar: NavigationBar = {
        let navigationBar = NavigationBar(frame: .zero)
        navigationBar.titleLabel.text = R.string.localizable.search_filters_price_only_title()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .h2
        label.text = R.string.localizable.search_filters_price_subtitle()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var minPriceTextField: WPTextField = {
        let textField = WPTextField(frame: .zero)
        textField.placeholder = R.string.localizable.search_filters_price_from()
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    lazy var maxPriceTextField: WPTextField = {
        let textField = WPTextField(frame: .zero)
        textField.placeholder = R.string.localizable.search_filters_price_to()
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    lazy var saveButton: PrimaryLargeButton = {
        let button = PrimaryLargeButton(frame: .zero)
        button.setTitle(R.string.localizable.commonSave(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupBindings()
        viewModel.load()
    }
}

// MARK: - UITextFieldDelegate

extension PriceFilterSelectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Private

private extension PriceFilterSelectionViewController {
    func setupBindings() {
        navigationBar.backButton.rx.tap
            .bind(to: viewModel.inputs.dismiss)
            .disposed(by: bag)

        viewModel.outputs.minPrice
            .bind(to: minPriceTextField.rx.text)
            .disposed(by: bag)
        minPriceTextField.rx.text
            .bind(to: viewModel.inputs.minPrice)
            .disposed(by: bag)

        viewModel.outputs.maxPrice
            .bind(to: maxPriceTextField.rx.text)
            .disposed(by: bag)
        maxPriceTextField.rx.text
            .bind(to: viewModel.inputs.maxPrice)
            .disposed(by: bag)

        viewModel.outputs.saveEnabled
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: bag)
        saveButton.rx.tap
            .bind(to: viewModel.inputs.save)
            .disposed(by: bag)
    }

    func setupConstraints() {
        view.addSubview(navigationBar)
        view.addSubview(titleLabel)
        view.addSubview(minPriceTextField)
        view.addSubview(maxPriceTextField)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 76),

            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            minPriceTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            minPriceTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            minPriceTextField.heightAnchor.constraint(equalToConstant: 56),
            minPriceTextField.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 32),

            maxPriceTextField.leadingAnchor.constraint(equalTo: minPriceTextField.trailingAnchor, constant: 16),
            maxPriceTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            maxPriceTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            maxPriceTextField.heightAnchor.constraint(equalToConstant: 56),

            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
