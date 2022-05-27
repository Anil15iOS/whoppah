//
//  MagicLinkEnterCodeView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 04/01/2022.
//

import SwiftUI
import ComposableArchitecture
import Combine

public struct MagicLinkEnterCodeView: View {
    private let store: Store<LoginView.ViewState, LoginView.Action>?
    
    @State private var isCodeValid: Bool = false
    @State private var magicCodeValue: String = ""
    @State private var mainButtonShouldShowProgress: Bool = false
    @State private var footerSize: CGSize = .zero
    
    @Binding private var navigationTitle: String
    @Binding private var emailValue: String
    
    private var descriptionText: [StringWithOptionalAction<LoginView.OutboundAction>]?
    
    public init(store: Store<LoginView.ViewState, LoginView.Action>?,
                navigationTitle: Binding<String>,
                emailValue: Binding<String>) {
        self.store = store
        self._navigationTitle = navigationTitle
        self._emailValue = emailValue
        
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
            
            descriptionText = updateDescriptionText(viewStore: viewStore)
        }
    }
    
    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                ZStack {
                    KeyboardEnabledView(doneButtonTitle: viewStore.state.model.common.doneButtonTitle) {
                        VStack(alignment: .leading,
                               spacing: WhoppahTheme.Size.Padding.medium) {
                            
                            Text(viewStore.state.model.magicLink.magicLinkTitle)
                                .font(WhoppahTheme.Font.h3)

                            if let descriptionText = descriptionText {
                                StringsWithOptionalActionsFlowLayout(descriptionText,
                                                                     font: WhoppahTheme.Font.paragraph) { action in
                                    viewStore.send(.outboundAction(action))
                                }
                            }

                            if viewStore.state.magicLinkInvalidMessageIsVisible {
                                InlineWarningMessage(icon: .alert,
                                                     message: viewStore.state.model.magicLink.expiredCode)
                            } else {
                                Spacer()
                            }
                            
                            MagicLinkCodeInput(backgroundColor: WhoppahTheme.Color.base4,
                                               foregroundColor: WhoppahTheme.Color.base2,
                                               errorMessage: viewStore.state.model.magicLink.incompleteCode,
                                               isInputValid: $isCodeValid,
                                               inputValue: $magicCodeValue)
                            
                            Spacer()
                                .frame(height: footerSize.height)
                        }
                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                        .padding(.bottom, WhoppahTheme.Size.CTA.height)
                    }
                    .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth)
                    .scrollWithAdaptiveBounce(.vertical, showsIndicators: true)
                }
                
                //
                // 📙 Sticky footer button
                //
                
                StickyFooter {
                    CallToAction(backgroundColor: WhoppahTheme.Color.primary1,
                                 foregroundColor: WhoppahTheme.Color.base4,
                                 iconName: nil,
                                 title: viewStore.state.model.magicLink.signInButtonTitle,
                                 showBorder: false,
                                 showingProgress: $mainButtonShouldShowProgress)
                    {
                        guard isCodeValid else { return }
                        viewStore.send(
                            .outboundAction(
                                .didTapLoginWithMagicCode(code: magicCodeValue,
                                                          email: emailValue,
                                                          cookie: viewStore.state.magicLinkCookie)))
                    }
                    .disabled(mainButtonShouldShowProgress)
                }  onSizeChange: { newSize in
                    footerSize = newSize
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
    
    private func updateDescriptionText(viewStore: ViewStore<LoginView.ViewState, LoginView.Action>) -> [StringWithOptionalAction<LoginView.OutboundAction>] {
        var descriptionText = [StringWithOptionalAction<LoginView.OutboundAction>]()
        let words = viewStore.state.model.magicLink.magicLinkEnterCodeDescription.split(separator: " ")
        
        words.forEach({ word in
            descriptionText.append(
                StringWithOptionalAction(text: "\(word) ", action: nil)
            )
        })
        
        descriptionText.append(
            StringWithOptionalAction(text: viewStore.state.model.magicLink.resendEmail, action: .didTapSendMagicLinkCode(email: emailValue))
        )
        
        return descriptionText
    }
}

struct MagicLinkEnterCodeView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: LoginView.Reducer().reducer,
                      environment: .init(localizationClient: LoginView.mockLocalizationClient,
                                         trackingClient: LoginView.mockTrackingClient,
                                         outboundActionClient: LoginView.mockOutboundActionClient,
                                         mainQueue: .main))

        MagicLinkEnterCodeView(store: store,
                               navigationTitle: .constant("Title"),
                               emailValue: .constant("email@email.me"))
    }
}
