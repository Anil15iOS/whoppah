//
//  RelatedProductsView.swift
//  
//
//  Created by Marko Stojkovic on 4.4.22..
//

import SwiftUI
import Combine
import ComposableArchitecture

struct RelatedProductsView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>) {
        self.store = store
    }
    
    let columns = [
        GridItem(.adaptive(minimum: WhoppahTheme.Size.NewProductItem.width,
                           maximum: WhoppahTheme.Size.NewProductItem.height))
       ]
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.model.relatedProducts.newProductItems.count > 0 {
                VStack(spacing: WhoppahTheme.Size.Padding.large) {
                    Text(viewStore.model.relatedProducts.headerTitle)
                        .font(WhoppahTheme.Font.h2)
                        .foregroundColor(WhoppahTheme.Color.base6)
                    
                    VStack(spacing: WhoppahTheme.Size.Padding.small) {
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(viewStore.model.relatedProducts.newProductItems) { item in
                                ProductTile(
                                    searchItem: item,
                                    onRemoveFavorite: { productId, favorite in
                                        viewStore.send(
                                            .removeFavorite(productId: productId,
                                                            favorite: favorite))
                                    }, onCreateFavorite: { productId in
                                        viewStore.send(
                                            .createFavorite(productId: productId))
                                    }, bidFromFormatterClosure: viewStore.model.bidComponent.bidFromTitle)
                                    .id(item.id)
                                    .onTapGesture {
                                        viewStore.send(.outboundAction(.didSelectProduct(id: item.id)))
                                    }
                            }
                        }
                    }
                }
                .padding([.horizontal], WhoppahTheme.Size.Padding.medium)
                .padding([.vertical], WhoppahTheme.Size.Padding.small)
            } else {
                EmptyView()
            }
        }
    }
}

struct RelatedProductsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        RelatedProductsView(store: store)
    }
}
