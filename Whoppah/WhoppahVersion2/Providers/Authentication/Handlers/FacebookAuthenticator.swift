//
//  FacebookAuthHandler.swift
//  Whoppah
//
//  Created by Dennis Ippel on 17/12/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import Combine
import Foundation
import FacebookLogin
import WhoppahCore
import WhoppahCoreNext
import WhoppahModel
import WhoppahRepository

class FacebookAuthenticator: SocialAuthenticator {
    override init() {
        super.init()
        authMethod = .facebook
    }

    override func authorize(authMode: SocialAuthenticationMode,
                   merchantType: MerchantType?) -> AnyPublisher<UserAccessToken, Error>
    {
        let authResult = super.authorize(authMode: authMode,
                                         merchantType: merchantType)

        loginRequest()
            .sink { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .failure(let error):
                    self.authResultSubject?.send(completion: .failure(error))
                default:
                    break
                }
            } receiveValue: { [weak self] accessToken in
                guard let self = self else { return }
                
                switch authMode {
                case .signIn:
                    self.signIn(withAuthToken: accessToken)
                case .register:
                    guard let merchantType = merchantType else { return }
                    
                    self.graphMeRequest(accessToken: accessToken)
                        .sink(receiveValue: { result in
                            guard let email = result["email"],
                                  let firstName = result["first_name"],
                                  let lastName = result["last_name"]
                            else { return }

                            self.userRepository
                                .checkIfEmailExists(email: email)
                                .sink { [weak self] (result: EmailAvailabilityStatus) in
                                    switch result {
                                    case .available:
                                        self?.signUp(withAuthToken: accessToken,
                                                     email: email,
                                                     givenName: firstName,
                                                     familyName: lastName,
                                                     merchantType: merchantType,
                                                     merchantName: firstName)
                                    default:
                                        self?.signIn(withAuthToken: accessToken) {
                                            self?.authResultSubject?.send(completion: .failure(SocialSignupError.emailAlreadyExists(email: email)))
                                        }
                                    }
                                }
                                .store(in: &self.cancellables)
                        })
                        .store(in: &self.cancellables)
                }
            }
            .store(in: &self.cancellables)

        return authResult
    }
    
    private func loginRequest() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            let loginManager = LoginManager()
            loginManager.logIn(permissions: [Permission.publicProfile, Permission.email], viewController: nil) { result in
                switch result {
                case let .failed(error):
                    promise(.failure(error))
                case .cancelled:
                    break
                case let .success(_, _, accessToken):
                    guard let accessToken = accessToken else {
                        promise(.failure(SocialSignupError.missingUserInfo))
                        return
                    }
                    
                    promise(.success(accessToken.tokenString))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func graphMeRequest(accessToken: String) -> AnyPublisher<[String: String], Error> {
        return Future<[String: String], Error> { promise in
            let request = GraphRequest(graphPath: "me",
                                       parameters: ["fields": "email, first_name, last_name"],
                                       tokenString: accessToken,
                                       version: nil,
                                       httpMethod: .get)
            request.start { connection, result, error in
                guard error == nil,
                      let result = result as? [String:String]
                else {
                    promise(.failure(SocialSignupError.missingUserInfo))
                    return
                }
                
                promise(.success(result))
            }
        }
        .eraseToAnyPublisher()
    }
    
    override func signOut() -> AnyPublisher<Void, Error> {
        LoginManager().logOut()
        return super.signOut()
    }
}
