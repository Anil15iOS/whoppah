//
//  RegistrationView+NavigationView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 26/01/2022.
//

import Foundation

extension RegistrationView {
    enum NavigationView: Equatable, NavigatableView {
        case none
        case businessAddress
        case businessInfo
        case choosePassword
        case enterPhoneNumber
        case enterUsernameBusiness
        case enterUsernameIndividual
        
        public var identifier: String {
            switch self {
            case .none: return "none"
            case .businessAddress: return "businessAddress"
            case .businessInfo: return "businessInfo"
            case .choosePassword: return "choosePassword"
            case .enterPhoneNumber: return "enterPhoneNumber"
            case .enterUsernameBusiness: return "enterUsernameBusiness"
            case .enterUsernameIndividual: return "enterUsernameIndividual"
            }
        }
    }
}
