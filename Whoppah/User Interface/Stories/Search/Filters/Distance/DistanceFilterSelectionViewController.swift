//
//  DistanceFilterSelectionViewController.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import WhoppahCore

class DistanceFilterSelectionViewController: UIViewController {
    var viewModel: DistanceFilterSelectionViewModel!
    private var placesSearcher: GooglePlacesAddressSearch!
    private let bag = DisposeBag()

    lazy var navigationBar: NavigationBar = {
        let navigationBar = NavigationBar(frame: .zero)
        navigationBar.titleLabel.text = R.string.localizable.search_filters_distance_from_you_title()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .h2
        label.text = R.string.localizable.search_filters_distance_your_location_title()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var countryDropdown: WPCountryTextField = {
        let dropdown = ViewFactory.createCountryTextField(placeholder: R.string.localizable.add_address_country_placeholder())
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        return dropdown
    }()

    lazy var searchTextField: WPTextField = {
        let textField = WPTextField(frame: .zero)
        textField.placeholder = R.string.localizable.set_profile_google_search_placeholder()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var radiusTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .h2
        label.text = R.string.localizable.search_filters_distance_maximum_distance_title()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var radiusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .bodySemibold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var radiusSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
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
        placesSearcher = GooglePlacesAddressSearch(from: self)
        viewModel.load()
    }
}

// MARK: - UITextFieldDelegate

extension DistanceFilterSelectionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_: UITextField) {
        let country = Country.allCases[countryDropdown.picker.selectedRow(inComponent: 0)]
        let validation: LegacyAddressInput.ValidationRequirement = [.coordinate]
        placesSearcher.search(country: country.rawValue, validation: validation) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(location):
                self.viewModel.inputs.address.onNext(location)
                self.searchTextField.text = location.formattedAddress()
                self.dismiss(animated: true, completion: nil)
            case let .failure(error):
                self.showError(error)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Private

private extension DistanceFilterSelectionViewController {
    func setupBindings() {
        navigationBar.backButton.rx.tap
            .bind(to: viewModel.inputs.dismiss)
            .disposed(by: bag)

        countryDropdown.picker.rx.itemSelected
            .map { Country.allCases[$0.0].title }
            .bind(to: countryDropdown.rx.text).disposed(by: bag)

        viewModel.outputs.address.bind { [weak self] address in
            guard let self = self, let address = address else { return }
            self.countryDropdown.text = Country(rawValue: address.country)?.title
        }.disposed(by: bag)
        viewModel.outputs.address
            .map { $0?.formattedAddress() }
            .bind(to: searchTextField.rx.text)
            .disposed(by: bag)

        viewModel.outputs.radius.map {
            Float($0) / Float(defaultRadiusKm)
        }.bind(to: radiusSlider.rx.value).disposed(by: bag)
        viewModel.outputs.radius.map {
            String(format: "%d", $0)
        }.bind(to: radiusLabel.rx.text).disposed(by: bag)

        radiusSlider.rx.value.map {
            Int($0 * Float(defaultRadiusKm))
        }.bind(to: viewModel.inputs.radius).disposed(by: bag)

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
        view.addSubview(countryDropdown)
        view.addSubview(searchTextField)
        view.addSubview(radiusTitle)
        view.addSubview(radiusSlider)
        view.addSubview(radiusLabel)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 76),

            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            countryDropdown.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            countryDropdown.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            countryDropdown.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.topAnchor.constraint(equalTo: countryDropdown.bottomAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 56),

            radiusTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            radiusTitle.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 32),
            radiusTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            radiusSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            radiusSlider.topAnchor.constraint(equalTo: radiusTitle.bottomAnchor, constant: 22),
            radiusSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            radiusLabel.bottomAnchor.constraint(equalTo: radiusSlider.topAnchor),
            radiusLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
