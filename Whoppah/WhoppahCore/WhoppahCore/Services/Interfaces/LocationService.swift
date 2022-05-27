//
//  LocationService.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import CoreLocation
import Foundation

public protocol LocationService {
    // MARK: - Properties

    /// The user's current location
    var currentLocation: CLLocation? { get }

    // MARK: - Geocoding

    /// Searches for an address given a zipcode
    ///
    /// - Parameter by The zipcode to search for the address
    /// - Parameter paymentMethod The payment method to use for payment
    /// - Parameter paymentMethodId The payment method id. This could may be nil if using a method like iDeal, or it can be a credit card Stripe method id
    /// - Returns: An observable with the newly created payment data
    func address(by location: CLLocation, completion: @escaping (String?, CLPlacemark?, Error?) -> Void)
}
