//
//  MagicLinkAuthenticator.swift
//  Whoppah
//
//  Created by Dennis Ippel on 04/01/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCoreNext
import Resolver
import Combine
import WhoppahRepository
import WhoppahCore
import WhoppahModel

class MagicLinkAuthenticator: UserAuthenticating {
    @LazyInjected fileprivate var authRepository: AuthRepository
    @LazyInjected fileprivate var httpService: HTTPServiceInterface
    @LazyInjected fileprivate var userProvider: UserProviding

    private var authResultSubject: PassthroughSubject<UserAccessToken, Error>?
    private var authResult: AnyPublisher<UserAccessToken, Error>?

    fileprivate var cancellables = Set<AnyCancellable>()

    func requestEmailToken(emailAddress: String) -> AnyPublisher<String, Error> {
        return authRepository
            .requestEmailToken(emailAddress: emailAddress,
                               redirectURL: "http://www.whoppah.com")
    }
    
    func authorize(withEmail email: String,
                   token: String,
                   cookie: String) -> AnyPublisher<UserAccessToken, Error>
    {
        authResultSubject?.send(completion: .finished)
        cancellables.removeAll()

        let authResultSubject = PassthroughSubject<UserAccessToken, Error>()
        let authResult = authResultSubject.eraseToAnyPublisher()
        
        self.authResultSubject = authResultSubject
        self.authResult = authResult

        
        authRepository.loginWithEmailToken(emailAddress: email,
                                           token: token,
                                           cookie: cookie)
            .sink(receiveCompletion: handleResult,
                  receiveValue: handleTokenString)
            .store(in: &cancellables)
        
        return authResult
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
        return Empty(outputType: Void.self, failureType: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func handleResult(_ result: Subscribers.Completion<Error>) {
        switch result {
        case .failure(let error):
            authResultSubject?.send(completion: .failure(error))
        case .finished:
            break
        }
    }
    
    private func handleTokenString(tokenString: String) {
        userProvider.update(accessToken: tokenString,
                            authenticationMethod: .email,
                            accessTokenType: .bearer)
        .sink(receiveCompletion: { [weak self] result in
            switch result {
            case .failure(let error):
                self?.authResultSubject?.send(completion: .failure(error))
            case .finished:
                break
            }
        }, receiveValue: { [weak self] member in
            guard let member = member,
                  let merchantId = member.merchantId
            else { return }

            let token = UserAccessToken(token: tokenString,
                                        userID: merchantId,
                                        authenticationMethod: .email,
                                        type: .bearer,
                                        isMerchant: member.isProfessional)
            self?.authResultSubject?.send(token)
        })
        .store(in: &cancellables)
    }
}
