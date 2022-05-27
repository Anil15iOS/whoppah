//
//  PasswordRequirementsObservable.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 18/01/2022.
//

import SwiftUI

class PasswordRequirementsObservable: ObservableObject {
    @Published var meetsMinimumCharacterCountRequirement = false
    @Published var meetsAtLeastOneLowerCaseRequirement = false
    @Published var meetsAtLeastOneDigitRequirement = false
    @Published var meetsAtLeaseOneUpperCaseRequirement = false
    
    var meetsAllRequirements: Bool {
        return meetsMinimumCharacterCountRequirement &&
        meetsAtLeastOneLowerCaseRequirement &&
        meetsAtLeastOneDigitRequirement &&
        meetsAtLeaseOneUpperCaseRequirement
    }
}
