//
//  CLLocationCoordinate2D+Extensions.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 25/04/2022.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}
