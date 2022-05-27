//
//  PhoneNumberValidator.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 17/01/2022.
//

import Foundation
import PhoneNumberKit

struct PhoneNumberValidator: TextInputValidatable {
    let failedMessage: String
    let phoneNumberKit = PhoneNumberKit()
    
    init(_ failedMessage: String) {
        self.failedMessage = failedMessage
    }
    
    func isValid(_ input: String) -> Bool {
        return phoneNumberKit.isValidPhoneNumber(input)
    }
}
