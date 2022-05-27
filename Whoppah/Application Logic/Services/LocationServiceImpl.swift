//
//  LocationService.swift
//  Whoppah
//
//  Created by Boris Sagan on 11/5/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import CoreLocation
import Foundation
import WhoppahCore

class LocationServiceImpl: NSObject, LocationService {
    // MARK: - Properties

    var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    private let locationHelper = LocationServiceBlocks()

    // MARK: - ServiceInterface
    
    override public init() {
        super.init()
        locationManager.delegate = locationHelper
    }

    // MARK: - Geocoding

    func address(by location: CLLocation, completion: @escaping (String?, CLPlacemark?, Error?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { [unowned self] placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, nil, error)
                return
            }

            let compactAddress = self.compactAddress(placemark: placemark)
            completion(compactAddress, placemark, nil)
        }
    }

    // MARK: - Private

    private func compactAddress(placemark: CLPlacemark) -> String? {
        if let city = placemark.locality {
            var result = city

            if let street = placemark.thoroughfare {
                result += ", \(street)"
            }

            if let number = placemark.subThoroughfare {
                result += ", \(number)"
            }

            return result
        }
        return nil
    }
}

private class LocationServiceBlocks: NSObject, CLLocationManagerDelegate {
    struct LocationAuthStatus {
        let manager: CLLocationManager
        let status: CLAuthorizationStatus
    }

    typealias OnAuthorizationChange = ((LocationAuthStatus) -> Void)
    var onAuthorizationChange: OnAuthorizationChange?

    typealias LocationFetchResult = Result<[CLLocation], Error>
    typealias OnLocationChanged = ((LocationFetchResult) -> Void)
    var onLocationUpdated: OnLocationChanged?

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        onAuthorizationChange?(LocationAuthStatus(manager: manager, status: status))
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        onLocationUpdated?(.failure(error))
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onLocationUpdated?(.success(locations))
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationServiceImpl: CLLocationManagerDelegate {}
