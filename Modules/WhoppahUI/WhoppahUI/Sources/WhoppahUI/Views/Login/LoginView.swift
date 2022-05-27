//  
//  LoginView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 23/12/2021.
//

import SwiftUI
import ComposableArchitecture
import Combine

public struct LoginView: View, StoreInitializable {
    private let store: Store<LoginView.ViewState, LoginView.Action>?
    private var navigationStack = NavigationStack()
    private var initialView: LoginView.NavigationView = .none
    
    @State private var navigationTitle: String = ""
    @State private var isEmailValid: Bool = false
    @State private var isPasswordValid: Bool = false
    @State private var emailValue: String = ""
    @State private var passwordValue: String = ""
    @State private var mainButtonShouldShowProgress: Bool = false
    @State private var footerSize: CGSize = .zero
    
    
    public init(store: Store<LoginView.ViewState, LoginView.Action>?) {
        self.store = store
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
        }
    }
    
    public init(store: Store<LoginView.ViewState, LoginView.Action>?,
                navigationStack: NavigationStack? = nil,
                initialView: LoginView.NavigationView = .none) {
        self.init(store: store)
        self.navigationStack = navigationStack ?? NavigationStack()
        self.initialView = initialView
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                
                let emailInput = TextInputWithValidation(placeholderText: viewStore.state.model.login.emailPlaceHolderText,
                                                         disableAutoCorrection: true,
                                                         disableAutoCapitalization: true,
                                                         validators: [
                                                            EmptyStringValidator(viewStore.state.model.common.invalidEmail),
                                                            EmailValidator(viewStore.state.model.common.invalidEmail)
                                                         ],
                                                         isInputValid: $isEmailValid,
                                                         inputValue: $emailValue)

                let passwordInput = TextInputWithValidation(placeholderText: viewStore.state.model.login.passwordPlaceHolderText,
                                                            isSecureField: true,
                                                            disableAutoCorrection: true,
                                                            validators: [EmptyStringValidator(viewStore.state.model.common.invalidPassword)],
                                                            isInputValid: $isPasswordValid,
                                                            inputValue: $passwordValue)
                
                NavigationStackViewWithHeader(navigationStack: navigationStack,
                                              headerTitle: $navigationTitle,
                                              didTapCloseButton: { viewStore.send(.outboundAction(.dismissView)) }) {
                    if initialView != .none {
                        produceView(initialView, store: store, navigationTitle: $navigationTitle)
                        
                        //
                        // 📙 Navigation title
                        //

                        .onReceive(Just(viewStore.state.model.login.navigationTitle)) { title in
                            navigationTitle = title
                        }

                        .valueChanged(value: viewStore.state.mainButtonState) { newValue in
                            mainButtonShouldShowProgress = newValue == .inProgress
                        }

                    } else {
                        KeyboardEnabledView(doneButtonTitle: viewStore.state.model.common.doneButtonTitle) {
                            VStack {
                                Text(viewStore.state.model.login.title)
                                    .font(WhoppahTheme.Font.h3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                //
                                // 📙 Error message
                                //
                                
                                if viewStore.state.authenticationFailedMessageIsVisible {
                                    InlineWarningMessage(icon: .alert,
                                                         message: viewStore.state.model.common.invalidEmailOrPassword)
                                    .padding(.bottom, WhoppahTheme.Size.Padding.small)
                                }
                                
                                //
                                // 📙 Email & password
                                //
                                
                                emailInput
                                    .keyboardType(.emailAddress)
                                
                                passwordInput
                                
                                PushView(destination: ForgotPasswordView(store: store, navigationTitle: $navigationTitle),
                                         destinationId: NavigationView.forgotPassword.identifier) {
                                    Text(viewStore.state.model.login.forgotPasswordTitle)
                                        .font(WhoppahTheme.Font.body)
                                        .foregroundColor(WhoppahTheme.Color.base5)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .simultaneousGesture(TapGesture().onEnded({ _ in
                                    UIApplication.shared.closeKeyboard()
                                }))
                                
                                //
                                // 📙 Other login options
                                //
                                
                                ZStack(alignment: .center) {
                                    Divider()
                                    Text(viewStore.state.model.login.otherOptionsTitle)
                                        .font(WhoppahTheme.Font.subtitle)
                                        .foregroundColor(WhoppahTheme.Color.base5)
                                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                                        .background(Rectangle()
                                                        .fill(WhoppahTheme.Color.base4))
                                }
                                
                                if viewStore.state.model.login.signInOptions.count > 1 {
                                    
                                    //
                                    // 📙 Magic link
                                    //
                                    
                                    let magicLinkOption = viewStore.state.model.login.signInOptions[0]
                                    
                                    PushView(destination: MagicLinkEmailView(store: store,
                                                                             navigationTitle: $navigationTitle),
                                             destinationId: NavigationView.magicLinkEmail.identifier) {
                                        CallToAction(backgroundColor: WhoppahTheme.Color.base4,
                                                     foregroundColor: magicLinkOption.foregroundColor,
                                                     iconName: magicLinkOption.iconName,
                                                     title: magicLinkOption.title,
                                                     showBorder: true) {}
                                                     .disabled(true) // disabled, otherwise the NavigationLink won't work
                                    }
                                    
                                    //
                                    // 📙 Social options
                                    //
                                    
                                    ForEach(1..<viewStore.state.model.login.signInOptions.count, id: \.self) { index in
                                        let signInOption = viewStore.state.model.login.signInOptions[index]
                                        CallToAction(backgroundColor: WhoppahTheme.Color.base4,
                                                     foregroundColor: signInOption.foregroundColor,
                                                     iconName: signInOption.iconName,
                                                     title: signInOption.title,
                                                     showBorder: true)
                                        {
                                            viewStore.send(.outboundAction(.didTapSignInOption(id: signInOption.id)))
                                        }
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: footerSize.height)
                            }
                            .padding(.all, WhoppahTheme.Size.Padding.medium)
                            .scrollWithAdaptiveBounce(.vertical, showsIndicators: true)
                        }

                        //
                        // 📙 Sticky footer button
                        //
                        
                        StickyFooter {
                            CallToAction(backgroundColor: WhoppahTheme.Color.primary1,
                                         foregroundColor: WhoppahTheme.Color.base4,
                                         iconName: nil,
                                         title: viewStore.state.model.login.signInButtonTitle,
                                         showBorder: false,
                                         showingProgress: $mainButtonShouldShowProgress)
                            {
                                emailInput.validate()
                                passwordInput.validate()
                                
                                DispatchQueue.main.async {
                                    guard isEmailValid && isPasswordValid else { return }
                                    viewStore.send(.outboundAction(.didTapSignIn(email: emailValue,
                                                                                   password: passwordValue)))
                                }
                            }
                            .disabled(mainButtonShouldShowProgress)
                        } onSizeChange: { newSize in
                            footerSize = newSize
                        }
                        
                        //
                        // 📙 Navigation title
                        //

                        .onReceive(Just(viewStore.state.model.login.navigationTitle)) { title in
                            navigationTitle = title
                        }

                        .valueChanged(value: viewStore.state.mainButtonState) { newValue in
                            mainButtonShouldShowProgress = newValue == .inProgress
                        }
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: LoginView.Reducer().reducer,
                      environment: .init(localizationClient: LoginView.mockLocalizationClient,
                                         trackingClient: LoginView.mockTrackingClient,
                                         outboundActionClient: LoginView.mockOutboundActionClient,
                                         mainQueue: .main))
        
        LoginView(store: store)
    }
}
