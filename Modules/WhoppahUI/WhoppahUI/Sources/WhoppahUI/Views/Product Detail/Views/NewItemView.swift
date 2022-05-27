//
//  NewItemView.swift
//  
//
//  Created by Marko Stojkovic on 4.4.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct NewItemView: View {
        
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    private let relatedProductItem: WhoppahModel.Product

    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                relatedProductItem: WhoppahModel.Product) {
        self.relatedProductItem = relatedProductItem
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                VStack(alignment: .center,
                       spacing: WhoppahTheme.Size.Padding.small) {
                    let imageUrl = self.relatedProductItem.thumbnails.first?.url ?? ""
                    if let url = URL(string: imageUrl) {
                        AsyncImage(url: url) {
                            PlaceholderRectangle()
                                .scaledToFit()
                        } image: { image in
                            image
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(maxWidth: WhoppahTheme.Size.NewProductItemImage.width,
                               maxHeight: WhoppahTheme.Size.NewProductItemImage.height)
                    }
                }
                
                VStack(alignment: .leading,
                       spacing: WhoppahTheme.Size.Padding.small) {
                    
                    HStack(alignment: .bottom) {
                        buildPriceLabel(self.relatedProductItem.auction)
                            .foregroundColor(WhoppahTheme.Color.base1)
                            .font(WhoppahTheme.Font.h4)
                        Spacer()
                        
                        ProductTileLikeButton(favorite: self.relatedProductItem.favorite) { favorite in
                            if let favorite = favorite {
                                viewStore.send(.removeFavorite(productId: self.relatedProductItem.id,
                                                               favorite: favorite))
                            } else {
                                viewStore.send(.createFavorite(productId: self.relatedProductItem.id))
                            }
                        }
                    }
                    .padding(.horizontal, WhoppahTheme.Size.Padding.small)
                    
                    Text(self.relatedProductItem.title)
                        .lineLimit(2)
                        .padding(.horizontal, WhoppahTheme.Size.Padding.small)
                        .foregroundColor(WhoppahTheme.Color.base5)
                        .font(WhoppahTheme.Font.body)
                }
            }
            .onTapGesture {
                viewStore.send(.outboundAction(.didSelectProduct(id: self.relatedProductItem.id)))
            }
        }
    }
    
    @ViewBuilder private func buildPriceLabel(_ auction: Auction?) -> some View {
        if let auction = self.relatedProductItem.auction {
            if auction.allowBid, let minimumBid = auction.minimumBid {
                Text("Bidding \(minimumBid.currency.text)\(minimumBid.amount)")
            } else if let buyNowPrice = auction.buyNowPrice {
                Text("\(buyNowPrice.currency.text)\(buyNowPrice.amount)")
            } else {
                EmptyView()
            }
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {

        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)
        NewItemView(store: store,
                    relatedProductItem: Product.random)
    }
}
