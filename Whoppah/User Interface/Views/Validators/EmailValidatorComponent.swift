//
//  EmailValidatorComponent.swift
//  Whoppah
//
//  Created by Eddie Long on 02/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation

struct EmailValidationComponent: ValidatorComponent {
    typealias ErrorValidator = ((WPTextField) -> Bool)
    let tf: WPTextField
    let errorMessage: String?
    let validateCB: ErrorValidator
    init(_ tf: WPTextField, errorMessage: String?, validator: @escaping ErrorValidator) {
        self.tf = tf
        self.errorMessage = errorMessage
        validateCB = validator
    }

    func validate() -> Bool {
        guard tf.text?.isValidEmail() == true else {
            tf.errorMessage = errorMessage
            return false
        }
        tf.errorMessage = nil
        return true
    }
}
