//
//  HowWhoppahWorks.swift
//  
//
//  Created by Dennis Ippel on 08/11/2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct HowWhoppahWorks: View, StoreInitializable {
    let store: Store<HowWhoppahWorks.ViewState, HowWhoppahWorks.Action>?
    
    public init(store: Store<HowWhoppahWorks.ViewState, HowWhoppahWorks.Action>?) {
        self.store = store
    }
    
    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                HowWhoppahWorksOverview(title: viewStore.model.title,
                                        pages: viewStore.model.pages,
                                        store: store)
                    .onAppear {
                        viewStore.send(.loadContent)
                    }
            }
        } else {
            EmptyView()
        }
    }
}

struct HowWhoppahWorks_Previews: PreviewProvider {
    init() {
        WhoppahUI.registerFonts()
    }
    
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: HowWhoppahWorks.Reducer().reducer,
                          environment: .init(localizationClient: HowWhoppahWorks.mockLocalizationClient,
                                             trackingClient: HowWhoppahWorks.mockTrackingClient,
                                             outboundActionClient: HowWhoppahWorks.mockOutboundActionClient,
                                             mainQueue: .main))
        HowWhoppahWorks(store: store)
    }
}
