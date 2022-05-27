//
//  CheckboxValidatorComponent.swift
//  Whoppah
//
//  Created by Eddie Long on 23/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import UIKit

struct CheckboxValidatorComponent: ValidatorComponent {
    typealias ErrorValidator = ((CheckBox) -> Bool)
    let checkbox: CheckBox
    let errorColor: UIColor?
    let validateCB: ErrorValidator
    init(_ checkbox: CheckBox, errorColor: UIColor?, validator: @escaping ErrorValidator) {
        self.checkbox = checkbox
        self.errorColor = errorColor
        validateCB = validator
    }

    func validate() -> Bool {
        guard !validateCB(checkbox) else {
            checkbox.boxColor = nil
            return true
        }
        checkbox.boxColor = errorColor
        return false
    }
}
