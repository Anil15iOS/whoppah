//
//  RegistrationEnterPhoneNumberView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 19/01/2022.
//

import SwiftUI
import ComposableArchitecture
import PhoneNumberKit
import Combine

struct RegistrationEnterPhoneNumberView: View {
    private let store: Store<RegistrationView.ViewState, RegistrationView.Action>?
    private let signUpType: RegistrationView.Model.SignUpType
    private let phonePlaceholderText: String
    private let phoneNumberKit = PhoneNumberKit()
    
    @State private var isPhoneNumberValid: Bool = false
    @State private var phoneNumberValue: String = ""
    @State private var mainButtonShouldShowProgress: Bool = false
    
    @Binding private var navigationTitle: String
    
    var enableCTA: Bool {
        isPhoneNumberValid
    }

    public init(store: Store<RegistrationView.ViewState, RegistrationView.Action>?,
                signUpType: RegistrationView.Model.SignUpType,
                navigationTitle: Binding<String>) {
        self.store = store
        self.signUpType = signUpType
        self._navigationTitle = navigationTitle
        self.phonePlaceholderText = "+\(phoneNumberKit.countryCode(for: Locale.current.regionCode ?? "NL") ?? 31)"
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
                        
                        //
                        // 📙 Phone number
                        //

                        VStack {
                            VStack {
                                Text(viewStore.state.model.enterUsernamePassword.fillInPhoneNumberTitle)
                                    .font(WhoppahTheme.Font.h3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                TextInputWithValidation(placeholderText: phonePlaceholderText,
                                                        disableAutoCorrection: true,
                                                        validators: [
                                                            EmptyStringValidator(viewStore.state.model.common.invalidPhoneNumber),
                                                            PhoneNumberValidator(viewStore.state.model.common.invalidPhoneNumber)
                                                        ],
                                                        formatters: [ PhoneNumberFormatter() ],
                                                        isInputValid: $isPhoneNumberValid,
                                                        inputValue: $phoneNumberValue)
                                    .keyboardType(.phonePad)
                            }
                            .padding(.all, WhoppahTheme.Size.Padding.medium)
                        }
                        .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth)
                        .scrollWithAdaptiveBounce(.vertical, showsIndicators: true)
                        
                        //
                        // 📙 Sticky footer button
                        //
                        
                        HStack {
                            CallToAction(backgroundColor: enableCTA ? WhoppahTheme.Color.primary1 : WhoppahTheme.Color.base2,
                                         foregroundColor: WhoppahTheme.Color.base4,
                                         iconName: nil,
                                         title: viewStore.state.model.common.nextButtonTitle,
                                         showBorder: false,
                                         showingProgress: $mainButtonShouldShowProgress)
                            {
                                mainButtonShouldShowProgress = true
                                viewStore.send(.outboundAction(.didSubmitPhoneNumber(phoneNumber: phoneNumberValue)))
                            }
                            .disabled(!enableCTA)
                        }
                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                        .padding(.bottom, WhoppahTheme.Size.Padding.large)
                        .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth,
                               maxHeight: .infinity,
                               alignment: .bottom)
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    
                    Spacer()
                }

                .onReceive(Just(viewStore.state.didRaiseError)) { didRaiseError in
                    guard didRaiseError && mainButtonShouldShowProgress else { return }
                    mainButtonShouldShowProgress = false
                }
                
                //
                // 📙 Navigation title
                //

                .onReceive(Just(viewStore.state.model.enterUsernamePassword.navigationTitle)) { title in
                    navigationTitle = title
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct RegistrationEnterPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: RegistrationView.Reducer().reducer,
                      environment: .init(localizationClient: RegistrationView.mockLocalizationClient,
                                         trackingClient: RegistrationView.mockTrackingClient,
                                         outboundActionClient: RegistrationView.mockOutboundActionClient,
                                         mainQueue: .main))
        
        RegistrationEnterPhoneNumberView(store: store,
                                         signUpType: .individual,
                                         navigationTitle: .constant("Title"))
    }
}
