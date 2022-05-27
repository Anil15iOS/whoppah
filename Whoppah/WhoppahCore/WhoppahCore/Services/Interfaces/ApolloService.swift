//
//  ApolloService.swift
//  Whoppah
//
//  Created by Eddie Long on 24/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift

public protocol ApolloService {
    /// Watch a given GraphQL query.
    /// When being watched, any change in the data being watched will automatically invoke the callback with the latest data.
    ///
    /// - Parameter query The GraphQL query to watch
    /// - Parameter cache The Apollo CachePolicy
    /// - Parameter callback callback to invoke whenever the underlying watched data changes
    /// - Returns: The Apollo watcher that can be used to control the watch behaviour from the callee side
    func watch<Query: GraphQLQuery>(query: Query,
                                    cache: CachePolicy,
                                    callback: @escaping ((Swift.Result<Query.Data, Error>) -> Void)) -> GraphQLQueryWatcher<Query>

    /// Fetch a given GraphQL query
    ///
    /// - Parameter query The GraphQL query to watch
    /// - Parameter cache The Apollo CachePolicy
    /// - Returns: An observable with the GraphQL result data
    func fetch<Query: GraphQLQuery>(query: Query, cache: CachePolicy) -> Observable<GraphQLResult<Query.Data>>

    /// Apply a GraphQL mutation, calling the backend to mutate the data
    ///
    /// - Parameter mutation The input to send to the serevr
    /// - Returns: An observable with the GraphQL mutation result data
    func apply<MutationQuery: GraphQLMutation>(mutation: MutationQuery) -> Observable<GraphQLResult<MutationQuery.Data>>

    /// Apply a GraphQL mutation, calling the backend to mutate the data
    /// This variant allows a user to also manually update the underlying Apollo store
    /// The backend does not always return data that updates the Apollo store properly (e.g. adding an address to a merchant)
    /// So sometimes we need to manually go and update the underlying Apollo store/cache ourselves
    ///
    /// - Parameter mutation The input to send to the server
    /// - Parameter query A query whose data stored in the Apollo store needs to be manually updated
    /// - Parameter storeTransaction A closure that wraps an Apollo transaction, any chances made to the GraphQL data in the closure will be reflected in the apollo store data.
    /// - Returns: An observable with the GraphQL mutation result data
    func apply<MutationQuery: GraphQLMutation, Query: GraphQLQuery>(mutation: MutationQuery,
                                                                    query: Query?,
                                                                    storeTransaction: ((GraphQLResult<MutationQuery.Data>,
                                                                                        inout Query.Data) -> Void)?) -> Observable<GraphQLResult<MutationQuery.Data>>

    /// Update the Apollo store for a given query data
    ///
    /// - Parameter query The GraphQL query whose data is to be updated
    /// - Parameter transactionCallback A closure that wraps an Apollo transaction, any chances made to the GraphQL data in the closure will be reflected in the apollo store data.
    func updateCache<Query: GraphQLQuery>(query: Query, transactionCallback: @escaping ((inout Query.Data) -> Void))
}

public extension ApolloService {
    /// Watch a given GraphQL query.
    /// When being watched, any change in the data being watched will automatically invoke the callback with the latest data.
    /// Cache policy defaults to 'return cached data, otherwise fetch from server)
    ///
    /// - Parameter query The GraphQL query to watch
    /// - Parameter callback callback to invoke whenever the underlying watched data changes
    /// - Returns: The Apollo watcher that can be used to control the watch behaviour from the callee side
    func watch<Query: GraphQLQuery>(query: Query,
                                    callback: @escaping ((Swift.Result<Query.Data, Error>) -> Void)) -> GraphQLQueryWatcher<Query> {
        watch(query: query, cache: .returnCacheDataElseFetch, callback: callback)
    }

    /// Fetch a given GraphQL query
    /// Cache policy defaults to ignoring cache
    ///
    /// - Parameter query The GraphQL query to watch
    /// - Parameter cache The Apollo CachePolicy
    /// - Returns: An observable with the GraphQL result data
    func fetch<Query: GraphQLQuery>(query: Query) -> Observable<GraphQLResult<Query.Data>> {
        fetch(query: query, cache: .fetchIgnoringCacheData)
    }

    /// Apply a GraphQL mutation, calling the backend to mutate the data
    /// This variant allows a user to also manually update the underlying Apollo store
    /// The backend does not always return data that updates the Apollo store properly (e.g. adding an address to a merchant)
    /// So sometimes we need to manually go and update the underlying Apollo store/cache ourselves
    ///
    /// - Parameter mutation The input to send to the server
    /// - Parameter query A query whose data stored in the Apollo store needs to be manually updated (defaults to nil)
    /// - Parameter storeTransaction A closure that wraps an Apollo transaction, any chances made to the GraphQL data in the closure will be reflected in the apollo store data.  (defaults to nil)
    /// - Returns: An observable with the GraphQL mutation result data
    func apply<MutationQuery: GraphQLMutation, Query: GraphQLQuery>(mutation: MutationQuery,
                                                                    query: Query? = nil,
                                                                    storeTransaction: ((GraphQLResult<MutationQuery.Data>,
                                                                                        inout Query.Data) -> Void)? = nil) -> Observable<GraphQLResult<MutationQuery.Data>> {
        apply(mutation: mutation, query: query, storeTransaction: storeTransaction)
    }
}
