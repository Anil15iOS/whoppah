//
//  UpdateAppDialog+Reducer.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import Foundation
import ComposableArchitecture
import simd

public extension UpdateAppDialog {
    struct Reducer {
        public init() {}
        
        public let reducer = ComposableArchitecture.Reducer<ViewState, Action, Environment> { state, action, environment in
            switch action {
            case .loadContent:
                return environment.localizationClient.fetch()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(UpdateAppDialog.Action.didFinishLoadingContent)
            case .didFinishLoadingContent(.success(let model)):
                state.model = model
                return .none
            case .outboundAction(let action):
                _ = environment.outboundActionClient.perform(action)
                return .none
            default:
                return .none
            }
        }
    }
}
