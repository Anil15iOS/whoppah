//
//  WhoppahUI+TrackingClient.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import ComposableArchitecture

public extension WhoppahUI {
    struct TrackingClient<T> {
        var track: (T) -> Effect<Void, Never>

        public init(track: @escaping (T) -> Effect<Void, Never>) {
            self.track = track
        }
    }
}
