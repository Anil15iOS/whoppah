//
//  File.swift
//  
//
//  Created by Dennis Ippel on 17/12/2021.
//

import Apollo
import Combine
import Resolver
import WhoppahModel
import WhoppahRepository

struct ApolloAuthRepository: AuthRepository {
    @Injected private var apollo: ApolloService
    
    func signIn(method: AuthenticationMethod,
                token: String?,
                email: String?,
                password: String?) -> AnyPublisher<String, Error> {
        switch method {
        case .apple:
            guard let token = token else {
                return Fail(outputType: String.self, failure: AuthRepositoryError.missingToken).eraseToAnyPublisher()
            }
            let mutation = GraphQL.LoginWithAppleMutation(platform: .ios,
                                                          token: token)
            return apollo.apply(mutation: mutation).tryMap { result -> String in
                guard let loginWithApple = result.data?.loginWithApple else {
                    throw WhoppahRepository.Error.noData
                }
                return loginWithApple
            }.eraseToAnyPublisher()
        case .email:
            guard let email = email, let password = password else {
                return Fail(outputType: String.self,
                            failure: AuthRepositoryError.noEmailAndPasswordProvided)
                    .eraseToAnyPublisher()
            }
            let mutation = GraphQL.LoginWithEmailPasswordMutation(email: email, password: password)
            
            return apollo.apply(mutation: mutation).tryMap { result -> String in
                guard let loginWithEmailPassword = result.data?.loginWithEmailPassword else {
                    throw WhoppahRepository.Error.noData
                }
                return loginWithEmailPassword
            }.eraseToAnyPublisher()
        case .facebook:
            guard let token = token else {
                return Fail(outputType: String.self, failure: AuthRepositoryError.missingToken).eraseToAnyPublisher()
            }
            let mutation = GraphQL.LoginWithFacebookMutation(platform: .ios, token: token)
            
            return apollo.apply(mutation: mutation).tryMap { result -> String in
                guard let loginWithFacebook = result.data?.loginWithFacebook else {
                    throw WhoppahRepository.Error.noData
                }
                return loginWithFacebook
            }.eraseToAnyPublisher()
        case .google:
            guard let token = token else {
                return Fail(outputType: String.self, failure: AuthRepositoryError.missingToken).eraseToAnyPublisher()
            }
            let mutation = GraphQL.LoginWithGoogleMutation(platform: .ios, token: token)
            
            return apollo.apply(mutation: mutation).tryMap { result -> String in
                guard let loginWithGoogle = result.data?.loginWithGoogle else {
                    throw WhoppahRepository.Error.noData
                }
                return loginWithGoogle
            }.eraseToAnyPublisher()
        }
    }
    
    func emailSignUp(email: String,
                     password: String,
                     profileName: String,
                     givenName: String,
                     familyName: String,
                     phone: String,
                     address: AddressInput,
                     merchantType: MerchantType,
                     merchantName: String) -> AnyPublisher<String, Error>
    {
        let input = GraphQL.SignupWithEmailPasswordInput(
            email: email,
            password: password,
            type: merchantType.toGraphQLModel,
            name: profileName,
            phone: phone,
            givenName: givenName,
            familyName: familyName,
            address: .init(address.toGraphQLModel))
        let mutation = GraphQL.SignupWithEmailPasswordMutation(input: input)
        
        return apollo.apply(mutation: mutation).tryMap { result -> String in
            guard let signupWithEmail = result.data?.signupWithEmailPassword else {
                throw WhoppahRepository.Error.noData
            }
            return signupWithEmail
        }
        .eraseToAnyPublisher()
    }
    
    func socialSignUp(method: AuthenticationMethod,
                      token: String,
                      email: String,
                      givenName: String,
                      familyName: String,
                      merchantType: MerchantType,
                      merchantName: String) -> AnyPublisher<String, Error>
    {
        let member = GraphQL.MemberInput(email: email,
                                         givenName: givenName,
                                         familyName: familyName)
        let merchant = GraphQL.MerchantInput(type: merchantType.toGraphQLModel,
                                             name: merchantName)
        
        switch method {
        case .apple:
            let mutation = GraphQL.SignupWithAppleMutation(
                platform: .ios,
                token: token,
                member: member,
                merchant: merchant)
            
            return apollo.apply(mutation: mutation).tryMap { result -> String in
                guard let signUpWithApple = result.data?.signupWithApple else {
                    throw WhoppahRepository.Error.noData
                }
                return signUpWithApple
            }
            .eraseToAnyPublisher()
        case .facebook:
            let mutation = GraphQL.SignupWithFacebookMutation(
                platform: .ios,
                token: token,
                member: member,
                merchant: merchant)
            
            return apollo.apply(mutation: mutation).tryMap { result -> String in
                guard let signupWithFacebook = result.data?.signupWithFacebook else {
                    throw WhoppahRepository.Error.noData
                }
                return signupWithFacebook
            }
            .eraseToAnyPublisher()
        case .google:
            let mutation = GraphQL.SignupWithGoogleMutation(
                platform: .ios,
                token: token,
                member: member,
                merchant: merchant)
            
            return apollo.apply(mutation: mutation).tryMap { result -> String in
                guard let signupWithGoogle = result.data?.signupWithGoogle else {
                    throw WhoppahRepository.Error.noData
                }
                return signupWithGoogle
            }
            .eraseToAnyPublisher()
        case .email:
            return Fail(outputType: String.self,
                        failure: AuthRepositoryError.unsupportedSignUpMethod)
                .eraseToAnyPublisher()
        }
    }
    
    func requestEmailToken(emailAddress: String, redirectURL: String) -> AnyPublisher<String, Error> {
        let mutation = GraphQL.RequestEmailTokenMutation(email: emailAddress,
                                                      redirectUrl: redirectURL)
        
        return apollo.apply(mutation: mutation)
            .eraseToAnyPublisher()
            .map { data in
                return data.data?.requestEmailToken ?? ""
            }
            .eraseToAnyPublisher()
    }
    
    func loginWithEmailToken(emailAddress: String, token: String, cookie: String) -> AnyPublisher<String, Error> {
        let mutation = GraphQL.LoginWithEmailTokenMutation(email: emailAddress, token: token, cookie: cookie)
        
        return apollo.apply(mutation: mutation)
            .eraseToAnyPublisher()
            .map { data in
                return data.data?.loginWithEmailToken.token ?? ""
            }
            .eraseToAnyPublisher()
    }
}
