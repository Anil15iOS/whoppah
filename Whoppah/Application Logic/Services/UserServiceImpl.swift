//
//  UserService.swift
//  Whoppah
//
//  Created by Boris Sagan on 9/28/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import WhoppahModel
import Resolver
import Combine
import WhoppahDataStore

final class UserServiceImpl: WhoppahCore.LegacyUserService {
    // MARK: - Keys

    private struct Keys {
        static let accessToken = "com.whoppah.access.token"
    }

    // MARK: - Properties

    var current: WhoppahCore.LegacyMember? { userProvider.currentUser?.rawObject as? WhoppahCore.LegacyMember }
    var active = BehaviorSubject<WhoppahCore.LegacyMember?>(value: nil)

    @LazyInjected var repo: LegacyUserRepository
    // This is a temp solution while we're migrating between architectures
    @Injected var userProvider: UserProviding
    @LazyInjected private var apolloService: ApolloService
    @Injected private var httpService: HTTPServiceInterface

    private let keychain = KeychainSwift.create()
    private let bag = DisposeBag()

    var isLoggedIn: Bool { userProvider.isLoggedIn }
    var requiresLogout: Bool { true }
    var cancellables = Set<AnyCancellable>()

    init() {
        userProvider
            .currentUserPublisher!
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.active.on(.error(error))
                case .finished:
                    self?.active.onCompleted()
                }
            }, receiveValue: { [weak self] member in
                guard let legacyMember = member?.rawObject as? LegacyMember else { return }
                self?.active.on(.next(legacyMember))
            })
            .store(in: &cancellables)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func getActive() {
        repo.loadCurrentUser()
        userProvider.fetchActiveUser()
    }

    func update(id _: UUID, member: WhoppahCore.LegacyMemberInput) -> Observable<UUID> {
        let input = GraphQL.MemberInput(email: member.email ?? "",
                                        givenName: member.givenName ?? "",
                                        familyName: member.familyName ?? "",
                                        dob: member.dob,
                                        locale: Locale.whoppahLocale(existing: member.locale))
        return apolloService.apply(mutation: GraphQL.UpdateMemberMutation(id: member.id!, input: input)).compactMap { $0.data?.updateMember.id }
    }

    func getNotificationSettings(completion handler: @escaping (Result<NotificationSettings, Error>) -> Void) {
        let request = UserRequest.notificationSettings
        perform(request: request, handler: handler)
    }

    func updateNotificationSettings(settings: NotificationSettings, completion handler: @escaping (Result<NotificationSettings, Error>) -> Void) {
        let request = UserRequest.updateNotificationSettings(settings: settings)
        perform(request: request, handler: handler)
    }
    
    @discardableResult
    private func perform<T>(request: HTTPRequestable, handler: @escaping (Result<T, Error>) -> Void) -> ProgressCancellable where T: Decodable, T: Encodable {
        return httpService.execute(request: request) { (result: Result<T, Error>) in
            handler(result)
        }
    }

    // MARK: -

    func getMySearches() -> Observable<[GraphQL.SavedSearchesQuery.Data.SavedSearch.Item]> {
        Observable.create { observer in
            self.apolloService.fetch(query: GraphQL.SavedSearchesQuery()).subscribe(onNext: { result in
                if let firstError = result.errors?.first {
                    observer.onError(firstError)
                } else {
                    if let searches = result.data?.savedSearches.items {
                        observer.onNext(searches)
                    }
                    observer.onCompleted()
                }
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: self.bag)
            return Disposables.create()
        }
    }

    func saveSearch(search: GraphQL.SavedSearchInput) -> Observable<UUID?> {
        apolloService.apply(mutation: GraphQL.CreateSavedSearchMutation(input: search)).map { result in
            result.data?.createSavedSearch.id
        }
    }

    func deleteSearch(id: UUID) -> Observable<Void> {
        let input = GraphQL.RemoveSavedSearchMutation(id: id)
        return apolloService.apply(mutation: input).map { _ in
            ()
        }
    }

    // MARK: - Support

    func sendQuestionForSupport(text: String) -> Observable<Void> {
        apolloService.apply(mutation: GraphQL.SendAppFeedbackMutation(body: text)).map { _ in () }
    }
}
