//
//  RegistrationChoosePasswordView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 18/01/2022.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct RegistrationChoosePasswordView: View {
    typealias NavView = RegistrationView.NavigationView
    
    private let store: Store<RegistrationView.ViewState, RegistrationView.Action>?
    private let signUpType: RegistrationView.Model.SignUpType
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @Binding private var navigationTitle: String
    
    @State private var isPasswordValid: Bool = false
    @State private var isRepeatPasswordValid: Bool = false
    @State private var isAgreeToWhoppahTermsSelected: Bool = false
    @State private var isAgreeToPaymentTermsSelected: Bool = false
    
    @State private var passwordValue: String = ""
    @State private var repeatPasswordValue: String = ""
    
    @State private var mainButtonShouldShowProgress: Bool = false
    
    @ObservedObject private var passwordRequirementsObservable: PasswordRequirementsObservable
    
    private var whoppahTerms: [StringWithOptionalAction<RegistrationView.OutboundAction>]?
    private var paymentTerms: [StringWithOptionalAction<RegistrationView.OutboundAction>]?
    
    var enableCTA: Bool {
        isPasswordValid &&
        isRepeatPasswordValid &&
        isAgreeToWhoppahTermsSelected &&
        isAgreeToPaymentTermsSelected
    }
    
    public init(store: Store<RegistrationView.ViewState, RegistrationView.Action>?,
                signUpType: RegistrationView.Model.SignUpType,
                navigationTitle: Binding<String>) {
        self.store = store
        self.signUpType = signUpType
        self._navigationTitle = navigationTitle
        self.passwordRequirementsObservable = PasswordRequirementsObservable()

        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
            
            let whoppahStrings = viewStore.model.choosePassword.agreeToWhoppahTerms
            let paymentStrings = viewStore.model.choosePassword.agreeToPaymentTerms
            
            // TODO: Review once we have a proper CMS
            guard whoppahStrings.count == 5,
                  paymentStrings.count == 3
            else { assertionFailure(); return }
            
            whoppahTerms = [
                StringWithOptionalAction(text: "\(whoppahStrings[0]) ", action: nil),
                StringWithOptionalAction(text: "\(whoppahStrings[1]) ", action: .didTapWhoppahTermsOfUse),
                StringWithOptionalAction(text: "\(whoppahStrings[2]) ", action: nil),
                StringWithOptionalAction(text: "\(whoppahStrings[3]) ", action: .didTapWhoppahPrivacyPolicy),
                StringWithOptionalAction(text: whoppahStrings[4], action: nil)
            ]
            
            paymentTerms = [
                StringWithOptionalAction(text: "\(paymentStrings[0]) ", action: nil),
                StringWithOptionalAction(text: "\(paymentStrings[1]) ", action: .didTapPaymentTermsOfUse),
                StringWithOptionalAction(text: "\(paymentStrings[2])", action: nil)
            ]
        }
    }
    
    var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                ZStack {
                    KeyboardEnabledView(doneButtonTitle: viewStore.state.model.common.doneButtonTitle) {
                        
                        //
                        // 📙 Password input
                        //
                        
                        VStack {
                            VStack(spacing: WhoppahTheme.Size.Padding.medium) {
                                Text(viewStore.state.model.choosePassword.title)
                                    .font(WhoppahTheme.Font.h3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                TextInputWithValidation(placeholderText: "",
                                                        isSecureField: true,
                                                        disableAutoCorrection: true,
                                                        validateOnChange: true,
                                                        validators: [
                                                            PasswordValidator(passwordRequirementsObservable)
                                                        ],
                                                        isInputValid: $isPasswordValid,
                                                        inputValue: $passwordValue)
                                
                                RegistrationPasswordRequirements(
                                    passwordRequirementsObservable: passwordRequirementsObservable,
                                    requirements: viewStore.state.model.choosePassword.requirements)
                                
                                Text(viewStore.state.model.choosePassword.repeatPasswordTitle)
                                    .font(WhoppahTheme.Font.h3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                TextInputWithValidation(placeholderText: "",
                                                        isSecureField: true,
                                                        disableAutoCorrection: true,
                                                        validateOnChange: true,
                                                        validators: [
                                                            RepeatPasswordValidator(viewStore.state.model.common.invalidPasswordRepeat,
                                                                                    password: passwordValue)
                                                        ],
                                                        isInputValid: $isRepeatPasswordValid,
                                                        inputValue: $repeatPasswordValue)
                                
                                VStack {
                                    if let whoppahTerms = whoppahTerms {
                                        Checkbox(isSelected: $isAgreeToWhoppahTermsSelected) {
                                            StringsWithOptionalActionsFlowLayout(whoppahTerms) { action in
                                                viewStore.send(.outboundAction(action))
                                            }
                                            .padding(.top, WhoppahTheme.Size.Padding.tiniest)
                                        }
                                    }
                                    
                                    if let paymentTerms = paymentTerms {
                                        Checkbox(isSelected: $isAgreeToPaymentTermsSelected) {
                                            StringsWithOptionalActionsFlowLayout(paymentTerms) { action in
                                                viewStore.send(.outboundAction(action))
                                            }
                                            .padding(.top, WhoppahTheme.Size.Padding.tiniest)
                                        }
                                    }
                                }
                            }
                            .padding(.all, WhoppahTheme.Size.Padding.medium)
                        }
                        .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth)
                        .scrollWithAdaptiveBounce(.vertical, showsIndicators: true)
                        
                        //
                        // 📙 Sticky footer button
                        //
                        
                        HStack {
                            if signUpType == .individual {
                                
                                //
                                // 📙 Individual
                                //
                                
                                CallToAction(backgroundColor: enableCTA ? WhoppahTheme.Color.primary1 : WhoppahTheme.Color.base2,
                                             foregroundColor: WhoppahTheme.Color.base4,
                                             iconName: nil,
                                             title: viewStore.state.model.common.nextButtonTitle,
                                             showBorder: false,
                                             showingProgress: $mainButtonShouldShowProgress)
                                {
                                    mainButtonShouldShowProgress = true
                                    viewStore.send(.outboundAction(.didSubmitPassword(password: passwordValue)))
                                }
                                .disabled(!enableCTA)
                            } else {
                                
                                //
                                // 📙 Business
                                //
                                
                                PushView(destination: RegistrationBusinessInfoView(store: store,
                                                                                   signUpType: signUpType,
                                                                                   navigationTitle: $navigationTitle),
                                         destinationId: NavView.businessInfo.identifier)
                                {
                                    CallToAction(backgroundColor: enableCTA ? WhoppahTheme.Color.primary1 : WhoppahTheme.Color.base2,
                                                 foregroundColor: WhoppahTheme.Color.base4,
                                                 iconName: nil,
                                                 title: viewStore.state.model.common.nextButtonTitle,
                                                 showBorder: false,
                                                 showingProgress: $mainButtonShouldShowProgress) {}
                                    .disabled(true)
                                }
                                .disabled(!enableCTA)
                                .simultaneousGesture(TapGesture().onEnded {
                                    guard enableCTA else { return }
                                    mainButtonShouldShowProgress = true
                                    viewStore.send(.outboundAction(.didSubmitPassword(password: passwordValue)))
                                })
                            }
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
                
                //
                // 📙 Show a warning message if an error occurred
                //

                .valueChanged(value: viewStore.state.registrationFailedMessageIsVisible, onChange: { isVisible in
                    guard isVisible else { return }
                    
                    if viewStore.state.signUpType == .individual {
                        navigationStack.pop(to: .view(withId: NavView.enterUsernameIndividual.identifier))
                    } else {
                        navigationStack.pop(to: .view(withId: NavView.enterUsernameBusiness.identifier))
                    }
                })
                
                //
                // 📙 Listen for social signup auth changes
                //

                .valueChanged(value: viewStore.state.isUserLoggedIn) { isUserLoggedIn in
                    guard isUserLoggedIn && viewStore.state.signUpType == .business else { return }
                    
                    let view = RegistrationBusinessInfoView(store: store,
                                                            signUpType: signUpType,
                                                            navigationTitle: $navigationTitle)
                    navigationStack.push(view, withId: NavView.businessInfo.identifier)
                }
                
                //
                // 📙 Stop showing the progress animation if an error occurred
                //

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

struct RegistrationChoosePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: RegistrationView.Reducer().reducer,
                      environment: .init(localizationClient: RegistrationView.mockLocalizationClient,
                                         trackingClient: RegistrationView.mockTrackingClient,
                                         outboundActionClient: RegistrationView.mockOutboundActionClient,
                                         mainQueue: .main))

        RegistrationChoosePasswordView(store: store,
                                       signUpType: .individual,
                                       navigationTitle: .constant("Title"))
    }
}
