//
//  Address+UI.swift
//  Whoppah
//
//  Created by Eddie Long on 05/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Contacts
import Foundation
import WhoppahCore

extension LegacyAddress {
    public func formattedAddress(separator: String = ", ") -> String {
        let postalAddress = CNMutablePostalAddress()
        postalAddress.street = line1
        postalAddress.subLocality = line2 ?? ""
        postalAddress.postalCode = postalCode
        postalAddress.city = city

        if let displayCountry = displayCountry {
            postalAddress.country = displayCountry
        }

        postalAddress.isoCountryCode = country

        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: separator)
    }

    public var displayCountry: String? {
        let locale = NSLocale(localeIdentifier: country)
        return locale.displayName(forKey: NSLocale.Key.countryCode, value: country)
    }
}

extension LegacyAddressInput {
    public func formattedAddress(separator: String = ", ") -> String {
        let postalAddress = CNMutablePostalAddress()
        postalAddress.street = line1
        postalAddress.postalCode = postalCode
        postalAddress.city = city

        if let displayCountry = displayCountry {
            postalAddress.country = displayCountry
        }

        postalAddress.isoCountryCode = country

        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: separator)
    }

    public var displayCountry: String? {
        let locale = NSLocale(localeIdentifier: country)
        return locale.displayName(forKey: NSLocale.Key.countryCode, value: country)
    }
}
