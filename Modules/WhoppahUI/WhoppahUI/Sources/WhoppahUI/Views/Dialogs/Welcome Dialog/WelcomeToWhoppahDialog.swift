//  
//  WelcomeToWhoppahDialog.swift
//  
//
//  Created by Dennis Ippel on 15/02/2022.
//

import SwiftUI
import ComposableArchitecture

public struct WelcomeToWhoppahDialog: View, StoreInitializable {
    let store: Store<WelcomeToWhoppahDialog.ViewState, WelcomeToWhoppahDialog.Action>?

    public init(store: Store<WelcomeToWhoppahDialog.ViewState, WelcomeToWhoppahDialog.Action>?) {
        self.store = store
        
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
        }
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                ModalDialog(title: viewStore.model.title,
                            description: viewStore.model.description)
                {
                    viewStore.send(.outboundAction(.didTapCloseButton))
                } content: {
                    VStack(spacing: WhoppahTheme.Size.Padding.medium) {
                        CallToAction(backgroundColor: WhoppahTheme.Color.primary1,
                                     foregroundColor: WhoppahTheme.Color.base4,
                                     iconName: nil,
                                     title: viewStore.state.model.createAdButtonTitle,
                                     showBorder: false)
                        {
                            viewStore.send(.outboundAction(.didTapCreateAdButton))
                            viewStore.send(.trackingAction(.didTapCreateAdButton))
                        }
                        
                        CallToAction(backgroundColor: WhoppahTheme.Color.base4,
                                     foregroundColor: WhoppahTheme.Color.primary1,
                                     title: viewStore.state.model.discoverDesignButtonTitle,
                                     showBorder: true)
                        {
                            viewStore.send(.outboundAction(.didTapDiscoverDesignButton))
                            viewStore.send(.trackingAction(.didTapDiscoverDesignButton))
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.loadContent)
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct WelcomeToWhoppahDialog_Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: WelcomeToWhoppahDialog.Reducer().reducer,
                          environment: .init(localizationClient: WelcomeToWhoppahDialog.mockLocalizationClient,
                                             trackingClient: WelcomeToWhoppahDialog.mockTrackingClient,
                                             outboundActionClient: WelcomeToWhoppahDialog.mockOutboundActionClient,
                                             mainQueue: .main))
        
        WelcomeToWhoppahDialog(store: store)
    }
}
