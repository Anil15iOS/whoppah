//
//  UserProvider.swift
//  Whoppah
//
//  Created by Dennis Ippel on 22/12/2021.
//

import Combine
import Foundation
import Resolver
import WhoppahModel
import WhoppahCoreNext
import WhoppahRepository
import WhoppahCore

public class UserProvider: UserProviding {
    private struct Key {
        static let accessToken = "com.whoppah.access.token"
    }
    
    @LazyInjected private var userRepository: UserRepository
    @LazyInjected private var httpService: HTTPServiceInterface
    
    private let keychain = KeychainSwift.create()
    private var accessTokenType: UserAccessTokenType?
    private var currentUserCancellable: Cancellable?
    
    private var keyChainAccessToken: String? {
        get { keychain.get(Key.accessToken) }
        set {
            if let token = newValue {
                keychain.set(token, forKey: Key.accessToken)
            } else {
                keychain.delete(Key.accessToken)
                accessTokenType = nil
            }
            accessToken = newValue
        }
    }
    
    override public var currentUser: Member? { userRepository.currentUserSubject.value }
    override public var currentUserPublisher: AnyPublisher<Member?, Error>? { userRepository.currentUserPublisher }
    override public var isLoggedIn: Bool { accessToken != nil }
    override public var hasCompletedProfile: Bool {
        guard let currentUser = currentUser else { return false }
        
        switch currentUser.hasCompletedProfile {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    override public var authenticationMethod: AuthenticationMethod? { _authenticationMethod }
    private var _authenticationMethod: AuthenticationMethod?
    
    override public init() {
        super.init()
        
        accessToken = keyChainAccessToken
        currentUserCancellable = currentUserPublisher?
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure:  self?.keyChainAccessToken = nil
                default:        break
                }
            })
    }
    
    override public func userSignedOut() {
        keyChainAccessToken = nil
        userRepository.userSignedOut()
    }
    
    override public func fetchActiveUser() {
        userRepository.fetchCurrentUser()
    }
    
    override public func update(accessToken: String,
                                authenticationMethod: AuthenticationMethod,
                                accessTokenType: UserAccessTokenType) -> AnyPublisher<Member?, Error> {
        keyChainAccessToken = "\(accessTokenType.rawValue) \(accessToken)"
        self.accessTokenType = accessTokenType
        _authenticationMethod = authenticationMethod
        fetchActiveUser()
        return userRepository.currentUserPublisher
    }
    
    override public func update(id: UUID, member: MemberInput) -> AnyPublisher<UUID, Error> {
        userRepository.update(member, id: id)
    }
    
    override public func changePassword(oldPassword: String, newPassword: String) -> AnyPublisher<UUID, Error>
    {
        userRepository.changePassword(oldPassword: oldPassword,
                                      newPassword: newPassword)
    }
    
    override public func setNewPassword(userID: String,
                                        token: String,
                                        newPassword: String,
                                        newPasswordConfirmation: String) -> AnyPublisher<String, Error>
    {
        userRepository.updateForgottenPassword(userID: userID,
                                               token: token,
                                               newPassword: newPassword,
                                               newPasswordConfirmation: newPasswordConfirmation)
    }
    
    override public func resetPassword(email: String) -> AnyPublisher<String, Error> {
        userRepository.forgotPassword(email: email)
    }
}
