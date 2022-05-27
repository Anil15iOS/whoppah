//
//  LoginView+NavigationView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 01/02/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public extension LoginView {
    enum NavigationView: Equatable, NavigatableView {
        case none
        case login
        case forgotPasswordConfirmation
        case forgotPassword
        case magicLinkEmail
        case magicLinkEnterCode
        
        public var identifier: String {
            switch self {
            case .none: return "none"
            case .login: return "login"
            case .forgotPassword: return "forgotPassword"
            case .forgotPasswordConfirmation: return "forgotPasswordConfirmation"
            case .magicLinkEmail: return "magicLinkEmail"
            case .magicLinkEnterCode: return "magicLinkEnterCode"
            }
        }
    }
}

extension LoginView {
    @ViewBuilder
    func produceView(_ view: NavigationView,
                     store: Store<LoginView.ViewState, LoginView.Action>,
                     navigationTitle: Binding<String>) -> some View
    {
        switch view {
        case .forgotPassword:
            ForgotPasswordView(store: store,
                                      navigationTitle: navigationTitle)
        default:
            EmptyView()
        }
    }
}
