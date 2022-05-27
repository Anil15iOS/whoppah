//
//  RegistrationPasswordRequirements.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 18/01/2022.
//

import SwiftUI

struct RegistrationPasswordRequirements: View {
    @ObservedObject private var passwordRequirementsObservable: PasswordRequirementsObservable
    
    private let requirements: PasswordRequirements
    
    private let checkValidColor = WhoppahTheme.Color.alert2
    private let checkInvalidColor = WhoppahTheme.Color.base2
    private let textValidColor = WhoppahTheme.Color.base1
    private let textInvalidColor = WhoppahTheme.Color.base2
    
    init(passwordRequirementsObservable: PasswordRequirementsObservable,
         requirements: PasswordRequirements)
    {
        self.passwordRequirementsObservable = passwordRequirementsObservable
        self.requirements = requirements
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: WhoppahTheme.Size.Padding.tiny) {
            makeRequirement(title: requirements.meetsMinimumCharacterCountRequirement,
                            valid: passwordRequirementsObservable.meetsMinimumCharacterCountRequirement)
            makeRequirement(title: requirements.meetsAtLeastOneLowerCaseRequirement,
                            valid: passwordRequirementsObservable.meetsAtLeastOneLowerCaseRequirement)
            makeRequirement(title: requirements.meetsAtLeastOneDigitRequirement,
                            valid: passwordRequirementsObservable.meetsAtLeastOneDigitRequirement)
            makeRequirement(title: requirements.meetsAtLeaseOneUpperCaseRequirement,
                            valid: passwordRequirementsObservable.meetsAtLeaseOneUpperCaseRequirement)
        }
    }
    
    @ViewBuilder func makeRequirement(title: String, valid: Bool) -> some View {
        HStack {
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 10, height: 8)
                .foregroundColor(valid ? checkValidColor : checkInvalidColor)
            Text(title)
                .font(WhoppahTheme.Font.caption)
                .foregroundColor(valid ? textValidColor : textInvalidColor)
            Spacer()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPasswordRequirements(passwordRequirementsObservable: .init(),
                                         requirements: .initial)
    }
}
