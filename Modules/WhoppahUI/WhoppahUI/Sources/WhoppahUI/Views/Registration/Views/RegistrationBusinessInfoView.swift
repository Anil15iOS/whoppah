//
//  RegistrationBusinessInfoView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 18/01/2022.
//

import SwiftUI
import ComposableArchitecture
import Combine
import PhoneNumberKit

struct RegistrationBusinessInfoView: View {
    typealias NavView = RegistrationView.NavigationView
    
    private let store: Store<RegistrationView.ViewState, RegistrationView.Action>?
    private let signUpType: RegistrationView.Model.SignUpType
    private let showPhoneNumber: Bool
    private let phonePlaceholderText: String
    private let phoneNumberKit = PhoneNumberKit()
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @Binding private var navigationTitle: String
    
    @State private var mainButtonShouldShowProgress: Bool = false
    
    @State private var isBusinessNameValid: Bool = false
    @State private var isFirstNameValid: Bool = false
    @State private var isLastNameValid: Bool = false
    @State private var isPhoneNumberValid: Bool = false
    
    @State private var businessNameValue: String = ""
    @State private var firstNameValue: String = ""
    @State private var lastNameValue: String = ""
    @State private var phoneNumberValue: String = ""
    
    var enableCTA: Bool {
        isBusinessNameValid && isFirstNameValid && isLastNameValid && (showPhoneNumber ? isPhoneNumberValid : true)
    }
    
    public init(store: Store<RegistrationView.ViewState, RegistrationView.Action>?,
                signUpType: RegistrationView.Model.SignUpType,
                showPhoneNumber: Bool = false,
                navigationTitle: Binding<String>) {
        self.store = store
        self.signUpType = signUpType
        self.showPhoneNumber = showPhoneNumber
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
                        VStack {
                            VStack(spacing: WhoppahTheme.Size.Padding.extraMedium) {
                                
                                Text(viewStore.state.model.businessInfo.title)
                                    .font(WhoppahTheme.Font.h3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                //
                                // 📙 Business info
                                //
                                
                                TextInputWithValidation(placeholderText: viewStore.state.model.businessInfo.businessNamePlaceholder,
                                                        disableAutoCorrection: true,
                                                        validators: [
                                                            EmptyStringValidator(viewStore.state.model.common.missingBusinessName)
                                                        ],
                                                        isInputValid: $isBusinessNameValid,
                                                        inputValue: $businessNameValue)
                                
                                if showPhoneNumber {
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
                                
                                //
                                // 📙 Contact person
                                //
                                
                                Text(viewStore.state.model.businessInfo.contactPersonTitle)
                                    .font(WhoppahTheme.Font.h3)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                TextInputWithValidation(placeholderText: viewStore.state.model.businessInfo.firstNamePlaceholder,
                                                        disableAutoCorrection: true,
                                                        validators: [
                                                            EmptyStringValidator(viewStore.state.model.common.missingFirstName)
                                                        ],
                                                        isInputValid: $isFirstNameValid,
                                                        inputValue: $firstNameValue)
                                
                                TextInputWithValidation(placeholderText: viewStore.state.model.businessInfo.lastNamePlaceholder,
                                                        disableAutoCorrection: true,
                                                        validators: [
                                                            EmptyStringValidator(viewStore.state.model.common.missingLastName)
                                                        ],
                                                        isInputValid: $isLastNameValid,
                                                        inputValue: $lastNameValue)
                            }
                            
                            Spacer()
                        }
                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                        .scrollWithAdaptiveBounce(.vertical, showsIndicators: true)
                    }
                    .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth)
                    
                    //
                    // 📙 Sticky footer button
                    //
                    
                    HStack {
                        PushView(destination: RegistrationBusinessAddressView(store: store,
                                                                              signUpType: signUpType,
                                                                              navigationTitle: $navigationTitle),
                                 destinationId: NavView.businessAddress.identifier)
                        {
                            CallToAction(backgroundColor: enableCTA ? WhoppahTheme.Color.primary1 : WhoppahTheme.Color.base2,
                                         foregroundColor: WhoppahTheme.Color.base4,
                                         iconName: nil,
                                         title: viewStore.state.model.common.nextButtonTitle,
                                         showBorder: false,
                                         showingProgress: $mainButtonShouldShowProgress)
                            {}
                            .disabled(true)
                        }
                        .disabled(!enableCTA)
                        .simultaneousGesture(TapGesture().onEnded {
                            viewStore.send(.outboundAction(.didSubmitBusinessInfo(businessName: businessNameValue,
                                                                                  firstName: firstNameValue,
                                                                                  lastName: lastNameValue,
                                                                                  phoneNumber: showPhoneNumber ? phoneNumberValue : nil)))
                        })
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
                
                .onReceive(Just(viewStore.state.model.businessInfo.navigationTitle)) { title in
                    navigationTitle = title
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct RegistrationBusinessInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: RegistrationView.Reducer().reducer,
                      environment: .init(localizationClient: RegistrationView.mockLocalizationClient,
                                         trackingClient: RegistrationView.mockTrackingClient,
                                         outboundActionClient: RegistrationView.mockOutboundActionClient,
                                         mainQueue: .main))
        
        RegistrationBusinessInfoView(store: store,
                                     signUpType: .business,
                                     navigationTitle: .constant("Title"))
    }
}
