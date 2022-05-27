//
//  PhoneNumberFormatter.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 17/01/2022.
//

import Foundation
import PhoneNumberKit

struct PhoneNumberFormatter: TextInputFormattable {
    let phoneNumberKit = PhoneNumberKit()
    func format(_ input: String) -> String {
        if let phoneNumber = try? phoneNumberKit.parse(input) {
            return phoneNumberKit.format(phoneNumber, toType: .international)
        } else {
            return PartialFormatter().formatPartial(input)
        }
    }
}
