//
//  SocialAuthenticating.swift
//  WhoppahCoreNext
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Combine
import Foundation
import WhoppahModel

public enum SocialSignupError: Error {
    case emailAlreadyExists(email: String)
    case missingUserInfo
}

public protocol SocialAuthenticating: UserAuthenticating {
    func authorize(authMode: SocialAuthenticationMode,
                   merchantType: MerchantType?) -> AnyPublisher<UserAccessToken, Error>
    
    func signIn(withAuthToken authToken: String,
                complete: (() -> Void)?)
}
