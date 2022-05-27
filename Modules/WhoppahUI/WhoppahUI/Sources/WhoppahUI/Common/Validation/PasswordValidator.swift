//
//  PasswordValidator.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 18/01/2022.
//

import Foundation

struct PasswordValidator: TextInputValidatable {
    private let upperCaseRegEx = ".*[A-Z]+.*"
    private let numberRegEx = ".*[0-9]+.*"
    private let lowerCaseRegEx = ".*[a-z]+.*"
    
    let failedMessage: String
    private let passwordRequirementsObservable: PasswordRequirementsObservable
    
    init(_ failedMessage: String) {
        self.failedMessage = failedMessage
        self.passwordRequirementsObservable = .init()
    }
    
    init(_ passwordRequirementsObservable: PasswordRequirementsObservable) {
        self.failedMessage = ""
        self.passwordRequirementsObservable = passwordRequirementsObservable
    }
    
    func isValid(_ input: String) -> Bool {
        passwordRequirementsObservable.meetsMinimumCharacterCountRequirement = input.length >= 8
        
        let upperCaseTest = NSPredicate(format: "SELF MATCHES %@", upperCaseRegEx)
        passwordRequirementsObservable.meetsAtLeaseOneUpperCaseRequirement = upperCaseTest.evaluate(with: input)
        let lowerCaseTest = NSPredicate(format: "SELF MATCHES %@", lowerCaseRegEx)
        passwordRequirementsObservable.meetsAtLeastOneLowerCaseRequirement = lowerCaseTest.evaluate(with: input)
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        passwordRequirementsObservable.meetsAtLeastOneDigitRequirement = numberTest.evaluate(with: input)

        return passwordRequirementsObservable.meetsAllRequirements
    }
}
