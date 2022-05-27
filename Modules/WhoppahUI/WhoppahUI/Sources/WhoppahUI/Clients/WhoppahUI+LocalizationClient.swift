//
//  File.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import Foundation
import ComposableArchitecture

public extension WhoppahUI {
    enum LocalizationClientError: Error, Equatable {
        case couldNotLoad
    }

    struct LocalizationClient<T> {
        var fetch: () -> Effect<T, LocalizationClientError>
        
        public init(fetch: @escaping () -> Effect<T, LocalizationClientError>) {
            self.fetch = fetch
        }
    }
}
