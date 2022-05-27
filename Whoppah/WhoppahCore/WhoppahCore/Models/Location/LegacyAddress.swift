//
//  Address.swift
//  WhoppahCore
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Contacts
import Foundation

public protocol AddressBasic {
    var id: UUID { get }
    var city: String { get }
    var country: String { get }
    var point: Point? { get }
}

public protocol LegacyAddress: AddressBasic {
    var id: UUID { get }
    var line1: String { get }
    var line2: String? { get }
    var postalCode: String { get }
    var city: String { get }
    var state: String? { get }
    var country: String { get }
    var point: Point? { get }
}

public struct LegacyAddressInput {
    public var id: UUID?
    public var line1: String
    public var line2: String?
    public var postalCode: String
    public var city: String
    public var state: String?
    public var country: String
    public var point: PointInput?

    public init(id: UUID? = nil,
                line1: String,
                line2: String? = nil,
                postalCode: String,
                city: String,
                state: String? = nil,
                country: String,
                point: PointInput? = nil) {
        self.id = id
        self.line1 = line1
        self.line2 = line2
        self.postalCode = postalCode
        self.city = city
        self.state = state
        self.country = country
        self.point = point
    }

    public init(address: LegacyAddress) {
        id = address.id
        line1 = address.line1
        line2 = address.line2
        postalCode = address.postalCode
        city = address.city
        state = address.state
        country = address.country
        if let point = address.point {
            self.point = PointInput(latitude: point.latitude, longitude: point.longitude)
        }
    }
}

public extension LegacyAddressInput {
    enum AddressError: Error {
        case missingZip
        case missingStreet
        case missingCountry
        case missingCity
        case missingCoordinate
    }

    struct ValidationRequirement: OptionSet {
        public let rawValue: UInt8
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public static let street = ValidationRequirement(rawValue: 1 << 0)
        public static let postcode = ValidationRequirement(rawValue: 1 << 1)
        public static let city = ValidationRequirement(rawValue: 1 << 2)
        public static let country = ValidationRequirement(rawValue: 1 << 3)
        public static let coordinate = ValidationRequirement(rawValue: 1 << 4)
        public static let building = ValidationRequirement(rawValue: 1 << 5) // Note - cannot be done directly on the addressInput
        public static let allNoBuilding = ValidationRequirement(arrayLiteral: street, postcode, city, country, coordinate)
        public static let all = ValidationRequirement(rawValue: UInt8.max)
    }

    func validate(requirement: ValidationRequirement) -> Result<Void, AddressError> {
        if requirement.contains(ValidationRequirement.street) { guard !line1.isEmpty else { return .failure(.missingStreet) } }
        if requirement.contains(ValidationRequirement.city) { guard !city.isEmpty else { return .failure(.missingCity) } }
        if requirement.contains(ValidationRequirement.postcode) { guard !postalCode.isEmpty else { return .failure(.missingZip) } }
        if requirement.contains(ValidationRequirement.country) { guard !country.isEmpty else { return .failure(.missingCountry) } }
        if requirement.contains(ValidationRequirement.coordinate) { guard point != nil else { return .failure(.missingCoordinate) } }
        return .success(())
    }

    func isValid() -> Bool {
        switch validate(requirement: ValidationRequirement.all) {
        case .success:
            return true
        default:
            return false
        }
    }
}
