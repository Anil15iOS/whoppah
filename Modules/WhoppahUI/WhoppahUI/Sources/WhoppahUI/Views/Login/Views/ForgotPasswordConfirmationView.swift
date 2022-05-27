//
//  ForgotPasswordConfirmationView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct ForgotPasswordConfirmationView: View {
    private let store: Store<LoginView.ViewState, LoginView.Action>?
    
    @EnvironmentObject private var navigationStack: NavigationStack
    @Binding private var navigationTitle: String
    
    public init(store: Store<LoginView.ViewState, LoginView.Action>?,
                navigationTitle: Binding<String>) {
        self.store = store
        self._navigationTitle = navigationTitle

        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
        }
    }
    
    var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                ZStack {
                    VStack {
                        VStack(alignment: .leading,
                               spacing: WhoppahTheme.Size.Padding.medium) {
                            
                            HStack {
                                Text(viewStore.state.model.forgotPasswordConfirmation.resetPasswordSentTitle)
                                    .font(WhoppahTheme.Font.h3)
                                Image(systemName: "checkmark")
                                    .foregroundColor(WhoppahTheme.Color.alert2)
                            }

                            Text(viewStore.state.model.forgotPasswordConfirmation.resetPasswordSentDescription)
                                .font(WhoppahTheme.Font.paragraph)
                                .padding(.all, 0)

                            Spacer()
                        }
                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                        .padding(.bottom, WhoppahTheme.Size.CTA.height)
                    }
                    .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth)
                    .scrollWithAdaptiveBounce(.vertical, showsIndicators: true)
                    
                    HStack {
                        CallToAction(backgroundColor: WhoppahTheme.Color.primary1,
                                     foregroundColor: WhoppahTheme.Color.base4,
                                     iconName: nil,
                                     title: viewStore.state.model.forgotPasswordConfirmation.backToLoginButtonTitle,
                                     showBorder: false)
                        {
                            viewStore.send(.outboundAction(.didTapSignInAgain))
                        }
                    }
                    .padding(.all, WhoppahTheme.Size.Padding.medium)
                    .padding(.bottom, WhoppahTheme.Size.Padding.large)
                    .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth,
                           maxHeight: .infinity,
                           alignment: .bottom)
                    .edgesIgnoringSafeArea(.bottom)
                }
                
                //
                // 📙 Navigation title
                //

                .onReceive(Just(viewStore.state.model.forgotPasswordConfirmation.navigationTitle)) { title in
                    navigationTitle = title
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct ForgotPasswordConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: LoginView.Reducer().reducer,
                      environment: .init(localizationClient: LoginView.mockLocalizationClient,
                                         trackingClient: LoginView.mockTrackingClient,
                                         outboundActionClient: LoginView.mockOutboundActionClient,
                                         mainQueue: .main))
        
        ForgotPasswordConfirmationView(store: store,
                                       navigationTitle: .constant("Title"))
    }
}
