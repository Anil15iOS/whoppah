//
//  TextValidatorComponent.swift
//  Whoppah
//
//  Created by Eddie Long on 23/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

struct TextValidationComponent: ValidatorComponent {
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
        guard !validateCB(tf) else {
            tf.errorMessage = nil
            return true
        }
        tf.errorMessage = errorMessage
        return false
    }
}
