//
//  EmailPasswordAuthenticator.swift
//  Whoppah
//
//  Created by Dennis Ippel on 17/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Combine
import Foundation
import WhoppahCore
import WhoppahCoreNext
import WhoppahModel
import Resolver
import WhoppahRepository
import FirebaseMessaging

class EmailPasswordAuthenticator: UserAuthenticating {
    @LazyInjected fileprivate var httpService: HTTPServiceInterface
    @LazyInjected fileprivate var authRepository: AuthRepository
    @LazyInjected fileprivate var userProvider: UserProviding
    
    private let authMethod = AuthenticationMethod.email
    
    private var authResultSubject: PassthroughSubject<UserAccessToken, Error>?
    private var authResult: AnyPublisher<UserAccessToken, Error>?
    
    private var signUpResultSubject: PassthroughSubject<String, Error>?
    private var signUpResult: AnyPublisher<String, Error>?
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    func signIn(email: String, password: String) -> AnyPublisher<UserAccessToken, Error> {
        authResultSubject?.send(completion: .finished)
        cancellables.removeAll()
        
        let authResultSubject = PassthroughSubject<UserAccessToken, Error>()
        let authResult = authResultSubject.eraseToAnyPublisher()
        
        self.authResultSubject = authResultSubject
        self.authResult = authResult
        
        authRepository.signIn(method: .email,
                              token: nil,
                              email: email,
                              password: password)
            .sink { [weak self] result in
                self?.handleResult(result,
                                   subject: self?.authResultSubject)
            } receiveValue: { [weak self] tokenString in
                guard let self = self else { return }
                self.handleTokenString(tokenString,
                                       authMethod: .email,
                                       userProvider: self.userProvider,
                                       subject: self.authResultSubject)
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)

        return authResult
    }
    
    func signUp(email: String,
                password: String,
                profileName: String,
                givenName: String,
                familyName: String,
                phone: String,
                address: AddressInput,
                merchantType: MerchantType,
                merchantName: String) -> AnyPublisher<String, Error>
    {
        signUpResultSubject?.send(completion: .finished)
        cancellables.removeAll()
        
        let signUpResultSubject = PassthroughSubject<String, Error>()
        let signUpResult = signUpResultSubject.eraseToAnyPublisher()
        
        self.signUpResultSubject = signUpResultSubject
        self.signUpResult = signUpResult
        
        authRepository.emailSignUp(
            email: email,
            password: password,
            profileName: profileName,
            givenName: givenName,
            familyName: familyName,
            phone: phone,
            address: address,
            merchantType: merchantType,
            merchantName: merchantName)
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.signUpResultSubject?.send(completion: .failure(error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] resultString in
                self?.signUpResultSubject?.send(resultString)
            }
            .store(in: &cancellables)
        
        return signUpResult
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            let token = Messaging.messaging().fcmToken ?? ""
            let request = EmailPasswordAuthRequest(.signOut(fcmToken: token))
            self.httpService.execute(request: request) {(result: Result<EmptyResponse, Error>) in
                switch result {
                case .success:
                    promise(.success(Void()))
                case .failure(let error):
                    promise(.failure(error))
                }
                self.userProvider.userSignedOut()
            }
        }
        .eraseToAnyPublisher()
    }
}
