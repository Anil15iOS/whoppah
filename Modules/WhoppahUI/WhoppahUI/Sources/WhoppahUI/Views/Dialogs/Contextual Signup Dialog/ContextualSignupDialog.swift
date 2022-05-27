//  
//  ContextualSignupDialog.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import SwiftUI
import ComposableArchitecture

public struct ContextualSignupDialog: View, StoreInitializable {
    let store: Store<ContextualSignupDialog.ViewState, ContextualSignupDialog.Action>?

    public init(store: Store<ContextualSignupDialog.ViewState, ContextualSignupDialog.Action>?) {
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
                                     title: viewStore.state.model.loginButtonTitle,
                                     showBorder: false)
                        {
                            viewStore.send(.outboundAction(.didTapLogInButton))
                            viewStore.send(.trackingAction(.didTapLogInButton))
                        }
                        
                        CallToAction(backgroundColor: WhoppahTheme.Color.base4,
                                     foregroundColor: WhoppahTheme.Color.primary1,
                                     iconName: "wave_icon",
                                     title: viewStore.state.model.registerButtonTitle,
                                     showBorder: true)
                        {
                            viewStore.send(.outboundAction(.didTapRegisterButton))
                            viewStore.send(.trackingAction(.didTapRegisterButton))
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

struct ContextualSignupDialog_Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: ContextualSignupDialog.Reducer().reducer,
                          environment: .init(localizationClient: ContextualSignupDialog.mockLocalizationClient,
                                             trackingClient: ContextualSignupDialog.mockTrackingClient,
                                             outboundActionClient: ContextualSignupDialog.mockOutboundActionClient,
                                             mainQueue: .main))
        
        ContextualSignupDialog(store: store)
    }
}
