//
//  AuthenticationStore.swift
//  Whoppah
//
//  Created by Dennis Ippel on 20/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import WhoppahCoreNext
import WhoppahModel
import Resolver
import WhoppahCore
import Combine

class AuthenticationStore: AuthenticationStoring {
    @LazyInjected private var eventTrackingService: EventTrackingService
    @LazyInjected private var userProvider: UserProviding
    
    private lazy var authenticators: [UserAuthenticating] = {
        [
            EmailPasswordAuthenticator(),
            AppleAuthenticator(),
            FacebookAuthenticator(),
            GoogleAuthenticator(),
            MagicLinkAuthenticator()
        ]
    }()
    
    func signInAuthenticator<T>(ofType handlerType: T.Type) -> T? {
        return authenticators.first { type(of: $0) == handlerType } as? T
    }
    
    func signOutAuthenticator<T>(ofType handlerType: T.Type) -> T? {
        return authenticators.first { type(of: $0) == handlerType } as? T
    }
    
    func signUpAuthenticator<T>(ofType handlerType: T.Type) -> T? {
        return authenticators.first { type(of: $0) == handlerType } as? T
    }
    
    func signOutAll() -> AnyPublisher<[Void], Error> {
        let publishers = authenticators.map { $0.signOut() }
        let z = Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
        return z
    }
}
