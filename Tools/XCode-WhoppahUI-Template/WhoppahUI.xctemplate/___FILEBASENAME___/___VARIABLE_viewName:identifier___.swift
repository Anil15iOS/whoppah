//  ___FILEHEADER___

import SwiftUI
import ComposableArchitecture

public struct ___VARIABLE_viewName:identifier___: View, StoreInitializable {
    let store: Store<___VARIABLE_viewName:identifier___.ViewState, ___VARIABLE_viewName:identifier___.Action>?

    public init(store: Store<___VARIABLE_viewName:identifier___.ViewState, ___VARIABLE_viewName:identifier___.Action>?) {
        self.store = store
        
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
        }
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in

            }
        } else {
            EmptyView()
        }
    }
}

struct ___VARIABLE_viewName:identifier____Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: ___VARIABLE_viewName:identifier___.Reducer().reducer,
                          environment: .init(localizationClient: ___VARIABLE_viewName:identifier___.mockLocalizationClient,
                                             trackingClient: ___VARIABLE_viewName:identifier___.mockTrackingClient,
                                             outboundActionClient: ___VARIABLE_viewName:identifier___.mockOutboundActionClient,
                                             mainQueue: .main))
        
        ___VARIABLE_viewName:identifier___(store: store)
    }
}
