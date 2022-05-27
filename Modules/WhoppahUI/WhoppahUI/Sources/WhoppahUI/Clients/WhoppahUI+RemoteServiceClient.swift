//
//  WhoppahUI+RemoteServiceClient.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import ComposableArchitecture

public extension WhoppahUI {
    struct RemoteServiceClientError: Swift.Error, Equatable {}
    
    struct RemoteServiceClient<T> {
        var fetch: () -> Effect<T, RemoteServiceClientError>
        
        public init(fetch: @escaping () -> Effect<T, RemoteServiceClientError>) {
            self.fetch = fetch
        }
    }
}
