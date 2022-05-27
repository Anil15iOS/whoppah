//
//  PasswordRequirements.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 18/01/2022.
//

import Foundation

public struct PasswordRequirements: Equatable {
    let meetsMinimumCharacterCountRequirement: String
    let meetsAtLeastOneLowerCaseRequirement: String
    let meetsAtLeastOneDigitRequirement: String
    let meetsAtLeaseOneUpperCaseRequirement: String
    
    static var initial = Self(
        meetsMinimumCharacterCountRequirement: "",
        meetsAtLeastOneLowerCaseRequirement: "",
        meetsAtLeastOneDigitRequirement: "",
        meetsAtLeaseOneUpperCaseRequirement: "")

    public init(
        meetsMinimumCharacterCountRequirement: String,
        meetsAtLeastOneLowerCaseRequirement: String,
        meetsAtLeastOneDigitRequirement: String,
        meetsAtLeaseOneUpperCaseRequirement: String) {
            self.meetsMinimumCharacterCountRequirement = meetsMinimumCharacterCountRequirement
            self.meetsAtLeastOneDigitRequirement = meetsAtLeastOneDigitRequirement
            self.meetsAtLeastOneLowerCaseRequirement = meetsAtLeastOneLowerCaseRequirement
            self.meetsAtLeaseOneUpperCaseRequirement = meetsAtLeaseOneUpperCaseRequirement
    }
}
