//
//  PhoneValidatorComponent.swift
//  Whoppah
//
//  Created by Eddie Long on 03/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation

struct PhoneValidationComponent: ValidatorComponent {
    typealias ErrorValidator = ((WPPhoneNumber) -> Bool)
    let phone: WPPhoneNumber
    let validateCB: ErrorValidator
    let errorMessage: String?
    init(_ phone: WPPhoneNumber, errorMessage: String? = nil, validator: @escaping ErrorValidator) {
        self.phone = phone
        self.errorMessage = errorMessage
        validateCB = validator
    }

    func validate() -> Bool {
        guard validateCB(phone) else {
            phone.errorMessage = errorMessage
            phone.borderColor = R.color.redInvalidLight()
            return false
        }
        phone.errorMessage = nil
        phone.borderColor = nil
        return true
    }
}
