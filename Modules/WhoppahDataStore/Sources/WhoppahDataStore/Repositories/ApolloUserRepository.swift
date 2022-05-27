//
//  ApolloUserRepository.swift
//  WhoppahDataStore
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Apollo
import Combine
import Foundation
import Resolver
import WhoppahRepository
import WhoppahModel

class ApolloUserRepository: UserRepository {
    @LazyInjected private var apollo: ApolloService
    
    private var userWatcher: GraphQLQueryWatcher<GraphQL.GetMeQuery>?
    
    override init() {
        super.init()
    }
    
    deinit {
        userWatcher?.cancel()
    }
    
    override func fetchCurrentUser() {
        super.fetchCurrentUser()
        if let watcher = userWatcher {
            watcher.refetch()
        } else {
            userWatcher = apollo.watch(query: GraphQL.GetMeQuery()) { [weak self] result in
                switch result {
                case let .success(user):
                    if let me = user.me {
                        self?.currentUserSubject.send(me.toWhoppahModel)
                    } else {
                        self?.currentUserSubject.send(completion: .failure(MemberError.unableToFetchMember))
                    }
                case let .failure(error):
                    self?.currentUserSubject.send(completion: .failure(error))
                }
            }
        }
    }
    
    override func userSignedOut() {
        super.userSignedOut()
        userWatcher = nil
        self.currentUserSubject.send(nil)
        apollo.updateCache(query: GraphQL.GetMeQuery()) { (cachedQuery: inout GraphQL.GetMeQuery.Data) in
            cachedQuery.me = nil
        }
    }
    
    override func update(_ member: MemberInput,
                         id: UUID) -> AnyPublisher<UUID, Error>
    {
        guard let memberId = member.id else {
            return Fail(outputType: UUID.self,
                        failure: WhoppahRepository.Error.missingParameter(named: "member.id"))
                .eraseToAnyPublisher()
        }
        
        userWatcher = nil
        
        let input = GraphQL.MemberInput(email: member.email,
                                        givenName: member.givenName,
                                        familyName: member.familyName,
                                        locale: member.locale.toGraphQLModel)
        let mutation = GraphQL.UpdateMemberMutation(id: memberId, input: input)
        
        return apollo.apply(mutation: mutation)
            .tryMap({ result -> UUID in
                guard let id = result.data?.updateMember.id else {
                    throw WhoppahRepository.Error.noData
                }
                return id
            })
            .eraseToAnyPublisher()
    }
    
    override func changePassword(oldPassword: String,
                                 newPassword: String) -> AnyPublisher<UUID, Error>
    {
        let mutation = GraphQL.UpdateMemberPasswordMutation(input: GraphQL.UpdateMemberPassword(current: oldPassword, password: newPassword))
        
        return apollo.apply(mutation: mutation).tryMap { result -> UUID in
            guard let id = result.data?.updateMemberPassword?.id else {
                throw WhoppahRepository.Error.noData
            }
            return id
        }
        .eraseToAnyPublisher()
    }

    override func updateForgottenPassword(userID: String,
                                          token: String,
                                          newPassword: String,
                                          newPasswordConfirmation: String) -> AnyPublisher<String, Error>
    {
        let mutation = GraphQL.UpdateForgottenPasswordMutation(
            input: GraphQL.UpdateForgottenPasswordInput(uid: userID,
                                                        token: token,
                                                        newPassword: newPassword,
                                                        newPasswordConfirmation: newPasswordConfirmation))
        
        return apollo.apply(mutation: mutation)
            .tryMap { result -> String in
                guard let message = result.data?.updateForgottenPassword.message else {
                    throw WhoppahRepository.Error.noData
                }
                return message
            }
            .eraseToAnyPublisher()
    }
    
    override func forgotPassword(email: String) -> AnyPublisher<String, Error> {
        let mutation = GraphQL.ForgotPasswordMutation(input: GraphQL.ForgotPasswordInput(email: email))
        
        return apollo.apply(mutation: mutation)
            .tryMap { result -> String in
                guard let message = result.data?.forgotPassword.message else {
                    throw WhoppahRepository.Error.noData
                }
                return message
            }
            .eraseToAnyPublisher()
    }
    
    override func checkIfEmailExists(email: String) -> AnyPublisher<EmailAvailabilityStatus, Error> {
        let mutation = GraphQL.CheckEmailExistsMutation(email: email)
        
        return apollo.apply(mutation: mutation)
            .tryMap { result -> EmailAvailabilityStatus in
                guard let status = result.data?.checkEmailExists.status else {
                    throw WhoppahRepository.Error.noData
                }
                switch status {
                case .available:    return .available
                case .banned:       return .banned
                case .unavailable:  return .unavailable
                default:            return .unavailable
                }
            }
            .eraseToAnyPublisher()
    }
    
    override func userFavorites(pagination: WhoppahModel.Pagination?) -> AnyPublisher<[UUID: WhoppahModel.Favorite], Error> {
        let query = GraphQL.GetCurrentUserFavoritesQuery(pagination: pagination?.toGraphQLModel)
        return apollo.fetch(query: query,
                           cache: .fetchIgnoringCacheData)
            .tryMap { result in
                guard let items = result.data?.favorites.items else { throw WhoppahRepository.Error.noData }
                
                var favorites = [UUID: WhoppahModel.Favorite]()
                
                items.forEach { item in
                    if let productId = item.item.asProduct?.id {
                        favorites[productId] = .init(id: item.id,
                                                     created: item.created.toWhoppahModel,
                                                        collection: nil)
                    }
                }
                
                return favorites
            }
            .eraseToAnyPublisher()
    }
}
