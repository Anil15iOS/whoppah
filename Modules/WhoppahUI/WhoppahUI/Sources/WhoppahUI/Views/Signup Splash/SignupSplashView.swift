//  
//  SignupSplashView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/01/2022.
//

import SwiftUI
import ComposableArchitecture

public struct SignupSplashView: View, StoreInitializable {
    let store: Store<SignupSplashView.ViewState, SignupSplashView.Action>?
    @State private var footerSize: CGSize = .zero

    public init(store: Store<SignupSplashView.ViewState, SignupSplashView.Action>?) {
        self.store = store
        
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
        }
    }

    public var body: some View {
        if let store = store {
            GeometryReader { geom in
                WithViewStore(store) { viewStore in
                    VStack {
                        ZStack {
                            Image("img_auth_splash_large", bundle: .module)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: geom.size.width)
                            VStack(alignment: .center) {
                                Spacer()
                                Image("logo_signup_splash", bundle: .module)
                                Spacer()
                            }
                        }
                        .frame(maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? geom.size.height - footerSize.height : UIScreen.main.bounds.height - footerSize.height)
                        .mask(Rectangle())
                        
                        VStack(alignment: .center, spacing: WhoppahTheme.Size.Padding.medium) {
                            CallToAction(backgroundColor: WhoppahTheme.Color.primary1,
                                         foregroundColor: WhoppahTheme.Color.base4,
                                         iconName: nil,
                                         title: viewStore.state.model.loginButtonTitle,
                                         showBorder: false)
                            {
                                viewStore.send(.outboundAction(.didTapLogInButton))
                                viewStore.send(.trackingAction(.didTapLogInButton))
                            }
                            
                            CallToAction(backgroundColor: WhoppahTheme.Color.base4,
                                         foregroundColor: WhoppahTheme.Color.primary1,
                                         iconName: "wave_icon",
                                         title: viewStore.state.model.registerButtonTitle,
                                         showBorder: true)
                            {
                                viewStore.send(.outboundAction(.didTapRegisterButton))
                                viewStore.send(.trackingAction(.didTapRegisterButton))
                            }
                            
                            Button(viewStore.state.model.continueAsGuestButtonTitle) {
                                viewStore.send(.outboundAction(.didTapGuestButton))
                                viewStore.send(.trackingAction(.didTapGuestButton))
                            }
                            .font(WhoppahTheme.Font.subtitle)
                            .foregroundColor(WhoppahTheme.Color.primary1)
                            .frame(height: WhoppahTheme.Size.CTA.height)
                        }
                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                        .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth)
                        .background(GeometryReader { geometryProxy in
                            Color.clear
                                .preference(key: FooterSizePreferenceKey.self, value: geometryProxy.size)
                        })
                    }
                    .edgesIgnoringSafeArea(.top)
                    .onPreferenceChange(FooterSizePreferenceKey.self) { size in
                        footerSize = size
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct SignupSplashView_Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: SignupSplashView.Reducer().reducer,
                          environment: .init(localizationClient: SignupSplashView.mockLocalizationClient,
                                             trackingClient: SignupSplashView.mockTrackingClient,
                                             outboundActionClient: SignupSplashView.mockOutboundActionClient,
                                             mainQueue: .main))
        
        SignupSplashView(store: store)
    }
}

private struct FooterSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
