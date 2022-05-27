//
//  UserProviding.swift
//  WhoppahCoreNext
//
//  Created by Dennis Ippel on 29/11/2021.
//

import Combine
import Foundation
import WhoppahModel

open class UserProviding {
    private struct Key {
        static let accessToken = "com.whoppah.access.token"
    }
    
    @Published public var accessToken: String?
    
    open var currentUserPublisher: AnyPublisher<Member?, Error>? { nil }
    open var currentUser: Member? { nil }
    
    open var hasCompletedProfile: Bool { false }
    open var isLoggedIn: Bool { false }
    open var authenticationMethod: AuthenticationMethod? { nil }
    
    public init() {}
    
    open func fetchActiveUser() {}
    open func update(accessToken: String,
                     authenticationMethod: AuthenticationMethod,
                     accessTokenType: UserAccessTokenType) -> AnyPublisher<Member?, Error> {
        return failure()
    }
    open func update(id: UUID, member: MemberInput) -> AnyPublisher<UUID, Error> {
        return failure()
    }
    open func userSignedOut() {}
    
    open func changePassword(oldPassword: String,
                             newPassword: String) -> AnyPublisher<UUID, Error>
    { return failure() }
    
    open func setNewPassword(userID: String,
                             token: String,
                             newPassword: String,
                             newPasswordConfirmation: String) -> AnyPublisher<String, Error>
    { return failure() }
    
    open func resetPassword(email: String) -> AnyPublisher<String, Error>
    { return failure() }
    
    private func failure<T>() -> AnyPublisher<T, Error> {
        Fail(outputType: T.self, failure: WhoppahError.notImplemented).eraseToAnyPublisher()
    }
}
