//
//  AppMenu.swift
//  
//
//  Created by Dennis Ippel on 20/11/2021.
//

import SwiftUI
import ComposableArchitecture

public struct AppMenu: View, StoreInitializable {
    let store: Store<AppMenu.ViewState, AppMenu.Action>?
    
    @State public var showNavigationView: Bool = false
    
    public init(store: Store<AppMenu.ViewState, AppMenu.Action>?) {
        self.store = store
        
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
        }
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                HStack {
                    Spacer()
                        .frame(minWidth: WhoppahTheme.Size.Menu.leftSideSpacing, maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation { showNavigationView = false }
                            viewStore.send(.outboundAction(.exitMenu))
                        }
                    NavigationView {
                        VStack(spacing: 0) {
                            Button {
                                withAnimation { showNavigationView = false }
                                viewStore.send(.outboundAction(.exitMenu))
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: WhoppahTheme.Size.Menu.itemHeight / 2,
                                           height: WhoppahTheme.Size.Menu.itemHeight / 2)
                                    .frame(maxWidth: .infinity,
                                           alignment: .leading)
                            }
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                            .padding(.leading, WhoppahTheme.Size.Padding.medium)

                            Spacer()
                                .frame(height: WhoppahTheme.Size.Menu.itemHeight / 2)

                            Text(viewStore.state.model.title)
                                .font(WhoppahTheme.Font.h1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: WhoppahTheme.Size.Menu.itemHeight)
                                .padding(.leading, WhoppahTheme.Size.Padding.medium)

                            ForEach(viewStore.state.categories) { category in
                                if let count = category.children?.count, count > 0 {
                                    NavigationLink {
                                        CategoryMenu(store: store,
                                                     category: category,
                                                     showNavigationView: $showNavigationView)
                                    } label: {
                                        CategoryMenuButton(category: category)
                                    }
                                } else {
                                    CategoryMenuButton(category: category).onTapGesture {
                                        withAnimation { showNavigationView = false }
                                        viewStore.send(.outboundAction(.showCategory(category: category)))
                                    }
                                }
                            }

                            Spacer()
                                .frame(height: WhoppahTheme.Size.Padding.large)

                            Group {
                                MenuButton(title: viewStore.state.model.contact) {
                                    withAnimation { showNavigationView = false }
                                    viewStore.send(.outboundAction(.contact))
                                }
                                MenuButton(title: viewStore.state.model.myProfile) {
                                    withAnimation { showNavigationView = false }
                                    viewStore.send(.outboundAction(.myProfile))
                                }
                                MenuButton(title: viewStore.state.model.chatsBidding) {
                                    withAnimation { showNavigationView = false }
                                    viewStore.send(.outboundAction(.chatsBidding))
                                }
                                MenuButton(title: viewStore.state.model.howWhoppahWorks) {
                                    withAnimation { showNavigationView = false }
                                    viewStore.send(.outboundAction(.howWhoppahWorks))
                                }
                                MenuButton(title: viewStore.state.model.aboutWhoppah) {
                                    withAnimation { showNavigationView = false }
                                    viewStore.send(.outboundAction(.aboutWhoppah))
                                }
                                /*
                                MenuButton(title: viewStore.state.model.whoppahReviews) {
                                    withAnimation { showNavigationView = false }
                                    viewStore.send(.outboundAction(.whoppahReviews))
                                }
                                
                                 Design hasn't been approved yet.
                                MenuButton(title: viewStore.state.model.storeAndSell) {
                                    withAnimation { showNavigationView = false }
                                    viewStore.send(.outboundAction(.storeAndSell))
                                }
                                 */
                            }

                            Spacer()
                        }
                        .animation(nil)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .offset(x: showNavigationView ? 0 : min(UIScreen.main.bounds.width - WhoppahTheme.Size.Menu.leftSideSpacing, WhoppahTheme.Size.Menu.maxWidth))
                    .animation(.easeOut(duration: WhoppahTheme.Animation.Menu.toggleVisibilityDuration))
                    .frame(width: min(UIScreen.main.bounds.width - WhoppahTheme.Size.Menu.leftSideSpacing, WhoppahTheme.Size.Menu.maxWidth))
                }
                .onAppear {
                    withAnimation {
                        showNavigationView.toggle()
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: AppMenu.Reducer().reducer,
                          environment: .init(localizationClient: AppMenu.mockLocalizationClient,
                                             trackingClient: AppMenu.mockTrackingClient,
                                             outboundActionClient: AppMenu.mockOutboundActionClient,
                                             categoriesClient: WhoppahUI.CategoriesClient.mockCategoriesClient,
                                             mainQueue: .main))
        
        AppMenu(store: store)
    }
}
