//  
//  StoreAndSell.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 13/12/2021.
//

import SwiftUI
import ComposableArchitecture

public struct StoreAndSell: View, StoreInitializable {
    let store: Store<StoreAndSell.ViewState, StoreAndSell.Action>?

    public init(store: Store<StoreAndSell.ViewState, StoreAndSell.Action>?) {
        self.store = store
        
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
        }
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                Text(viewStore.state.model.title)
            }
        } else {
            EmptyView()
        }
    }
}

struct StoreAndSell_Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: StoreAndSell.Reducer().reducer,
                          environment: .init(localizationClient: StoreAndSell.mockLocalizationClient,
                                             trackingClient: StoreAndSell.mockTrackingClient,
                                             outboundActionClient: StoreAndSell.mockOutboundActionClient,
                                             mainQueue: .main))
        
        StoreAndSell(store: store)
    }
}
