//
//  SwiftUIView.swift
//  
//
//  Created by Dennis Ippel on 30/11/2021.
//

import SwiftUI
import ComposableArchitecture
import WhoppahModel

struct CategoryMenu: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var showNavigationView: Binding<Bool>
    
    private let store: Store<AppMenu.ViewState, AppMenu.Action>
    private let category: WhoppahModel.Category
    
    public init(store: Store<AppMenu.ViewState, AppMenu.Action>,
                category: WhoppahModel.Category,
                showNavigationView: Binding<Bool>) {
        self.store = store
        self.category = category
        self.showNavigationView = showNavigationView
    }
    
    var body: some View {
        if let children = category.children {
            WithViewStore(store) { viewStore in
                VStack(spacing: 0) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
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

                    Text(category.title)
                        .font(WhoppahTheme.Font.h1)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, WhoppahTheme.Size.Padding.medium)
                    
                    VStack(spacing: 0) {
                        ForEach(children) { category in
                            if let children = category.children, children.count > 0 {
                                NavigationLink {
                                    CategoryMenu(store: store,
                                                 category: category,
                                                 showNavigationView: showNavigationView)
                                } label: {
                                    CategoryMenuButton(category: category)
                                }
                            } else {
                                CategoryMenuButton(category: category).onTapGesture {
                                    withAnimation { showNavigationView.wrappedValue = false }
                                    viewStore.send(.outboundAction(.showCategory(category: category)))
                                }
                            }
                        }
                    }.scrollOnOverflow(.vertical, showsIndicators: false)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        } else {
            EmptyView()
        }
    }
}

struct CategoryMenu_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: AppMenu.Reducer().reducer,
                          environment: .init(localizationClient: AppMenu.mockLocalizationClient,
                                             trackingClient: AppMenu.mockTrackingClient,
                                             outboundActionClient: AppMenu.mockOutboundActionClient,
                                             categoriesClient: WhoppahUI.CategoriesClient.mockCategoriesClient,
                                             mainQueue: .main))
        
        CategoryMenu(
            store: store,
            category: .init(id: UUID(), title: "Category", slug: "", images: [], videos: []),
            showNavigationView: .constant(true))
    }
}
