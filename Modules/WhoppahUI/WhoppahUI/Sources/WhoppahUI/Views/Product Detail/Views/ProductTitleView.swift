//
//  ProductTitleView.swift
//  WhoppahUI
//
//  Created by Marko Stojkovic on 17.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct ProductTitleView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    private let product: WhoppahModel.Product
    
    private var allLanguages: [Lang] {
        var cases = Lang.allCases
        cases.removeAll(where: { $0 == .unknown })
        return cases
    }
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                product: WhoppahModel.Product) {
        self.store = store
        self.product = product
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading,
                   spacing: WhoppahTheme.Size.Padding.small) {
                Text(product.title)
                    .font(WhoppahTheme.Font.h2)
                    .foregroundColor(WhoppahTheme.Color.base8)

                buildPriceLabel(product.auction, model: viewStore.model.productTitle)
                    .font(WhoppahTheme.Font.subtitle)
                    .foregroundColor(WhoppahTheme.Color.base8)

                //
                // 📙 Bid info view
                //

                BidInfoView(product: product,
                            bidInfoTitle: viewStore.model.productTitle.bidInfo)

                //
                // 📙 Seller's info view
                //

                SellerInfoView(store: store)

                Rectangle()
                    .fill(WhoppahTheme.Color.support7)
                    .frame(height: WhoppahTheme.Size.Rectangle.height)
                    .padding(.top, WhoppahTheme.Size.Padding.small)
                    .padding(.bottom, WhoppahTheme.Size.Padding.medium)

                Text(viewStore.model.productTitle.productDescriptionTextTitle)
                    .font(WhoppahTheme.Font.h3)
                    .foregroundColor(WhoppahTheme.Color.base8)
                
                if let description = viewStore.state.translatedProductDescription ?? product.description {
                    ZStack {
                        VStack {
                            Text(description)
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base1)
                                .padding(.bottom, WhoppahTheme.Size.Padding.tiniest)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if let originalDescription = product.description {
                                HStack {
                                    Spacer()
                                    Menu(viewStore.model.productTitle.translateButtonTitle) {
                                        ForEach(allLanguages, id: \.self) { language in
                                            Button {
                                                viewStore.send(.translate(text: originalDescription, language: language))
                                            } label: {
                                                Text(language.localized)
                                                    .font(WhoppahTheme.Font.paragraph)
                                            }
                                        }
                                    }
                                    .font(WhoppahTheme.Font.bodyMedium)
                                    .foregroundColor(WhoppahTheme.Color.alert3)
                                }
                            }
                        }
                        if viewStore.state.translationState == .loading {
                            ZStack {
                                ActivityIndicator(isAnimating: .constant(true),
                                                  style: .large,
                                                  color: WhoppahTheme.Color.base1)
                            }
                        }
                    }
                }
            }
            .padding(.all, WhoppahTheme.Size.Padding.medium)
        }
    }
    
    @ViewBuilder private func buildPriceLabel(_ auction: Auction?, model: ProductDetailView.Model.ProductTitle) -> some View {
        if let auction = auction {
            if auction.allowBid, let minimumBid = auction.minimumBid {
                Text(model.bidOfferTextTitle(minimumBid.formattedString))
            } else if let buyNowPrice = auction.buyNowPrice {
                Text(model.buyFromTextTitle(buyNowPrice.formattedString))
            } else {
                EmptyView()
            }
        }
    }
}

struct ProductTitleView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        ProductTitleView(store: store,
                         product: .random)
    }
}
