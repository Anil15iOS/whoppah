//
//  CountryDropdown.swift
//  Whoppah
//
//  Created by Eddie Long on 03/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class CountryDropdown: UIStackView {
    @IBOutlet var countryTextfield: WPTextField!

    private var countryDropdown: DropdownView!
    var selectedDropdown = Country.netherlands {
        didSet {
            guard let selected = countryDropdown.items.first(where: { $0.ID == selectedDropdown.rawValue }) else { return }
            countryTextfield.text = selected.name
        }
    }

    private var countryHeight: NSLayoutConstraint!
    private var isDropdownOpened: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        countryDropdown = DropdownView()
        countryDropdown.delegate = self
        countryDropdown.allowsMultipleSelection = false
        countryHeight = countryDropdown.heightAnchor.constraint(equalToConstant: 48.0)
        countryHeight.isActive = true
        countryDropdown.isHidden = true
       
        var items = [DropdownItem]()
        for country in Country.allCases {
            items.append(DropdownItem(ID: country.rawValue, name: country.title))
        }
        countryDropdown.items = items
        countryHeight.constant = CGFloat(items.count) * 48.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        addArrangedSubview(countryDropdown)

        if let item = countryDropdown.items.first(where: { $0.ID == selectedDropdown.rawValue }) {
            item.isSelected = true
            countryTextfield.text = item.name
        }
        countryTextfield.delegate = self

        let imageView = UIImageView(image: R.image.ic_arrow_small_bottom())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        superview?.addSubview(imageView)
        imageView.trailingAnchor.constraint(equalTo: countryDropdown.trailingAnchor, constant: -16).isActive = true
        imageView.centerYAnchor.constraint(equalTo: countryTextfield.centerYAnchor, constant: 8).isActive = true
    }

    private func setFromCountry(_ country: String?) {
        if let country = country {
            let countries = Country.allCases.map { $0.rawValue.lowercased() }
            if let match = countries.firstIndex(where: { $0 == country.lowercased() }) {
                selectedDropdown = Country.allCases[match]
            } else {
                selectedDropdown = .netherlands
            }
        } else {
            selectedDropdown = .netherlands
        }
    }

    func setFrom(address: LegacyAddressInput?) {
        setFromCountry(address?.country)
    }

    func setFrom(address: LegacyAddress?) {
        setFromCountry(address?.country)
    }
}

// MARK: - DropdownViewDelegate

extension CountryDropdown: DropdownViewDelegate {
    func dropdownView(_: DropdownView, didSelect item: DropdownItem) {
        countryTextfield.text = item.name
        isDropdownOpened = false
        countryDropdown.isHidden = true
        let selectedItems = countryDropdown.getSelectedItems()
        if let firstItem = selectedItems.first {
            selectedDropdown = Country.allCases[firstItem]
        }
    }

    func dropdownView(_: DropdownView, didDeselect _: DropdownItem) {}
}

// MARK: - UITextFieldDelegate

extension CountryDropdown: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryTextfield {
            isDropdownOpened = !isDropdownOpened
            countryDropdown.isHidden = !isDropdownOpened
            return false
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
