//  
//  LoginView+ViewState.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public extension LoginView {
    struct ViewState: Equatable {
        public enum ContentLoadingState {
            case initial
            case loading
            case finished
            case failed
        }
        
        public enum MainButtonState {
            case `default`
            case inProgress
        }
        
        public var loadingState: ContentLoadingState = .initial
        public var authenticationFailedMessageIsVisible: Bool = false
        public var magicLinkInvalidMessageIsVisible: Bool = false
        public var model: Model
        public var magicLinkEmail: String
        public var magicLinkCode: String
        public var magicLinkCookie: String = ""
        public var magicLinkInvalidMessage: String = ""
        public var mainButtonState: MainButtonState = .default
        
        public static let initial = Self(loadingState: .initial,
                                         authenticationFailedMessageIsVisible: false,
                                         model: .initial,
                                         magicLinkEmail: "",
                                         magicLinkCode: "")
    }
}
