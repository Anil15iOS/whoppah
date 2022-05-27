//
//  AuthenticationStoring.swift
//  WhoppahCoreNext
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Foundation
import Combine

public protocol AuthenticationStoring {
    func signInAuthenticator<T>(ofType handlerType: T.Type) -> T?
    func signOutAuthenticator<T>(ofType handlerType: T.Type) -> T?
    func signUpAuthenticator<T>(ofType handlerType: T.Type) -> T?
    
    func signOutAll() -> AnyPublisher<[Void], Error>
}
