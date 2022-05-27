//
//  SocialAuthenticator.swift
//  Whoppah
//
//  Created by Dennis Ippel on 15/02/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCoreNext
import WhoppahModel
import WhoppahRepository
import Combine
import Resolver

class SocialAuthenticator: NSObject, SocialAuthenticating {
    
    @LazyInjected var authRepository: AuthRepository
    @LazyInjected var userProvider: UserProviding
    @LazyInjected var userRepository: UserRepository

    var authMethod = AuthenticationMethod.email

    var authMode = SocialAuthenticationMode.signIn
    var merchantType: MerchantType?

    var authResultSubject: PassthroughSubject<UserAccessToken, Error>?
    var authResult: AnyPublisher<UserAccessToken, Error>?

    var cancellables = Set<AnyCancellable>()
    
    func authorize(authMode: SocialAuthenticationMode,
                   merchantType: MerchantType?) -> AnyPublisher<UserAccessToken, Error>
    {
        self.authMode = authMode
        self.merchantType = merchantType
        
        authResultSubject?.send(completion: .finished)
        cancellables.removeAll()
        
        let authResultSubject = PassthroughSubject<UserAccessToken, Error>()
        let authResult = authResultSubject.eraseToAnyPublisher()
        
        self.authResultSubject = authResultSubject
        self.authResult = authResult
        
        return authResult
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
        return Empty().eraseToAnyPublisher()
    }
    
    func signIn(withAuthToken authToken: String,
                complete: (() -> Void)? = nil)
    {
        authRepository.signIn(method: authMethod,
                              token: authToken,
                              email: nil,
                              password: nil)
            .sink { [weak self] result in
                self?.handleResult(result,
                                   subject: self?.authResultSubject)
            } receiveValue: { [weak self] tokenString in
                guard let self = self else { return }
                self.handleTokenString(tokenString,
                                       authMethod: self.authMethod,
                                       userProvider: self.userProvider,
                                       subject: self.authResultSubject)
                    .store(in: &self.cancellables)
                complete?()
            }
            .store(in: &cancellables)
    }
    
    func signUp(withAuthToken authToken: String,
                        email: String,
                        givenName: String,
                        familyName: String,
                        merchantType: MerchantType,
                        merchantName: String)
    {
        authRepository.socialSignUp(method: authMethod,
                                    token: authToken,
                                    email: email,
                                    givenName: givenName,
                                    familyName: familyName,
                                    merchantType: merchantType,
                                    merchantName: merchantName)
            .sink { [weak self] result in
                self?.handleResult(result,
                                   subject: self?.authResultSubject)
            } receiveValue: { [weak self] tokenString in
                guard let self = self else { return }
                self.handleTokenString(tokenString,
                                       authMethod: self.authMethod,
                                       userProvider: self.userProvider,
                                       subject: self.authResultSubject)
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
}
