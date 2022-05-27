//
//  EmailAuthenticating.swift
//  WhoppahCoreNext
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Foundation
import WhoppahModel

public protocol EmailAuthenticating: UserAuthenticating {
    func logIn(email: String,
               password: String,
               completion handler: @escaping (Result<UserAccessToken, Error>) -> Void)
}
