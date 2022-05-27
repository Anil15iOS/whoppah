//
//  Point.swift
//  WhoppahCore
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Contacts
import Foundation

public protocol Point {
    var longitude: Double { get }
    var latitude: Double { get }
}

public struct PointInput: Point {
    public let longitude: Double
    public let latitude: Double
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
