//
//  AddressEnterViews.swift
//  Whoppah
//
//  Created by Eddie Long on 22/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SkyFloatingLabelTextField
import UIKit

class AddressEntryViews: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var postalCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet var buildingTextField: SkyFloatingLabelTextField!
    @IBOutlet var streetTextField: SkyFloatingLabelTextField!
    @IBOutlet var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet var countryDropdown: CountryDropdown!
    var isValid = BehaviorRelay<Bool>(value: false)

    private let bag = DisposeBag()
    var address: Location?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("AddressEntryViews", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        postalCodeTextField.delegate = self
        postalCodeTextField.placeholder = R.string.localizable.add_address_postcode_placeholder()
        buildingTextField.delegate = self
        buildingTextField.placeholder = R.string.localizable.add_address_house_number_placeholder()
        streetTextField.delegate = self
        streetTextField.placeholder = R.string.localizable.add_address_street_placeholder()
        cityTextField.delegate = self
        cityTextField.placeholder = R.string.localizable.add_address_city_placeholder()

        let allFields = Observable.combineLatest(postalCodeTextField.rx.text.orEmpty.distinctUntilChanged(),
                                                 buildingTextField.rx.text.orEmpty.distinctUntilChanged(),
                                                 streetTextField.rx.text.orEmpty.distinctUntilChanged(),
                                                 cityTextField.rx.text.orEmpty.distinctUntilChanged(),
                                                 countryDropdown.selected)

        allFields.map {
            !$0.0.isEmpty &&
                !$0.1.isEmpty &&
                !$0.2.isEmpty &&
                !$0.3.isEmpty
        }.bind(to: isValid).disposed(by: bag)

        allFields
            .filter {
                !$0.0.isEmpty &&
                    !$0.1.isEmpty &&
                    !$0.2.isEmpty &&
                    !$0.3.isEmpty
            }
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)

            .subscribe(onNext: { postcode, building, street, city, country in
                let isoCountry = country.toISOCode()
                ServiceProvider.shared.location.coordinate(forHouse: building, street: street, city: city, postalCode: postcode, isoCountryCode: isoCountry, completion: { coord, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let coord = coord {
                        print(coord)
                        self.address?.point = Point(coords: [coord.longitude, coord.latitude])
                    }
                })
            }).disposed(by: bag)

        postalCodeTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] in self?.address?.zipCode = $0 }).disposed(by: bag)
        postalCodeTextField.rx.text.orEmpty.filter { !$0.isEmpty }.subscribe(onNext: { [weak self] _ in self?.postalCodeTextField.errorMessage = nil }).disposed(by: bag)
        buildingTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] in self?.address?.building = $0 }).disposed(by: bag)
        buildingTextField.rx.text.orEmpty.filter { !$0.isEmpty }.subscribe(onNext: { [weak self] _ in self?.buildingTextField.errorMessage = nil }).disposed(by: bag)
        streetTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] in self?.address?.street = $0 }).disposed(by: bag)
        streetTextField.rx.text.orEmpty.filter { !$0.isEmpty }.subscribe(onNext: { [weak self] _ in self?.streetTextField.errorMessage = nil }).disposed(by: bag)
        cityTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] in self?.address?.city = $0 }).disposed(by: bag)
        cityTextField.rx.text.orEmpty.filter { !$0.isEmpty }.subscribe(onNext: { [weak self] _ in self?.cityTextField.errorMessage = nil }).disposed(by: bag)

        countryDropdown.selected.subscribe(onNext: { [weak self] option in
            self?.address?.country = option.toString()
        }).disposed(by: bag)
    }

    func configure(address: Location?) {
        self.address = address
        postalCodeTextField.text = address?.zipCode
        postalCodeTextField.sendActions(for: .valueChanged)
        postalCodeTextField.isEnabled = true
        if let building = address?.building {
            buildingTextField.text = "\(building)"
        }

        buildingTextField.isEnabled = true
        buildingTextField.sendActions(for: .valueChanged)
        streetTextField.text = address?.street
        streetTextField.isEnabled = true
        streetTextField.sendActions(for: .valueChanged)
        cityTextField.text = address?.city
        cityTextField.isEnabled = true
        cityTextField.sendActions(for: .valueChanged)
    }

    func validate() -> Bool {
        if postalCodeTextField.text!.isEmpty {
            postalCodeTextField.errorMessage = R.string.localizable.missing_address_postcode()
        } else {
            postalCodeTextField.errorMessage = nil
        }
        if buildingTextField.text!.isEmpty {
            buildingTextField.errorMessage = R.string.localizable.missing_address_house()
        } else {
            buildingTextField.errorMessage = nil
        }
        if streetTextField.text!.isEmpty {
            streetTextField.errorMessage = R.string.localizable.missing_address_street()
        } else {
            streetTextField.errorMessage = nil
        }
        if cityTextField.text!.isEmpty {
            cityTextField.errorMessage = R.string.localizable.missing_address_city()
        } else {
            cityTextField.errorMessage = nil
        }
        return isValid.value
    }
}

extension AddressEntryViews: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
