//
//  AdAnnotation.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/4/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import MapKit
import WhoppahCore

// MARK: - MKAnnotation

public class AdAnnotation: NSObject, MKAnnotation {
    var ad: WhoppahCore.Product?
    var adDetails: ProductDetails?
    var adCoordinate: CLLocationCoordinate2D?

    public var coordinate: CLLocationCoordinate2D {
        adCoordinate ?? kCLLocationCoordinate2DInvalid
    }
}
