//
//  UserAuthenticating.swift
//  WhoppahCoreNext
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Combine
import Foundation
import WhoppahModel

public protocol UserAuthenticating {
    func signOut() -> AnyPublisher<Void, Error>
    func handleResult(_ result: Subscribers.Completion<Error>,
                      subject: PassthroughSubject<UserAccessToken, Error>?)
    func handleTokenString(_ tokenString: String,
                           authMethod: AuthenticationMethod,
                           userProvider: UserProviding,
                           subject: PassthroughSubject<UserAccessToken, Error>?) -> AnyCancellable
}

public extension UserAuthenticating {
    func handleResult(_ result: Subscribers.Completion<Error>,
                      subject: PassthroughSubject<UserAccessToken, Error>?)
    {
        switch result {
        case .failure(let error):
            subject?.send(completion: .failure(error))
        case .finished:
            break
        }
    }
    
    func handleTokenString(_ tokenString: String,
                           authMethod: AuthenticationMethod,
                           userProvider: UserProviding,
                           subject: PassthroughSubject<UserAccessToken, Error>?) -> AnyCancellable
    {
        userProvider.update(accessToken: tokenString,
                            authenticationMethod: authMethod,
                            accessTokenType: .bearer)
        .sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                subject?.send(completion: .failure(error))
            case .finished:
                break
            }
        }, receiveValue: { member in
            guard let member = member,
                  let merchantId = member.merchantId
            else { return }

            let token = UserAccessToken(token: tokenString,
                                        userID: merchantId,
                                        authenticationMethod: authMethod,
                                        type: .bearer,
                                        isMerchant: member.isProfessional)
            subject?.send(token)
        })
    }
}
