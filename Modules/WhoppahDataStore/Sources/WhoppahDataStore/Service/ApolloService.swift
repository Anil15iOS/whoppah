//
//  ApolloService.swift
//  
//
//  Created by Dennis Ippel on 26/11/2021.
//

import Apollo
import Foundation
import Resolver
import Combine
import WhoppahCoreNext
import WhoppahRepository
import WhoppahModel

class ApolloService {
    @Injected private var apollo: ApolloServiceClient
    @Injected private var crashReporter: CrashReporter
    @Injected private var inAppNotifier: InAppNotifier
    
    func watch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                    callback: @escaping ((Swift.Result<Query.Data, Error>) -> Void)) -> GraphQLQueryWatcher<Query> {
        apollo.client.watch(query: query,
                            cachePolicy: cachePolicy,
                            resultHandler: { [weak self] result in
            switch result {
            case let .success(results):
                if let errors = results.errors, let firstError = errors.first {
                    let errorToReport = self?.handleErrors(
                        errors,
                        definition: query.operationDefinition,variables: query.variables)
                    callback(.failure(errorToReport ?? firstError))
                } else if let data = results.data {
                    callback(.success(data))
                }
            case let .failure(error):
                callback(.failure(error))
            }
        })
    }
    
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cache: CachePolicy = .returnCacheDataElseFetch) -> AnyPublisher<GraphQLResult<Query.Data>, Error>
    {
        return Future<GraphQLResult<Query.Data>, Error> { [weak self] promise in
            self?.apollo.client.fetch(query: query,
                                cachePolicy: cache) { [weak self] result in
                self?.processResult(query, result: result, completion: promise)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func apply<MutationQuery: GraphQLMutation>(
        mutation: MutationQuery) -> AnyPublisher<GraphQLResult<MutationQuery.Data>, Error>
    {
        return Future<GraphQLResult<MutationQuery.Data>, Error> { [weak self] promise in
            self?.apollo.client.perform(mutation: mutation) { [weak self] result in
                self?.processResult(mutation, result: result, completion: promise)
            }
        }
        .eraseToAnyPublisher()
    }

    func apply<MutationQuery: GraphQLMutation, Query: GraphQLQuery>(mutation: MutationQuery,
                                                                    query: Query? = nil,
                                                                    storeTransaction: ((GraphQLResult<MutationQuery.Data>,
                                                                                        inout Query.Data) -> Void)? = nil) -> Future<GraphQLResult<MutationQuery.Data>, Error> {
        return Future<GraphQLResult<MutationQuery.Data>, Error> { [weak self] promise in
            self?.apollo.client.perform(mutation: mutation) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case let .success(results):
                    if let errors = results.errors, let firstError = errors.first {
                        let errorToReport = self.handleErrors(
                            errors,
                            definition: mutation.operationDefinition,variables: mutation.variables)
                        promise(.failure(errorToReport ?? firstError))
                        return
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
                    promise(.success(results))
                case let .failure(error):
                    self.logError(error, definition: mutation.operationDefinition, variables: mutation.variables)
                    promise(.failure(error))
                }
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
    
    private func processResult<Query: GraphQLOperation>(
        _ query: Query,
        result: Result<GraphQLResult<Query.Data>, Error>,
        promise: (Result<GraphQLResult<Query.Data>, Error>) -> Void)
    {
        switch result {
        case let .success(results):
            if let errors = results.errors, let firstError = errors.first {
                let errorToReport = self.handleErrors(
                    errors,
                    definition: query.operationDefinition,variables: query.variables)
                promise(.failure(errorToReport ?? firstError))
            }
            promise(.success(results))
        case let .failure(error):
            self.logError(error, definition: query.operationDefinition, variables: query.variables)
            promise(.failure(error))
        }
    }
    
    private func processResult<Query: GraphQLOperation>(
        _ query: Query,
        result: Result<GraphQLResult<Query.Data>, Error>,
        completion: (Swift.Result<GraphQLResult<Query.Data>, Error>) -> Void)
    {
        switch result {
        case let .success(results):
            if let errors = results.errors, let firstError = errors.first {
                let errorToReport = self.handleErrors(
                    errors,
                    definition: query.operationDefinition,variables: query.variables)
                completion(.failure(errorToReport ?? firstError))
            }
            completion(.success(results))
        case let .failure(error):
            self.logError(error, definition: query.operationDefinition, variables: query.variables)
            completion(.failure(error))
        }
    }
    
    private func handleErrors(_ errors: [Apollo.GraphQLError],
                              definition: String,
                              variables: GraphQLMap?) -> Error? {
        if let firstError = errors.first {
            logError(firstError,
                     definition: definition,
                     variables: variables)
        }

        for extensions in errors.compactMap({ $0.extensions }) {
            if let found = extensions.first(where: { $0.key == "code" }) {
                if let value = found.value as? String, value == "UNAUTHENTICATED" {
                    inAppNotifier.notify(.userLoggedOut)
                    return WhoppahError.userNotSignedIn
                }
            }
        }
        
        return nil
    }
    
    private func logError(_ error: Error, definition: String, variables: GraphQLMap?) {
        let nsError = error as NSError
        guard nsError.code != NSURLErrorCancelled else { return }
        guard !nsError.debugDescription.contains("Context creation failed: Invalid token") else {
            inAppNotifier.notify(.userLoggedOut)
            return
        }
        
        crashReporter.log(error: nsError,
                          withInfo: ["definition": definition,
                                     "variables": variables?.asJsonString ?? ""])
    }
}
