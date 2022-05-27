//
//  File.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import ComposableArchitecture

public extension WhoppahUI {
    struct OutboundActionClient<ActionType, EffectType> {
        var perform: (ActionType) -> EffectType
        
        public init(perform: @escaping (ActionType) -> EffectType) {
            self.perform = perform
        }
    }
}
