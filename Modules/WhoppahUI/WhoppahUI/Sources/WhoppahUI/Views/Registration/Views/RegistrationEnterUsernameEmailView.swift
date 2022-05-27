//
//  RegistrationEnterUsernameEmailView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 17/01/2022.
//

import SwiftUI
import ComposableArchitecture
import PhoneNumberKit
import Combine

struct RegistrationEnterUsernameEmailView: View {
    typealias NavView = RegistrationView.NavigationView
    
    private let store: Store<RegistrationView.ViewState, RegistrationView.Action>?
    private let signUpType: RegistrationView.Model.SignUpType
    private let phonePlaceholderText: String
    private let phoneNumberKit = PhoneNumberKit()
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @Binding private var navigationTitle: String
    
    @State private var socialSignUpPending = false
    @State private var emailAvailabilityCheckPending = false
    
    @State private var isEmailValid: Bool = false
    @State private var isUserNameValid: Bool = false
    @State private var isPhoneNumberValid: Bool = false
    
    @State private var emailValue: String = ""
    @State private var userNameValue: String = ""
    @State private var phoneNumberValue: String = ""
    
    @State private var mainButtonShouldShowProgress: Bool = false
    @State private var footerSize: CGSize = .zero
    @State private var keyboardHeight: CGFloat = 0
    
    var enableCTA: Bool {
        isEmailValid && isUserNameValid && isPhoneNumberValid
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
    
    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                KeyboardEnabledView(doneButtonTitle: viewStore.state.model.common.doneButtonTitle) {
                    VStack {
                        
                        //
                        // 📙 Social signup options
                        //
                        
                        ForEach(viewStore.state.model.enterUsernamePassword.signUpOptions, id: \.self) { signUpOption in
                            CallToAction(backgroundColor: WhoppahTheme.Color.base4,
                                         foregroundColor: signUpOption.foregroundColor,
                                         iconName: signUpOption.iconName,
                                         title: signUpOption.title,
                                         showBorder: true) {
                                socialSignUpPending = true
                                viewStore.send(.outboundAction(.didTapSignUpOption(id: signUpOption.id)))
                                viewStore.send(.trackingAction(.socialSignUpStart))
                            }
                        }
                        
                        //
                        // 📙 Email signup option
                        //
                        
                        ZStack(alignment: .center) {
                            Divider()
                            Text(viewStore.state.model.enterUsernamePassword.otherOptionsTitle)
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base5)
                                .padding(.all, WhoppahTheme.Size.Padding.medium)
                                .background(Rectangle().fill(WhoppahTheme.Color.base4))
                        }
                        
                        TextInputWithValidation(placeholderText: viewStore.state.model.enterUsernamePassword.usernamePlaceholder,
                                                disableAutoCorrection: true,
                                                validators: [
                                                    EmptyStringValidator(viewStore.state.model.common.missingUsername),
                                                    ForbiddenKeywordValidator(viewStore.state.model.enterUsernamePassword.whoppahIsNotAllowed)
                                                ],
                                                isInputValid: $isUserNameValid,
                                                inputValue: $userNameValue)
                        
                        TextInputWithValidation(placeholderText: viewStore.state.model.enterUsernamePassword.emailPlaceholder,
                                                disableAutoCorrection: true,
                                                disableAutoCapitalization: true,
                                                validators: [
                                                    EmptyStringValidator(viewStore.state.model.common.invalidEmail),
                                                    EmailValidator(viewStore.state.model.common.invalidEmail)
                                                ],
                                                isInputValid: $isEmailValid,
                                                inputValue: $emailValue)
                            .keyboardType(.emailAddress)
                        
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
                        
                        //
                        // 📙 Warning message
                        //
                        
                        if viewStore.state.registrationFailedMessageIsVisible {
                            InlineWarningMessage(icon: .information,
                                                 message: viewStore.state.model.enterUsernamePassword.emailAlreadyInUse,
                                                 ctaText: viewStore.state.model.enterUsernamePassword.logInNow,
                                                 backgroundColor: WhoppahTheme.Color.support3,
                                                 foregroundColor: WhoppahTheme.Color.alert3) {
                                viewStore.send(.outboundAction(.didTapSignInNowButton))
                            }
                        }
                        
                        Spacer()
                            .frame(height: footerSize.height)
                        
                        Spacer()
                            .frame(height: keyboardHeight)
                    }
                    .padding(.all, WhoppahTheme.Size.Padding.medium)
                    .scrollWithAdaptiveBounce(.vertical, showsIndicators: true)
                    
                    
                    //
                    // 📙 Sticky footer button
                    //
                    
                    StickyFooter {
                        CallToAction(backgroundColor: enableCTA ? WhoppahTheme.Color.primary1 : WhoppahTheme.Color.base2,
                                     foregroundColor: WhoppahTheme.Color.base4,
                                     iconName: nil,
                                     title: viewStore.state.model.common.nextButtonTitle,
                                     showBorder: false,
                                     showingProgress: $mainButtonShouldShowProgress) {
                                        socialSignUpPending = false
                                        emailAvailabilityCheckPending = true
                            
                                        viewStore.send(.outboundAction(.didSubmitUsername(userName: userNameValue,
                                                                                          email: emailValue,
                                                                                          phoneNumber: phoneNumberValue)))
                                     }
                                     .disabled(!enableCTA)
                    } onSizeChange: { newSize in
                        footerSize = newSize
                    }
                } keyboardSizeDidChange: { keyboardHeight in
                    self.keyboardHeight = keyboardHeight
                }
                
