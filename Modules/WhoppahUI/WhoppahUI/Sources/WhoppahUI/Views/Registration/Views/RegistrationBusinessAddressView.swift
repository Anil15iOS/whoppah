//
//  RegistrationBusinessAddressView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 18/01/2022.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct RegistrationBusinessAddressView: View {
    private let store: Store<RegistrationView.ViewState, RegistrationView.Action>?
    private let signUpType: RegistrationView.Model.SignUpType
    
    @State private var mainButtonShouldShowProgress: Bool = false
    
    @Binding private var navigationTitle: String
    
    @State private var isZipCodeValid: Bool = false
    @State private var isStreetValid: Bool = false
    @State private var isCityValid: Bool = false
    
    @State private var zipCodeValue: String = ""
    @State private var streetValue: String = ""
    @State private var additionalInfoValue: String = ""
    @State private var cityValue: String = ""
    @State private var countryValue: String = Locale.current.regionCode?.uppercased() ?? "NL"
    
    @State private var footerSize: CGSize = .zero
    @State private var keyboardHeight: CGFloat = 0
    
    var enableCTA: Bool {
        isZipCodeValid &&
        isStreetValid &&
        isCityValid &&
        !countryValue.isEmpty
    }
    
    public init(store: Store<RegistrationView.ViewState, RegistrationView.Action>?,
                signUpType: RegistrationView.Model.SignUpType,
                navigationTitle: Binding<String>) {
        self.store = store
        self.signUpType = signUpType
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
                        
                        //
                        // 📙 Business address
                        //

                        VStack {
                            VStack(spacing: WhoppahTheme.Size.Padding.extraMedium) {
                                Text(viewStore.state.model.businessAddress.title)
                                    .font(WhoppahTheme.Font.h3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                TextInputWithValidation(placeholderText: viewStore.state.model.businessAddress.zipCodePlaceholder,
                                                        disableAutoCorrection: true,
                                                        validators: [
                                                            EmptyStringValidator(viewStore.state.model.common.missingZipCode)
                                                        ],
                                                        isInputValid: $isZipCodeValid,
                                                        inputValue: $zipCodeValue)
                                
                                TextInputWithValidation(placeholderText: viewStore.state.model.businessAddress.streetPlaceholder,
                                                        disableAutoCorrection: true,
                                                        validators: [
                                                            EmptyStringValidator(viewStore.state.model.common.missingStreet)
                                                        ],
                                                        isInputValid: $isStreetValid,
                                                        inputValue: $streetValue)
                                
                                TextInputWithValidation(placeholderText: viewStore.state.model.businessAddress.additionalInfoPlaceholder,
                                                        disableAutoCorrection: true,
                                                        validators: [],
                                                        isInputValid: .constant(true),
                                                        inputValue: $additionalInfoValue)
                                
                                TextInputWithValidation(placeholderText: viewStore.state.model.businessAddress.cityPlaceholder,
                                                        disableAutoCorrection: true,
                                                        validators: [
                                                            EmptyStringValidator(viewStore.state.model.common.missingCity)
                                                        ],
                                                        isInputValid: $isCityValid,
                                                        inputValue: $cityValue)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                                        .fill(Color.clear)
                                    RoundedRectangle(cornerRadius: WhoppahTheme.Size.TextInput.cornerRadius)
                                        .stroke(WhoppahTheme.Color.base2)
                                    Picker(viewStore.state.model.businessAddress.countryPlaceholder,
                                           selection: $countryValue) {
                                        ForEach(viewStore.state.model.businessAddress.countryList, id: \.self) {
                                            Text($0.name).tag($0.code)
                                        }
                                    }
                                           .reduceSizeIfApplicable()
                                           .accentColor(WhoppahTheme.Color.base1)
                                           .font(WhoppahTheme.Font.body)
                                           .foregroundColor(WhoppahTheme.Color.base1)
                                }
                                .frame(height: WhoppahTheme.Size.TextInput.height)
                            }
                            
                            Spacer()
                                .frame(height: footerSize.height)
                            
                            Spacer()
                                .frame(height: keyboardHeight)

                        }
                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                        .scrollWithAdaptiveBounce(.vertical, showsIndicators: true)
                    } keyboardSizeDidChange: { keyboardHeight in
                        self.keyboardHeight = keyboardHeight
                    }
                    .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth)
                    
                    
                    //
                    // 📙 Sticky footer button
                    //
                    
                    StickyFooter {
                        CallToAction(backgroundColor: enableCTA ? WhoppahTheme.Color.primary1 : WhoppahTheme.Color.base2,
                                     foregroundColor: WhoppahTheme.Color.base4,
                                     iconName: nil,
                                     title: viewStore.state.model.common.nextButtonTitle,
                                     showBorder: false,
                                     showingProgress: $mainButtonShouldShowProgress)
                        {
                            mainButtonShouldShowProgress = true
                            viewStore.send(.outboundAction(.didSubmitBussinessAddress(zipCode: zipCodeValue,
                                                                                        street: streetValue,
                                                                                        city: cityValue,
                                                                                        additionalInfo: additionalInfoValue,
                                                                                        country: countryValue)))
                        }
                        .disabled(!enableCTA)
                    } onSizeChange: { newSize in
                        footerSize = newSize
                    }
                }

                //
                // 📙 Check if an error was raised
                //

                .onReceive(Just(viewStore.state.didRaiseError)) { didRaiseError in
                    guard didRaiseError && mainButtonShouldShowProgress else { return }
                    mainButtonShouldShowProgress = false
                }
                
                //
                // 📙 Navigation title
                //
                
                .onReceive(Just(viewStore.state.model.businessAddress.navigationTitle)) { title in
                    navigationTitle = title
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct RegistrationBusinessAddressView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: RegistrationView.Reducer().reducer,
                      environment: .init(localizationClient: RegistrationView.mockLocalizationClient,
                                         trackingClient: RegistrationView.mockTrackingClient,
                                         outboundActionClient: RegistrationView.mockOutboundActionClient,
                                         mainQueue: .main))

        RegistrationBusinessAddressView(store: store,
                                        signUpType: .business,
                                        navigationTitle: .constant("Title"))
    }
}
