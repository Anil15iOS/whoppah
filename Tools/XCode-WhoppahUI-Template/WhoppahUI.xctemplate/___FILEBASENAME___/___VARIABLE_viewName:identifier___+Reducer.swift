//  ___FILEHEADER___

import ComposableArchitecture

public extension ___VARIABLE_viewName:identifier___ {
    struct Reducer {
        public init() {}
        
        public let reducer = ComposableArchitecture.Reducer<ViewState, Action, Environment> { state, action, environment in
            switch action {
            case .loadContent:
                state.loadingState = .finished
                return environment.localizationClient.fetch()
                    .receive(on: environment.mainQueue)
                    .catchToEffect(___VARIABLE_viewName:identifier___.Action.didFinishLoadingContent)
            case .didFinishLoadingContent(.success(let model)):
                state.model = model
                state.loadingState = .finished
                return .none
            case .didFinishLoadingContent(.failure(_)):
                state.loadingState = .failed
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