                //
                // 📙 Checks for changes in social signup
                //
                
                .onReceive(Just(viewStore.state.isUserLoggedIn)) { isUserLoggedIn in
                    guard isUserLoggedIn && socialSignUpPending else { return }
                    
                    socialSignUpPending = false
                    
                    if viewStore.state.signUpType == .individual {
                        let view = RegistrationEnterPhoneNumberView(store: store,
                                                                    signUpType: signUpType,
                                                                    navigationTitle: $navigationTitle)
                        navigationStack.push(view, withId: NavView.enterPhoneNumber.identifier)
                    } else {
                        let view = RegistrationBusinessInfoView(store: store,
                                                                signUpType: .business,
                                                                showPhoneNumber: true,
                                                                navigationTitle: $navigationTitle)
                        navigationStack.push(view, withId: NavView.businessInfo.identifier)
                    }
                }
                
                //
                // 📙 Checks if an error was raised and shows a message accordingly
                //
                
                .onReceive(Just(viewStore.state.didRaiseError)) { didRaiseError in
                    guard didRaiseError && mainButtonShouldShowProgress else { return }
                    mainButtonShouldShowProgress = false
                }

                //
                // 📙 Checks if the email address is available
                //

                .onReceive(Just(viewStore.state.emailAddressIsAvailable), perform: { emailAddressIsAvailable in
                    guard emailAvailabilityCheckPending && emailAddressIsAvailable else { return }

                    let view = RegistrationChoosePasswordView(store: store,
                                                              signUpType: signUpType,
                                                              navigationTitle: $navigationTitle)
                    
                    navigationStack.push(view, withId: NavView.choosePassword.identifier)
                    
                    emailAvailabilityCheckPending = false
                })
                
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

struct RegistrationEnterUsernamePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: RegistrationView.Reducer().reducer,
                      environment: .init(localizationClient: RegistrationView.mockLocalizationClient,
                                         trackingClient: RegistrationView.mockTrackingClient,
                                         outboundActionClient: RegistrationView.mockOutboundActionClient,
                                         mainQueue: .main))
        
        RegistrationEnterUsernameEmailView(store: store,
                                           signUpType: .individual,
                                           navigationTitle: .constant("Title"))
    }
}
