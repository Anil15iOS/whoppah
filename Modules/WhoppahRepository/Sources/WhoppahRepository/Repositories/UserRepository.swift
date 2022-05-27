//
//  UserRepository.swift
//  WhoppahRepository
//
//  Created by Dennis Ippel on 20/12/2021.
//

import Combine
import Foundation
import WhoppahModel

open class UserRepository: ObservableObject {
    typealias UpdateIdClosure = (Swift.Result<UUID, Error>) -> Void
    
    public var currentUserSubject: CurrentValueSubject<Member?, Error>
    public var currentUserPublisher: AnyPublisher<Member?, Error>
    
    public init() {
        currentUserSubject = CurrentValueSubject<Member?, Error>(nil)
        currentUserPublisher = currentUserSubject.eraseToAnyPublisher()
    }

    open func fetchCurrentUser() {}
    
    open func userSignedOut() {}
    
    open func userFavorites(pagination: WhoppahModel.Pagination?) -> AnyPublisher<[UUID: Favorite], Error> {
        failure()
    }
    
    open func update(_ member: MemberInput,
                     id: UUID) -> AnyPublisher<UUID, Error> {
        failure()
    }
    
    open func changePassword(oldPassword: String,
                             newPassword: String) -> AnyPublisher<UUID, Error> {
        failure()
    }
    
    open func forgotPassword(email: String) -> AnyPublisher<String, Error> {
        failure()
    }
    
    open func updateForgottenPassword(userID: String,
                                      token: String,
                                      newPassword: String,
                                      newPasswordConfirmation: String) -> AnyPublisher<String, Error> {
        failure()
    }
    
    open func checkIfEmailExists(email: String) -> AnyPublisher<EmailAvailabilityStatus, Error> {
        failure()
    }
    
    private func failure<T>() -> AnyPublisher<T, Error> {
        Fail(outputType: T.self, failure: WhoppahRepositoryError.notImplemented).eraseToAnyPublisher()
    }
}
