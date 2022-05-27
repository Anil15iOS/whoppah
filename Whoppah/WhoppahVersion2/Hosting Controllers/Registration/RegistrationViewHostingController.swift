//
//  RegistrationViewHostingController.swift
//  Whoppah
//
//  Created by Dennis Ippel on 20/01/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import UIKit
import Foundation
import WhoppahUI
import SwiftUI
import ComposableArchitecture
import Resolver
import WhoppahCoreNext
import WhoppahModel
import Combine
import WhoppahRepository
import WhoppahCore
import FBSDKCoreKit

class RegistrationViewHostingController: WhoppahUIHostingController<RegistrationView,
                                         RegistrationView.Model,
                                         RegistrationView.ViewState,
                                         RegistrationView.Action,
                                         RegistrationView.OutboundAction,
                                         RegistrationView.TrackingAction> {
    
    @LazyInjected private var eventTracking: EventTrackingService
    @LazyInjected private var merchantRepository: MerchantRepository
    @LazyInjected private var userRepository: UserRepository
    @LazyInjected private var authenticationStore: AuthenticationStoring
    @LazyInjected private var userProvider: UserProviding
    @LazyInjected private var crashReporter: CrashReporter
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    private var registrationInput = RegistrationInput()
    private weak var presentingVC: UIViewController?
    
    init(presentingViewController: UIViewController) {
        self.presentingVC = presentingViewController
        super.init()
    }
    
    ///
    /// 📄 Provides the root WhoppahUI view.
    ///
    /// - Returns: the root view
    ///
    override func provideContent() -> RegistrationView {
        let reducer = RegistrationView.Reducer().reducer

        let environment = RegistrationView.Environment(localizationClient: localizationClient,
                                                       trackingClient: trackingClient,
                                                       outboundActionClient: outboundActionClient,
                                                       mainQueue: .main)

        let store: Store<RegistrationView.ViewState, RegistrationView.Action> =
            .init(initialState: .initial,
                  reducer: reducer,
                  environment: environment)

        return .init(store: store)
    }
    
    ///
    /// ⚡️Handles outbound actions
    ///
    /// - Parameter outboundAction: An outbound action
    /// - Returns: An effect
    ///
    override func handle(outboundAction: RegistrationView.OutboundAction) -> Effect<RegistrationView.Action, Never> {
        switch outboundAction {
        case .didChooseSignUpType(let signUpType):
            self.registrationInput.merchantType = signUpType == .individual ? .individual : .business
        case .didSubmitUsername(let userName, let email, let phoneNumber):
            self.registrationInput.email = email
            self.registrationInput.phone = phoneNumber
            self.registrationInput.profileName = userName
            return self.checkIfEmailExists(email: email)
        case .didSubmitPassword(let password):
            self.registrationInput.password = password
            return self.signUp(registrationInput: self.registrationInput)
        case .didSubmitBusinessInfo(let businessName, let firstName, let lastName, let phoneNumber):
            self.registrationInput.businessInfo.name = businessName
            self.registrationInput.businessInfo.contactFirstName = firstName
            self.registrationInput.businessInfo.contactLastName = lastName

            if let phoneNumber = phoneNumber {
                self.registrationInput.phone = phoneNumber
            }
        case .didSubmitBussinessAddress(let zipCode,
                                        let street,
                                        let city,
                                        let additionalInfo,
                                        let country):
            self.registrationInput.businessInfo.zipCode = zipCode
            self.registrationInput.businessInfo.street = street
            self.registrationInput.businessInfo.city = city
            self.registrationInput.businessInfo.additionalInfo = additionalInfo
            self.registrationInput.businessInfo.country = country
            return self.updateBusinessMerchant(registrationInput: self.registrationInput)
        case .didSubmitPhoneNumber(let phoneNumber):
            self.registrationInput.phone = phoneNumber
            return self.updatePhoneNumber(phoneNumber)
        case .registrationDidSucceed:
            return self.signIn(registrationInput: self.registrationInput)
        case .didTapSignInNowButton:
            guard let presentingVC = presentingVC else { return .none }

            self.openLoginScreen(parentViewController: presentingVC)
        case .openWelcomeView:
            guard let presentingVC = presentingVC else { return .none }
            
            self.openWelcomeView(parentViewController: presentingVC)
        case .didTapSignUpOption(let signUpId):
            self.registrationInput.socialSignUpId = signUpId
            return self.handleSocialSignup(signUpId,
                                           registrationInput: self.registrationInput)
        case .didRaiseError(let error):
            if let error = error as? SocialSignupError {
                switch error {
                case .emailAlreadyExists(let email):
                    guard let presentingVC = presentingVC else { return .none }
                    
                    self.openWelcomeView(parentViewController: presentingVC,
                                         isNewUser: false,
                                         existingEmailAddress: email)
                default:
                    self.crashReporter.log(event: error.localizedDescription, withInfo: nil)
                    self.handleError(error)
                }
            } else {
                self.crashReporter.log(event: error.localizedDescription, withInfo: nil)
                self.handleError(error)
            }
        case .didTapCloseButton:
            self.dismiss(animated: true, completion: nil)
        case .didTapWhoppahTermsOfUse:
            self.navigateTo("https://www.whoppah.com/terms.pdf")
        case .didTapWhoppahPrivacyPolicy:
            self.navigateTo("https://www.whoppah.com/privacy-policy.pdf")
        case .didTapPaymentTermsOfUse:
            self.navigateTo("https://stripe.com/legal")
        default:
            break
        }
        return .none.eraseToEffect()
    }
    
    ///
    /// 🦶 Handles tracking actions
    ///
    /// - Parameter action: A tracking action
    /// - Returns: An effect
    ///
    override func track(action: RegistrationView.TrackingAction) -> Effect<Void, Never> {
        switch action {
        case .signUpSuccess:
            eventTracking.trackSignUpSuccess()

            if registrationInput.socialSignUpId == .facebook {
                AppEvents.shared.logEvent(AppEvents.Name(rawValue: "FBSDKAppEventNameCompletedRegistration"))
            }
        case .signUpStart:
            eventTracking.trackSignUpStart()
        case .socialSignUpStart:
            if registrationInput.socialSignUpId == .facebook {
                AppEvents.shared.logEvent(AppEvents.Name(rawValue: "FBSDKAppEventNameStartedRegistration"))
            }
        }
        return .none
    }
    
    ///
    /// 🧱 Fetches the localized data model
    ///
    /// - Returns: The localized data model
    ///
    override func fetchLocalizedModel() -> Effect<RegistrationView.Model, WhoppahUI.LocalizationClientError> {
        guard let localizedModel = LocalizationService().localise(RegistrationView.Model.self) else {
            return .none
        }
        return Effect(value: localizedModel)
            .setFailureType(to: WhoppahUI.LocalizationClientError.self)
            .eraseToEffect()
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func navigateTo(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorDialog()
        }
    }
    
    private func openLoginScreen(parentViewController: UIViewController) {
        dismiss(animated: true) {
            let hostingController = LoginViewHostingController()
            parentViewController.present(hostingController, animated: true, completion: nil)
        }
    }
    
    private func openWelcomeView(parentViewController: UIViewController,
                                 isNewUser: Bool = true,
                                 existingEmailAddress: String = "") {
        dismiss(animated: true) {
            let welcome = WelcomeDialogHostingController(presentingViewController: parentViewController,
                                                         isNewUser: isNewUser,
                                                         existingEmailAddress: existingEmailAddress)
            welcome.isModalInPresentation = true
            welcome.modalPresentationStyle = .overFullScreen
            welcome.view.backgroundColor = .clear
            parentViewController.present(welcome, animated: true, completion: nil)
        }
    }
    
    private func checkIfEmailExists(email: String) -> Effect<RegistrationView.Action, Never> {
        return self.userRepository
            .checkIfEmailExists(email: email)
            .map { result -> Bool in
                switch result {
                case .unavailable, .banned: return false
                case .available: return true
                }
            }
            .eraseToEffect()
            .receive(on: RunLoop.main)
            .catchToEffect(RegistrationView.Action.emailAvailabilityResponse)
    }
    
    private func signUp(registrationInput: RegistrationInput) -> Effect<RegistrationView.Action, Never> {
        return self.authenticationStore
            .signUpAuthenticator(ofType: EmailPasswordAuthenticator.self)!
            .signUp(email: self.registrationInput.email,
                       password: self.registrationInput.password,
                       profileName: self.registrationInput.profileName,
                       givenName: self.registrationInput.givenName,
                       familyName: self.registrationInput.familyName,
                       phone: self.registrationInput.phone,
                       address: self.registrationInput.address,
                       merchantType: self.registrationInput.merchantType,
                       merchantName: self.registrationInput.merchantName)
            .eraseToEffect()
            .catchToEffect(RegistrationView.Action.registrationResponse)
    }
    
    private func signIn(registrationInput: RegistrationInput) -> Effect<RegistrationView.Action, Never> {
        return self.authenticationStore
            .signInAuthenticator(ofType: EmailPasswordAuthenticator.self)!
            .signIn(email: registrationInput.email,
                    password: registrationInput.password)
            .map({ accessToken in
                return accessToken.token
            })
            .eraseToEffect()
            .receive(on: RunLoop.main)
            .catchToEffect(RegistrationView.Action.signInResponse)
    }
    
    private func updateBusinessMerchant(registrationInput: RegistrationInput) -> Effect<RegistrationView.Action, Never> {
        guard let currentUser = userProvider.currentUser,
            let mainMerchant = currentUser.mainMerchant
        else {
            return Empty<RegistrationView.Action, Never>()
                .eraseToAnyPublisher()
                .eraseToEffect()
        }
        
        let merchantInput = MerchantInput(
            type: .business,
            name: registrationInput.profileName,
            phone: registrationInput.phone.isEmpty ? mainMerchant.phone : registrationInput.phone,
            email: registrationInput.email.isEmpty ? currentUser.email : registrationInput.email,
            businessName: registrationInput.businessInfo.name,
            id: mainMerchant.id)

        let memberInput = MemberInput(
            email: registrationInput.email.isEmpty ? currentUser.email : registrationInput.email,
            givenName: registrationInput.businessInfo.contactFirstName,
            familyName: registrationInput.businessInfo.contactLastName)
        
        let addressInput = AddressInput(
            merchantId: mainMerchant.id,
            line1: registrationInput.businessInfo.street,
            line2: registrationInput.businessInfo.additionalInfo,
            postalCode: registrationInput.businessInfo.zipCode,
            city: registrationInput.businessInfo.city,
            country: registrationInput.businessInfo.country)
        
        return Publishers.Merge3(
            merchantRepository.updateMerchant(merchantInput),
            userProvider.update(id: currentUser.id,
                                member: memberInput),
            merchantRepository.addAddress(addressInput, id: mainMerchant.id)
                .map({ address -> UUID in address.id })
            )
            .eraseToAnyPublisher()
            .eraseToEffect()
            .receive(on: RunLoop.main)
            .catchToEffect(RegistrationView.Action.updateMerchantResponse)
    }
    
    private func updatePhoneNumber(_ phoneNumber: String) -> Effect<RegistrationView.Action, Never> {
        guard let currentUser = userProvider.currentUser,
            let mainMerchant = currentUser.mainMerchant
        else {
            return Empty<RegistrationView.Action, Never>()
                .eraseToAnyPublisher()
                .eraseToEffect()
        }

        let merchantInput = MerchantInput(
            type: registrationInput.merchantType == .business ? .business : .individual,
            name: mainMerchant.name,
            phone: phoneNumber,
            email: currentUser.email,
            id: mainMerchant.id)
        
        return merchantRepository.updateMerchant(merchantInput)
            .eraseToEffect()
            .receive(on: RunLoop.main)
            .catchToEffect(RegistrationView.Action.updatePhoneNumberResponse)
    }
    
    private func handleSocialSignup(_ socialSignupId: RegistrationView.Model.SignUpOptionId,
                                    registrationInput: RegistrationInput) -> Effect<RegistrationView.Action, Never> {
        var authenticator: SocialAuthenticating?
        
        switch socialSignupId {
        case .apple:
            authenticator = authenticationStore.signUpAuthenticator(ofType: AppleAuthenticator.self)
        case .facebook:
            authenticator = authenticationStore.signUpAuthenticator(ofType: FacebookAuthenticator.self)
        case .google:
            authenticator = authenticationStore.signUpAuthenticator(ofType: GoogleAuthenticator.self)?.setPresentingViewController(self)
        }
        
        guard let authenticator = authenticator else {
            return Empty<RegistrationView.Action, Never>()
                .eraseToAnyPublisher()
                .eraseToEffect()
        }
        
        let merchantType: MerchantType = registrationInput.merchantType == .business ? .business : .individual
        
        return authenticator.authorize(authMode: .register,
                                       merchantType: merchantType)
            .map({ token in return token.token })
            .eraseToEffect()
            .receive(on: RunLoop.main)
            .catchToEffect(RegistrationView.Action.socialRegistrationResponse)
    }
}
