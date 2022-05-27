//
//  ForgotPasswordView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct ForgotPasswordView: View {
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
                            Text(viewStore.state.model.forgotPassword.enterYourEmailTitle)
                                .font(WhoppahTheme.Font.h3)

                            Text(viewStore.state.model.forgotPassword.forgotPasswordDescription)
                                .font(WhoppahTheme.Font.paragraph)
                                .padding(.all, 0)

                            TextInputWithValidation(placeholderText: viewStore.state.model.forgotPassword.enterYourEmailPlaceholder,
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
                            PushView(destination: ForgotPasswordConfirmationView(store: store,
                                                                                 navigationTitle: $navigationTitle),
                                     destinationId: NavView.forgotPasswordConfirmation.identifier) {
                                CallToAction(backgroundColor: WhoppahTheme.Color.primary1,
                                             foregroundColor: WhoppahTheme.Color.base4,
                                             iconName: nil,
                                             title: viewStore.state.model.forgotPassword.sendButtonTitle,
                                             showBorder: false,
                                             showingProgress: $mainButtonShouldShowProgress)
                                {}
                                .disabled(true)
                            }
                            .disabled(!isEmailValid)
                            .simultaneousGesture(TapGesture().onEnded {
                                guard isEmailValid, !mainButtonShouldShowProgress else { return }
                                
                                viewStore.send(.outboundAction(.didTapSendPasswordResetLink(email: emailValue)))
                            })
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

                .onReceive(Just(viewStore.state.model.forgotPassword.navigationTitle)) { title in
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

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: LoginView.Reducer().reducer,
                      environment: .init(localizationClient: LoginView.mockLocalizationClient,
                                         trackingClient: LoginView.mockTrackingClient,
                                         outboundActionClient: LoginView.mockOutboundActionClient,
                                         mainQueue: .main))

        ForgotPasswordView(store: store,
                           navigationTitle: .constant("Title"))
    }
}
