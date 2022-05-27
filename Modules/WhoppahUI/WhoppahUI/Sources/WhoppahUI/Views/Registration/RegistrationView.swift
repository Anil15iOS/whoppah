//  
//  RegistrationView.swift
//  WhoppahUIIntegrationTest
//
//  Created by Dennis Ippel on 17/01/2022.
//

import SwiftUI
import ComposableArchitecture
import Combine

public struct RegistrationView: View, StoreInitializable {
    private let store: Store<RegistrationView.ViewState, RegistrationView.Action>?
    private let navigationStack: NavigationStack
    
    @State private var navigationTitle: String = ""
    
    public init(store: Store<RegistrationView.ViewState, RegistrationView.Action>?) {
        self.store = store
        self.navigationStack = NavigationStack()
        
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
            viewStore.send(.trackingAction(.signUpStart))
        }
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                NavigationStackViewWithHeader(navigationStack: navigationStack,
                                              headerTitle: $navigationTitle,
                                              didTapCloseButton: { viewStore.send(.outboundAction(.didTapCloseButton)) }) {
                    VStack(spacing: WhoppahTheme.Size.Padding.extraMedium) {
                        Text(viewStore.state.model.chooseSignupType.title)
                            .font(WhoppahTheme.Font.h3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        //
                        // 📙 Enter username & email (individual)
                        //
                        
                        PushView(destination: RegistrationEnterUsernameEmailView(store: store,
                                                                                 signUpType: .individual,
                                                                                 navigationTitle: $navigationTitle),
                                 destinationId: NavigationView.enterUsernameIndividual.identifier)
                        {
                            CallToAction(backgroundColor: WhoppahTheme.Color.base4,
                                         foregroundColor: WhoppahTheme.Color.alert3,
                                         iconName: "happy_icon",
                                         title: viewStore.state.model.chooseSignupType.person,
                                         showBorder: true,
                                         showChevron: true) {}
                                         .disabled(true)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            viewStore.send(.outboundAction(.didChooseSignUpType(type: .individual)))
                        })
                        
                        //
                        // 📙 Enter username & email (business)
                        //
                        
                        PushView(destination: RegistrationEnterUsernameEmailView(store: store,
                                                                                 signUpType: .business,
                                                                                 navigationTitle: $navigationTitle),
                                 destinationId: NavigationView.enterUsernameBusiness.identifier)
                        {
                            CallToAction(backgroundColor: WhoppahTheme.Color.base4,
                                         foregroundColor: WhoppahTheme.Color.alert3,
                                         iconName: "business_icon",
                                         title: viewStore.state.model.chooseSignupType.business,
                                         showBorder: true,
                                         showChevron: true) {}
                                         .disabled(true)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            viewStore.send(.outboundAction(.didChooseSignUpType(type: .business)))
                        })
                        
                        Spacer()
                    }
                    .padding(.all, WhoppahTheme.Size.Padding.medium)
                    .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth, maxHeight: .infinity)
                }
                
                //
                // 📙 Navigation title
                //

                .onReceive(Just(viewStore.state.model.chooseSignupType.navigationTitle)) { title in
                    navigationTitle = title
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: RegistrationView.Reducer().reducer,
                          environment: .init(localizationClient: RegistrationView.mockLocalizationClient,
                                             trackingClient: RegistrationView.mockTrackingClient,
                                             outboundActionClient: RegistrationView.mockOutboundActionClient,
                                             mainQueue: .main))
        
        RegistrationView(store: store)
    }
}
