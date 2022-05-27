//
//  ContentView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/11/2021.
//

import SwiftUI
import WhoppahUI
import ComposableArchitecture

struct ContentView: View {
    
    enum WhoppahUIView: String, CaseIterable {
        case none = "None"
        
        case menu = "Menu"
        case aboutWhoppah = "About Whoppah"
        case login = "Login View"
        case registration = "Registration View"
        case magicLinkEnterCodeView = "Magic Link Enter Code View"
        case signupSplash = "Signup Splash View"
        case welcomeToWhoppah = "Welcome to Whoppah Dialog"
        case productDetail = "Product Detail View"
        case search = "Search View"
        case merchantProducts = "Merchant's Products"
        case backgroundShaderView = "Background Shader View"
    }
    
    @State private var selectedView: WhoppahUIView = .none
    
    var body: some View {
        switch selectedView {
        case .menu:
            let store = Store(initialState: .initial,
                              reducer: AppMenu.Reducer().reducer,
                              environment: .mock)
            AppMenu(store: store)
        case .aboutWhoppah:
            let store = Store(initialState: .initial,
                              reducer: AboutWhoppah.Reducer().reducer,
                              environment: .mock)
            AboutWhoppah(store: store)
        case .registration:
            let store = Store(initialState: .initial,
                              reducer: RegistrationView.Reducer().reducer,
                              environment: .mock)
            RegistrationView(store: store)
        case .login:
            let store = Store(initialState: .initial,
                              reducer: LoginView.Reducer().reducer,
                              environment: .mock)
            LoginView(store: store)
        case .magicLinkEnterCodeView:
            let store = Store(initialState: .initial,
                              reducer: LoginView.Reducer().reducer,
                              environment: .mock)
            MagicLinkEnterCodeView(store: store,
                                   navigationTitle: .constant("Title"),
                                   emailValue: .constant("email@test.com"))
        case .signupSplash:
            let store = Store(initialState: .initial,
                              reducer: SignupSplashView.Reducer().reducer,
                              environment: .mock)
            SignupSplashView(store: store)
        case .welcomeToWhoppah:
            let store = Store(initialState: .initial,
                              reducer: WelcomeToWhoppahDialog.Reducer().reducer,
                              environment: .mock)
            WelcomeToWhoppahDialog(store: store)
        case .productDetail:
            let store = Store(initialState: .initial,
                              reducer: ProductDetailView.Reducer().reducer,
                              environment: .mock)
            ProductDetailView(store: store)
        case .search:
            let store = Store(initialState: .initial,
                              reducer: SearchView.Reducer().reducer,
                              environment: .mock)
            SearchView(store: store, searchInput: nil)
        case .merchantProducts:
            let store = Store(initialState: .initial,
                              reducer: MerchantProductsView.Reducer().reducer,
                              environment: .mock)
            MerchantProductsView(store: store, merchantId: UUID(), merchantName: "Merchant Name")
        case .backgroundShaderView:
            ExampleMetalBackgroundShaderView(viewSize: UIScreen.main.nativeBounds.size)
                .edgesIgnoringSafeArea(.all)
        case .none:
            GeometryReader { geomProxy in
                ScrollView {
                    VStack {
                        ForEach(WhoppahUIView.allCases, id: \.self) { view in
                            if view != .none {
                                Button(view.rawValue) { selectedView = view }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.pink.opacity(0.5)))
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
