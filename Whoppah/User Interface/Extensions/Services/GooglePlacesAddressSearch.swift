//
//  LocationService+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 18/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import GooglePlaces
import WhoppahCore

class GooglePlacesAddressSearch: NSObject {
    weak var sourceVC: UIViewController?
    typealias LocationCallback = (Result<LegacyAddressInput, Error>) -> Void
    var completion: LocationCallback?
    var addressId: UUID?
    private var validation = LegacyAddressInput.ValidationRequirement.all

    init(from vc: UIViewController) {
        sourceVC = vc
    }

    func search(country: String = "NL",
                addressId: UUID? = nil,
                validation: LegacyAddressInput.ValidationRequirement = .allNoBuilding,
                completion: @escaping LocationCallback) {
        self.completion = completion
        self.validation = validation
        self.addressId = addressId

        self.completion = completion
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue:
            UInt(GMSPlaceField.addressComponents.rawValue) |
                UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields

        autocompleteController.primaryTextColor = .darkGray
        autocompleteController.tableCellSeparatorColor = .smoke
        autocompleteController.secondaryTextColor = .smoke
        autocompleteController.primaryTextHighlightColor = .black
        autocompleteController.tableCellBackgroundColor = .white
        autocompleteController.tintColor = .white

        UINavigationBar.appearance(whenContainedInInstancesOf: [GMSAutocompleteViewController.self]).barTintColor = .white
        UINavigationBar.appearance(whenContainedInInstancesOf: [GMSAutocompleteViewController.self]).tintColor = .black

        let searchBarTextAttributes: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: 14.0)
        ]

        UITextField.appearance(whenContainedInInstancesOf: [GMSAutocompleteViewController.self]).defaultTextAttributes = searchBarTextAttributes

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = country
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        sourceVC?.present(autocompleteController, animated: true, completion: nil)
    }
}

extension GooglePlacesAddressSearch: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        var building = ""
        var street = ""
        var city = ""
        var postalCode = ""
        var state: String?
        var country: String?
        var political: String?
        var point: PointInput?
        if let components = place.addressComponents {
            for component in components {
                for type in component.types {
                    switch type {
                    case kGMSPlaceTypeStreetNumber:
                        building = component.name
                    case kGMSPlaceTypePostalCode:
                        postalCode = component.name
                    case kGMSPlaceTypeRoute, kGMSPlaceTypeStreetAddress:
                        street = component.name
                    case kGMSPlaceTypeLocality:
                        city = component.name
                    case kGMSPlaceTypeCountry:
                        country = component.shortName
                    case kGMSPlaceTypePolitical:
                        political = component.shortName
                    case kGMSPlaceTypeAdministrativeAreaLevel1:
                        state = component.name
                    default: break
                    }
                }
            }
        }

        let countryCode = country ?? political ?? ""
        point = PointInput(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        var address = LegacyAddressInput(id: addressId,
                                   line1: street,
                                   line2: "",
                                   postalCode: postalCode,
                                   city: city,
                                   state: state,
                                   country: countryCode,
                                   point: point)
        switch address.validate(requirement: validation) {
        case .success:
            // Do the manual building check if needed, otherwise success
            if building.isEmpty {
                if validation.contains(LegacyAddressInput.ValidationRequirement.building) {
                    viewController.showErrorDialog(message: R.string.localizable.search_places_missing_building())
                    return
                }
            } else {
                // Re-create with the correct street number
                let line1 = building.isEmpty ? street : "\(street) \(building)"
                address = LegacyAddressInput(id: addressId,
                                       line1: line1,
                                       line2: "",
                                       postalCode: postalCode,
                                       city: city,
                                       state: state,
                                       country: countryCode,
                                       point: point)
            }
            completion?(.success(address))
        case let .failure(error):
            switch error {
            case .missingStreet:
                viewController.showErrorDialog(message: R.string.localizable.search_places_missing_building())
            case .missingCity:
                viewController.showErrorDialog(message: R.string.localizable.search_places_missing_city())
            case .missingZip:
                viewController.showErrorDialog(message: R.string.localizable.search_places_missing_postcode())
            case .missingCountry:
                viewController.showErrorDialog(message: R.string.localizable.search_places_missing_country())
            case .missingCoordinate:
                viewController.showErrorDialog(message: R.string.localizable.search_places_missing_coordinate())
            }
        }
    }

    func viewController(_: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        completion?(.failure(error))
    }

    // User canceled the operation.
    func wasCancelled(_: GMSAutocompleteViewController) {
        sourceVC?.dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
