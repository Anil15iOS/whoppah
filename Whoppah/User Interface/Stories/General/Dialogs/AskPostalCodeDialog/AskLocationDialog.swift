//
//  AskPostalCodeDialog.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/20/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver

class AskLocationDialog: BaseDialog {
    // MARK: - IBOutlets

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchTextfield: WPTextField!
    @IBOutlet var countryDropdown: CountryDropdown!
    @IBOutlet var searchButton: PrimaryLargeButton!

    // MARK: - Properties

    typealias LocationSelected = (LegacyAddressInput) -> Void
    var onLocationSelected: LocationSelected?
    private var placesSearcher: GooglePlacesAddressSearch!
    private var selectedAddress: LegacyAddressInput?

    // MARK: - ViewController's Life Cycle
    
    @Injected private var userService: WhoppahCore.LegacyUserService

    override func viewDidLoad() {
        super.viewDidLoad()

        placesSearcher = GooglePlacesAddressSearch(from: self)
        setUpButtons()
        setUpDropdown()
        setUpTextField()
        updateStrings()
    }

    // MARK: - Private

    private func setUpButtons() {
        searchButton.style = .primary
        searchButton.isEnabled = false
    }

    private func setUpTextField() {
        searchTextfield.placeholder = R.string.localizable.set_profile_google_search_placeholder()
        searchTextfield.delegate = self
    }

    private func setUpDropdown() {
        if let user = try? userService.active.value() {
            if let address = user.mainMerchant.address.first {
                countryDropdown.setFrom(address: address)
            }
        }
    }

    private func updateStrings() {
        titleLabel.text = R.string.localizable.search_ask_postcode_title().uppercased()
    }

    // MARK: - Actions

    @IBAction func searchAction(_: PrimaryLargeButton) {
        if let location = selectedAddress {
            onLocationSelected?(location)
            dismiss(animated: true, completion: nil)
        } else {
            searchTextfield.errorMessage = "Voeg uw productlocatie toe"
        }
    }
}

extension AskLocationDialog: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchTextfield {
            searchTextfield.errorMessage = nil
            let validation: LegacyAddressInput.ValidationRequirement = [.coordinate]
            placesSearcher.search(country: countryDropdown.selectedDropdown.rawValue, validation: validation) { result in
                switch result {
                case let .success(location):
                    self.searchButton.isEnabled = true
                    self.selectedAddress = location
                    self.searchTextfield.text = location.formattedAddress()
                    self.dismiss(animated: true, completion: nil)
                case let .failure(error):
                    self.showError(error)
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
