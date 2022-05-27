//  
//  RegistrationView+ViewState.swift
//  WhoppahUIIntegrationTest
//
//  Created by Dennis Ippel on 17/01/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public extension RegistrationView {
    struct ViewState: Equatable {
        public enum ContentLoadingState {
            case loading
            case finished
            case failed
        }
        
        public var signUpType: Model.SignUpType = .individual
        public var loadingState: ContentLoadingState = .loading
        public var model: Model
        public var registrationFailedMessageIsVisible = false
        public var registrationFailedMessage = ""
        public var emailAddressIsAvailable: Bool = false
        public var isUserLoggedIn: Bool = false
        public var didRaiseError: Bool = false
        
        public static let initial = Self(loadingState: .loading,
                                         model: .initial)
    }
}
