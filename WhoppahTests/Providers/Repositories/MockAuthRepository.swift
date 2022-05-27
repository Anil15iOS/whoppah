//
//  MockAuthRepository.swift
//  WhoppahTests
//
//  Created by Dennis Ippel on 13/01/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahModel
import WhoppahRepository
import Combine

class MockAuthRepository: AuthRepository {
    var loginEmail: String?
    var loginPassword: String?
    var token = "token"
    var userID = UUID()
    
    func signIn(method: AuthenticationMethod,
                token: String?,
                email: String?,
                password: String?) -> AnyPublisher<String, Error> {
        loginEmail = email
        loginPassword = password
        return Just(self.token)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    var signupEmail: String?
    var signupPassword: String?
    var signupIsMerchant: Bool?
    
    func emailSignUp(email: String, password: String, profileName: String, givenName: String, familyName: String, phone: String, address: AddressInput, merchantType: MerchantType, merchantName: String) -> AnyPublisher<String, Error> {
        return Just(self.token)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func socialSignUp(method: AuthenticationMethod, token: String, email: String, givenName: String, familyName: String, merchantType: MerchantType, merchantName: String) -> AnyPublisher<String, Error> {
        return Just(self.token)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    
    func signUp(method: AuthenticationMethod, token: String, email: String, givenName: String, familyName: String, merchantName: String) -> AnyPublisher<String, Error> {
        return Just(self.token)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func requestEmailToken(emailAddress: String, redirectURL: String) -> AnyPublisher<String, Error> {
        return Just(self.token)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func loginWithEmailToken(emailAddress: String, token: String, cookie: String) -> AnyPublisher<String, Error> {
        return Just(self.token)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
