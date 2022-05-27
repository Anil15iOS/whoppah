//
//  ApolloService.swift
//  Whoppah
//
//  Created by Eddie Long on 06/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import WhoppahModel
import WhoppahDataStore
import Resolver
import Combine

private let errorCodeKey = "code"
private let errorCodeValue = "UNAUTHENTICATED"

final class ApolloServiceImpl: NSObject, ApolloService {
    // MARK: - Properties
    
    @Injected private var appConfiguration: AppConfigurationProvider
    @Injected private var crashReporter: CrashReporter
    @Injected private var inAppNotifier: InAppNotifier
    @Injected private var user: WhoppahCore.LegacyUserService
    @LazyInjected private var userProvider: UserProviding
    @Injected private var featureService: FeatureService

    @LazyInjected private var apollo: ApolloServiceClient
    private let bag = DisposeBag()
    private var certData: NSData?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    override required init() {
        super.init()
        
//        var handler: SSLCertHandler?
//
//        if featureService.sslPinningEnabled,
//            let sslCertPath = appConfiguration.sslCertFile
//        {
//            let data = NSData(contentsOfFile: sslCertPath)
//            handler = SSLCertHandler(certData: data)
//            certData = data
//        }
//
//        client = {
//            ApolloServiceImpl.getClient(environment: appConfiguration.environment,
//                                        token: userProvider.accessToken,
//                                        delegate: handler)
//        }()

//        userProvider.$accessToken.sink { _ in } receiveValue: { [weak self] token in
//            guard let self = self else { return }
//            self.client = {
//                ApolloServiceImpl.getClient(environment: self.appConfiguration.environment,
//                                            token: token,
//                                            delegate: handler)
//            }()
//        }
//        .store(in: &cancellables)

//        user.token.subscribe(onNext: { [weak self] token in
//            guard let self = self else { return }
//            self.client = {
//                ApolloServiceImpl.getClient(environment: self.appConfiguration.environment,
//                                            token: token,
//                                            delegate: handler)
//            }()
//        }).disposed(by: bag)
    }

//    private static func getClient(environment: AppEnvironment, token: String?, delegate: URLSessionDelegate?) -> ApolloClient {
//        let configuration = URLSessionConfiguration.default
//
//        configuration.httpAdditionalHeaders = ["Accept-Language": Locale.current.languageCode ?? "en"]
//
//        if let token = token {
//            configuration.httpAdditionalHeaders?["Authorization"] = "\(token)"
//        }
//
//        // Add additional headers as needed
//        let url = URL(string: environment.graphHost)!
//
//        let cache = InMemoryNormalizedCache()
//        let store = ApolloStore(cache: cache)
//        let client = URLSessionClient(sessionConfiguration: configuration, callbackQueue: nil)
//        let provider = NetworkInterceptorProvider(store: store, client: client)
//        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,
//                                                                 endpointURL: url)
//        let apolloClient = ApolloClient(networkTransport: requestChainTransport,
//                                        store: store)
//
//        apolloClient.cacheKeyForObject = { object in
//            if let id = object["id"] as? String,
//                let type = object["__typename"] as? String {
//                return [id, type]
//            }
//            // No id or typename, don't do caching
//            return nil
//        }
//        return apolloClient
//    }
}

