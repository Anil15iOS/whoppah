//
//  GoogleAuthenticator.swift
//  Whoppah
//
//  Created by Dennis Ippel on 17/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Combine
import Foundation
import GoogleSignIn
import WhoppahCore
import WhoppahCoreNext
import WhoppahModel
import WhoppahRepository
import UIKit

class GoogleAuthenticator: SocialAuthenticator {
    override init() {
        super.init()
        authMethod = .google
        GIDSignIn.sharedInstance().delegate = self
    }
    
    deinit {
        GIDSignIn.sharedInstance().delegate = nil
    }
    
    func setPresentingViewController(_ viewController: UIViewController) -> Self {
        GIDSignIn.sharedInstance().presentingViewController = viewController
        return self
    }
    
    override func authorize(authMode: SocialAuthenticationMode,
                   merchantType: MerchantType?) -> AnyPublisher<UserAccessToken, Error>
    {
        let authResult = super.authorize(authMode: authMode,
                                         merchantType: merchantType)
        GIDSignIn.sharedInstance().signIn()
        return authResult
    }
    
    override func signOut() -> AnyPublisher<Void, Error> {
        GIDSignIn.sharedInstance().signOut()
        return super.signOut()
    }
}

extension GoogleAuthenticator: GIDSignInDelegate {
    func sign(_: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            guard (error as NSError).code != -5 else {
                return
            }
            // There's a bug in the Google signin that wraps the openID error for user cancelled logins
            // We cannot check the NSError code so instead we have to do this nasty check
            guard !(error as NSError).description.contains("org.openid.appauth.general error -3") else {
                return
            }
            authResultSubject?.send(completion: .failure(error))
        } else if let user = user {
            switch authMode {
            case .signIn:
                signIn(withAuthToken: user.authentication.idToken)
            case .register:
                guard let merchantType = merchantType else { return }
                
                userRepository
                    .checkIfEmailExists(email: user.profile.email)
                    .sink { [weak self] (result: EmailAvailabilityStatus) in
                        switch result {
                        case .available:
                            self?.signUp(withAuthToken: user.authentication.idToken,
                                         email: user.profile.email,
                                         givenName: user.profile.givenName,
                                         familyName: user.profile.familyName,
                                         merchantType: merchantType,
                                         merchantName: user.profile.givenName)
                        default:
                            self?.signIn(withAuthToken: user.authentication.idToken) {
                                self?.authResultSubject?.send(completion: .failure(SocialSignupError.emailAlreadyExists(email: user.profile.email)))
                            }
                        }
                    }
                    .store(in: &cancellables)
            }
        }
    }
}
