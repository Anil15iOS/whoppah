//
//  AuthRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 17/12/2021.
//

import Foundation
import Combine
import WhoppahModel

public enum AuthRepositoryError: Error {
    case noEmailAndPasswordProvided
    case noPasswordProvided
    case missingToken
    case unsupportedSignUpMethod
}

public protocol AuthRepository {
    func signIn(method: AuthenticationMethod,
                token: String?,
                email: String?,
                password: String?) -> AnyPublisher<String, Error>
    
    func emailSignUp(email: String,
                     password: String,
                     profileName: String,
                     givenName: String,
                     familyName: String,
                     phone: String,
                     address: AddressInput,
                     merchantType: MerchantType,
                     merchantName: String) -> AnyPublisher<String, Error>
    
    func socialSignUp(method: AuthenticationMethod,
                      token: String,
                      email: String,
                      givenName: String,
                      familyName: String,
                      merchantType: MerchantType,
                      merchantName: String) -> AnyPublisher<String, Error>
    
    func requestEmailToken(emailAddress: String, redirectURL: String) -> AnyPublisher<String, Error>
    
    func loginWithEmailToken(emailAddress: String, token: String, cookie: String) -> AnyPublisher<String, Error>
}
