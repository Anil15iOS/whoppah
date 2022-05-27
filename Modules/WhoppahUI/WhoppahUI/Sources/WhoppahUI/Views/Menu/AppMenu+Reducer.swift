//
//  AppMenu+Reducer.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import ComposableArchitecture

public extension AppMenu {
    struct Reducer {
        public init() {}
        
        public let reducer = ComposableArchitecture.Reducer<ViewState, Action, Environment> { state, action, environment in
            switch action {
            case .loadContent:
                return environment.localizationClient.fetch()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(AppMenu.Action.didFinishLoadingContent)
            case .didFinishLoadingContent(.success(let model)):
                state.model = model
                return environment.categoriesClient
                    .fetchCategoriesByLevel(0)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(AppMenu.Action.didFinishLoadingCategories)
            case .didFinishLoadingCategories(.success(let categories)):
                state.categories = categories
                return .none
            case .trackingAction(let action):
                _ = environment.trackingClient.track(action)
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
