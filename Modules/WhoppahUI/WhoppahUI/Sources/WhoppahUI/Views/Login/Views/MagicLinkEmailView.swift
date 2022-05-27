//
//  MagicLinkEmailView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct MagicLinkEmailView: View {
    typealias NavView = LoginView.NavigationView
    
    private let store: Store<LoginView.ViewState, LoginView.Action>?
    
    @State private var isEmailValid: Bool = false
    @State private var emailValue: String = ""
    @State private var mainButtonShouldShowProgress: Bool = false
    
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
                    KeyboardEnabledView(doneButtonTitle: viewStore.state.model.common.doneButtonTitle) {
                        VStack(alignment: .leading,
                               spacing: WhoppahTheme.Size.Padding.medium) {
                            Text(viewStore.state.model.magicLink.magicLinkTitle)
                                .font(WhoppahTheme.Font.h3)

                            Text(viewStore.state.model.magicLink.magicLinkDescription)
                                .font(WhoppahTheme.Font.paragraph)
                                .padding(.all, 0)

                            TextInputWithValidation(placeholderText: viewStore.state.model.magicLink.enterYourEmailPlaceholder,
                                                    disableAutoCorrection: true,
                                                    disableAutoCapitalization: true,
                                                    validators: [
                                                        EmptyStringValidator(viewStore.state.model.common.invalidEmailOrPassword),
                                                        EmailValidator(viewStore.state.model.common.invalidEmailOrPassword)
                                                    ],
                                                    isInputValid: $isEmailValid,
                                                    inputValue: $emailValue)
                                .keyboardType(.emailAddress)

                            Spacer()
                        }
                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                        .padding(.bottom, WhoppahTheme.Size.CTA.height)

                        HStack {
                            PushView(destination: MagicLinkEnterCodeView(store: store,
                                                                         navigationTitle: $navigationTitle,
                                                                         emailValue: $emailValue),
                                     destinationId: NavView.magicLinkEnterCode.identifier) {
                                CallToAction(backgroundColor: WhoppahTheme.Color.primary1,
                                             foregroundColor: WhoppahTheme.Color.base4,
                                             iconName: nil,
                                             title: viewStore.state.model.magicLink.sendLinkButtonTitle,
                                             showBorder: false,
                                             showingProgress: $mainButtonShouldShowProgress) {}
                                .disabled(true)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                guard isEmailValid, !mainButtonShouldShowProgress else { return }
                                
                                viewStore.send(.outboundAction(.didTapSendMagicLinkCode(email: emailValue)))
                            })
                            .disabled(!isEmailValid || mainButtonShouldShowProgress)
                        }
                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                        .padding(.bottom, WhoppahTheme.Size.Padding.large)
                        .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth,
                               maxHeight: .infinity,
                               alignment: .bottom)
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }

                //
                // 📙 Navigation title
                //

                .onReceive(Just(viewStore.state.model.magicLink.navigationTitle)) { title in
                    navigationTitle = title
                }

                .valueChanged(value: viewStore.state.mainButtonState) { newValue in
                    mainButtonShouldShowProgress = newValue == .inProgress
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct MagicLinkEmailView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: LoginView.Reducer().reducer,
                          environment: .init(localizationClient: LoginView.mockLocalizationClient,
                                             trackingClient: LoginView.mockTrackingClient,
                                             outboundActionClient: LoginView.mockOutboundActionClient,
                                             mainQueue: .main))

        MagicLinkEmailView(store: store,
                           navigationTitle: .constant("Title"))
    }
}
