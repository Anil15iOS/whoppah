//  
//  MerchantProductsView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/05/2022.
//

import SwiftUI
import ComposableArchitecture

public struct MerchantProductsView: View, StoreInitializable {
    let store: Store<MerchantProductsView.ViewState, MerchantProductsView.Action>?
    
    @State var merchantId: UUID = UUID()
    @State var merchantName: String = ""
    
    let columns = [
        GridItem(.adaptive(minimum: WhoppahTheme.Size.NewProductItem.width,
                           maximum: WhoppahTheme.Size.NewProductItem.height))
       ]

    public init(store: Store<MerchantProductsView.ViewState, MerchantProductsView.Action>?) {
        self.store = store
    }
    
    public init(store: Store<MerchantProductsView.ViewState, MerchantProductsView.Action>?,
                merchantId: UUID,
                merchantName: String) {
        self.init(store: store)
        self.merchantId = merchantId
        self.merchantName = merchantName
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                VStack {
                    
                    if viewStore.state.contentLoadingState == .finished {
                        
                        ///
                        /// 🐼 Header
                        ///
                        
                        ZStack {
                            Text("\(viewStore.model.allItemsFromTitle) \(merchantName)")
                                .font(WhoppahTheme.Font.h3)
                                .foregroundColor(WhoppahTheme.Color.base1)
                                .frame(maxWidth: .infinity, alignment: .center)

                            HStack {
                                Button {
                                    viewStore.send(.outboundAction(.didTapGoBack))
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(WhoppahTheme.Color.base1)
                                        .frame(width: WhoppahTheme.Size.NavBar.backButtonSize,
                                               height: WhoppahTheme.Size.NavBar.backButtonSize)
                                }
                                .padding(WhoppahTheme.Size.Padding.small)
                                .contentShape(Rectangle())

                                Spacer()
                            }
                        }
                        .padding(.vertical, WhoppahTheme.Size.Padding.small)
                        .padding(.bottom, WhoppahTheme.Size.Padding.medium)
                        .background(WhoppahTheme.Color.base4)
                        
                        ///
                        /// 🪑 Products
                        ///
                        
                        if viewStore.state.fetchProductsState == .finished {
                            ScrollView {
                                VStack(spacing: WhoppahTheme.Size.Padding.small) {
                                    LazyVGrid(columns: columns, alignment: .center) {
                                        ForEach(viewStore.state.products) { item in
                                            ProductTile(
                                                searchItem: item,
                                                onRemoveFavorite: { productId, favorite in
                                                    viewStore.send(
                                                        .removeFavorite(productId: productId,
                                                                        favorite: favorite))
                                                }, onCreateFavorite: { productId in
                                                    viewStore.send(
                                                        .createFavorite(productId: productId))
                                                }, bidFromFormatterClosure: viewStore.model.bidFromTitle)
                                                .id(item.id)
                                                .onTapGesture {
                                                    viewStore.send(.outboundAction(.didSelectProduct(id: item.id)))
                                                }
                                        }
                                    }
                                    Spacer()
                                }
                                .padding([.horizontal, .bottom], WhoppahTheme.Size.Padding.medium)
                            }
                        } else {
                            Spacer()
                            ActivityIndicator(isAnimating: .constant(true),
                                              style: .large,
                                              color: WhoppahTheme.Color.base1)
                            Spacer()
                        }
                    } else {
                        Spacer()
                        ActivityIndicator(isAnimating: .constant(true),
                                          style: .large,
                                          color: WhoppahTheme.Color.base1)
                            .onAppear {
                                if viewStore.contentLoadingState == .uninitialized {
                                    viewStore.send(.loadContent(merchantId: merchantId,
                                                                merchantName: merchantName))
                                }
                            }
                        Spacer()
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        } else {
            EmptyView()
        }
    }
}

struct MerchantProductsView_Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: MerchantProductsView.Reducer().reducer,
                              environment: .mock)
        
        MerchantProductsView(store: store)
    }
}
