//
//  AppleAuthenticator.swift
//  Whoppah
//
//  Created by Dennis Ippel on 17/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Foundation
import AuthenticationServices
import WhoppahCoreNext
import WhoppahModel
import Resolver
import WhoppahRepository
import Combine

enum AppleSignInError: String, Error {
    case sharedPasswordSelected
    case missingToken
    case unsupportedMethod
    case ssoCredential
}

class AppleAuthenticator: SocialAuthenticator {
    private let keychain = KeychainSwift.create(persistBetweenInstalls: true)
    
    private struct Keys {
        static let email = "com.whoppah.appleid.user.email"
        static let givenName = "com.whoppah.appleid.user.given"
        static let familyName = "com.whoppah.appleid.user.family"
    }
    
    private var appleIdEmail: String? {
        get { return keychain.get(Keys.email) }
        set {
            guard let identifier = newValue else {
                keychain.delete(Keys.email)
                return
            }
            keychain.set(identifier, forKey: Keys.email)
        }
    }
    
    private var appleIdGivenName: String? {
        get { return keychain.get(Keys.givenName) }
        set {
            guard let value = newValue else {
                keychain.delete(Keys.givenName)
                return
            }
            keychain.set(value, forKey: Keys.givenName)
        }
    }
    private var appleIdFamilyName: String? {
        get { return keychain.get(Keys.familyName) }
        set {
            guard let value = newValue else {
                keychain.delete(Keys.familyName)
                return
            }
            keychain.set(value, forKey: Keys.familyName)
        }
    }
    
    override init() {
        super.init()
        authMethod = .apple
    }
    
    override func authorize(authMode: SocialAuthenticationMode,
                   merchantType: MerchantType?) -> AnyPublisher<UserAccessToken, Error>
    {
        let authResult = super.authorize(authMode: authMode,
                                         merchantType: merchantType)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()

        return authResult
    }
}

extension AppleAuthenticator: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        if let authError = error as? ASAuthorizationError,
            case .canceled = authError.code {
            authResultSubject?.send(completion: .failure(authError))
            return
        }
        // When there isn't an account on the device and the user hits "Sign In with Apple" and they leave the app for settings
        // This error is thrown. Previously it was ignored we just accepted it as a bug in the Sign In flow.
        // But Apple rejected the app - so now we have to ignore it...this sucks.
        if let authError = error as? ASAuthorizationError,
            case .unknown = authError.code
        {
            authResultSubject?.send(completion: .failure(authError))
            return
        }
        authResultSubject?.send(completion: .failure(error))
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization)
    {
        var token: String?
        var credential: ASAuthorizationAppleIDCredential?
        
        switch authorization.credential {
        case let appleId as ASAuthorizationAppleIDCredential:
            guard let identity = appleId.identityToken else { return }
            token = String(data: identity, encoding: .utf8)
            credential = appleId
            
            if let email = appleId.email { appleIdEmail = email }
            if let first = appleId.fullName?.givenName { appleIdGivenName = first }
            if let family = appleId.fullName?.familyName { appleIdFamilyName = family }
        case _ as ASAuthorizationSingleSignOnCredential:
            authResultSubject?.send(completion: .failure(AppleSignInError.ssoCredential))
            return
        case _ as ASPasswordCredential:
            authResultSubject?.send(completion: .failure(AppleSignInError.sharedPasswordSelected))
            return
        default:
            authResultSubject?.send(completion: .failure(AppleSignInError.unsupportedMethod))
            return
        }

        guard let authToken = token else {
            authResultSubject?.send(completion: .failure(AppleSignInError.missingToken))
            return
        }
        
        switch authMode {
        case .signIn:
            signIn(withAuthToken: authToken)
        case .register:
            guard let merchantType = merchantType else { return }
            
            let email           = credential?.email ?? self.appleIdEmail ?? ""
            let givenName       = credential?.fullName?.givenName ?? self.appleIdGivenName ?? ""
            let familyName      = credential?.fullName?.familyName ?? self.appleIdFamilyName ?? "User"
            let merchantName    = credential?.fullName?.givenName ?? R.string.localizable.createAdSelectUnknownBrandArtist()
            
            userRepository
                .checkIfEmailExists(email: email)
                .sink { [weak self] (result: EmailAvailabilityStatus) in
                    switch result {
                    case .available:
                        self?.signUp(withAuthToken: authToken,
                                     email: email,
                                     givenName: givenName,
                                     familyName: familyName,
                                     merchantType: merchantType,
                                     merchantName: merchantName)
                    default:
                        self?.signIn(withAuthToken: authToken) {
                            self?.authResultSubject?.send(completion: .failure(SocialSignupError.emailAlreadyExists(email: email)))
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }
}
