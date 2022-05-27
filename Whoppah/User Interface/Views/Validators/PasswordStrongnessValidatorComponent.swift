//
//  PasswordStrongnessValidatorComponent.swift
//  Whoppah
//
//  Created by Eddie Long on 23/12/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation

struct PasswordStrongnessValidatorComponent: ValidatorComponent {
    typealias ErrorValidator = ((PasswordStrongnessView) -> Bool)
    let view: PasswordStrongnessView
    private let errorMessage: String?
    private let tf: WPTextField?

    init(_ view: PasswordStrongnessView, errorMessage: String? = nil, textfield: WPTextField? = nil) {
        self.view = view
        self.errorMessage = errorMessage
        tf = textfield
    }

    func validate() -> Bool {
        guard view.validate() else {
            tf?.errorMessage = errorMessage
            return false
        }
        tf?.errorMessage = nil
        return true
    }
}