extension ApolloServiceImpl {
    func watch<Query: GraphQLQuery>(query: Query, cache: CachePolicy = .returnCacheDataElseFetch, callback: @escaping ((Swift.Result<Query.Data, Error>) -> Void)) -> GraphQLQueryWatcher<Query> {
        apollo.client.watch(query: query, cachePolicy: cache, resultHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(results):
                if let errors = results.errors, let firstError = errors.first {
                    self.handleErrors(errors, definition: query.operationDefinition, variables: query.variables)
                    return callback(.failure(firstError))
                } else if let data = results.data {
                    callback(.success(data))
                }
            case let .failure(error):
                callback(.failure(error))
            }
        })
    }

    func fetch<Query: GraphQLQuery>(query: Query, cache: CachePolicy = .fetchIgnoringCacheData) -> Observable<GraphQLResult<Query.Data>> {
        Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let cancellable = self.apollo.client.fetch(query: query, cachePolicy: cache) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(results):
                    if let errors = results.errors, let firstError = errors.first {
                        self.handleErrors(errors, definition: query.operationDefinition, variables: query.variables)
                        return observer.onError(self.getUserError(firstError))
                    }
                    observer.onNext(results)
                    observer.onCompleted()
                case let .failure(error):
                    self.logError(error, definition: query.operationDefinition, variables: query.variables)
                    observer.onError(self.getUserError(error))
                }
            }

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }

    func apply<MutationQuery: GraphQLMutation>(mutation: MutationQuery) -> Observable<GraphQLResult<MutationQuery.Data>> {
        Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let cancellable = self.apollo.client.perform(mutation: mutation) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(results):
                    if let errors = results.errors, let firstError = errors.first {
                        self.handleErrors(errors, definition: mutation.operationDefinition, variables: mutation.variables)
                        return observer.onError(self.getUserError(firstError))
                    }
                    observer.onNext(results)
                    observer.onCompleted()
                case let .failure(error):
                    self.logError(error, definition: mutation.operationDefinition, variables: mutation.variables)
                    observer.onError(self.getUserError(error))
                }
            }

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }

    func apply<MutationQuery: GraphQLMutation, Query: GraphQLQuery>(mutation: MutationQuery,
                                                                    query: Query? = nil,
                                                                    storeTransaction: ((GraphQLResult<MutationQuery.Data>,
                                                                                        inout Query.Data) -> Void)? = nil) -> Observable<GraphQLResult<MutationQuery.Data>> {
        Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let cancellable = self.apollo.client.perform(mutation: mutation) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(results):
                    if let errors = results.errors, let firstError = errors.first {
                        self.handleErrors(errors, definition: mutation.operationDefinition, variables: mutation.variables)
                        return observer.onError(self.getUserError(firstError))
                    }
                    // We may want to update our apollo store on the result of a mutation
                    // If the user has specified (via params) then we start a read/write transaction and allow the client to execute it
                    if let block = storeTransaction, let query = query {
                        self.apollo.client.store.withinReadWriteTransaction({ (transaction: ApolloStore.ReadWriteTransaction) -> Void in
                            do {
                                try transaction.update(query: query) { (data: inout Query.Data) in
                                    block(results, &data)
                                }
                            } catch {}
                        }, callbackQueue: nil, completion: nil)
                    }
                    observer.onNext(results)
                    observer.onCompleted()
                case let .failure(error):
                    self.logError(error, definition: mutation.operationDefinition, variables: mutation.variables)
                    observer.onError(self.getUserError(error))
                }
            }

            return Disposables.create {
                cancellable.cancel()
            }
        }
    }

    func updateCache<Query: GraphQLQuery>(query: Query, transactionCallback: @escaping ((inout Query.Data) -> Void)) {
        let callback = { (transaction: ApolloStore.ReadWriteTransaction) in
            do {
                try transaction.update(query: query) { (data: inout Query.Data) in
                    transactionCallback(&data)
                }
            } catch {}
        }
        apollo.client.store.withinReadWriteTransaction(callback)
    }

    private func logError(_ error: Error, definition: String, variables: GraphQLMap?) {
        let nsError = error as NSError
        guard nsError.code != NSURLErrorCancelled else { return }
        guard !nsError.debugDescription.contains("Context creation failed: Invalid token") else {
            inAppNotifier.notify(.userLoggedOut)
            return
        }
        #if DEBUG
            print("Error for operation: \(definition)\nVariables: \(variablesAsJson(variables))\nError: \(error)")
        #endif
    }

    private func variablesAsJson(_ variables: GraphQLMap?) -> String {
        guard let vars = variables else { return "{}" }

        guard let data = try? JSONSerializationFormat.serialize(value: vars), let text = String(data: data, encoding: .utf8) else { return "{}" }
        return text
    }

    private func handleErrors(_ errors: [Apollo.GraphQLError], definition: String, variables: GraphQLMap?) {
        if let first = errors.first {
            let nsError = first as NSError
            guard nsError.code != NSURLErrorCancelled, errors.count == 1 else { return }

            crashReporter.log(error: first,
                              withInfo: ["definition": definition, "variables": variablesAsJson(variables)])
        }

        #if DEBUG
            print("Error in operation: \(definition)\nVariables: \(variablesAsJson(variables))\nErrors: \(errors)")
        #endif

        for extensions in errors.compactMap({ $0.extensions }) {
            if let found = extensions.first(where: { $0.key == errorCodeKey }) {
                if let value = found.value as? String, value == errorCodeValue {
                    inAppNotifier.notify(.userLoggedOut)
                    break
                }
            }
        }
    }

    private func getUserError(_ error: Error) -> Error {
        guard showVerboseUserErrors else { return GenericUserError(underlyingError: error) }
        return error
    }
}

private class SSLCertHandler: NSObject, URLSessionDelegate {
    private var certData: NSData?
    init(certData: NSData?) {
        self.certData = certData
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        handleSSLCert(session, certData: certData, didReceive: challenge, completionHandler: completionHandler)
    }
}

struct NetworkInterceptorProvider: InterceptorProvider {
    
    // These properties will remain the same throughout the life of the `InterceptorProvider`, even though they
    // will be handed to different interceptors.
    private let store: ApolloStore
    private let client: URLSessionClient
    
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: self.store),
            NetworkFetchInterceptor(client: self.client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: self.store)
        ]
    }
}
