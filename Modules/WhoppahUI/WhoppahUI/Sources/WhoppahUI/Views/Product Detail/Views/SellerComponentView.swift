//
//  SellerComponentView.swift
//  WhoppahUI
//
//  Created by Marko Stojkovic on 23.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct SellerComponentView: View {

    @State private var text = ""

    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    private let product: WhoppahModel.Product
    private let action: () -> Void

    @State var isFirstResponder = false
    @Binding private var showReviews: Bool

    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                product: WhoppahModel.Product,
                showReviews: Binding<Bool>,
                action: @escaping () -> Void) {
        self.store = store
        self.product = product
        self._showReviews = showReviews
        self.action = action
    }

    private func isMerchantsOwnProduct(merchant: WhoppahModel.Merchant,
                                       currentUser: WhoppahModel.Member?) -> Bool
    {
        return currentUser?.merchantId == merchant.id
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                VStack(spacing: WhoppahTheme.Size.Padding.medium) {
                    HStack(alignment: .top) {
                        if let urlString = product.merchant.image?.url,
                           let url = URL(string: urlString)
                        {
                            AsyncImage(url: url) {
                                Image("avatar", bundle: .module)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: WhoppahTheme.Size.Image.height,
                                           height: WhoppahTheme.Size.Image.width)
                                    .cornerRadius(WhoppahTheme.Size.Image.height / 2)
                            } image: { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: WhoppahTheme.Size.Image.height,
                                           height: WhoppahTheme.Size.Image.width)
                                    .cornerRadius(WhoppahTheme.Size.Image.height / 2)
                            }
                        } else {
                            Image("avatar", bundle: .module)
                                .resizable()
                                .scaledToFit()
                                .frame(width: WhoppahTheme.Size.Image.height,
                                       height: WhoppahTheme.Size.Image.width)
                                .cornerRadius(WhoppahTheme.Size.Image.height / 2)
                        }
                        VStack(alignment: .leading,
                               spacing: WhoppahTheme.Size.Padding.tiniest) {
                            HStack(alignment: .top,
                                   spacing: WhoppahTheme.Size.Padding.small) {
                                Text(product.merchant.isVerified ? viewStore.model.sellerComponent.verifiedSeller : product.merchant.businessName ?? product.merchant.name)
                                    .font(WhoppahTheme.Font.h4)
                                    .foregroundColor(WhoppahTheme.Color.base1)
                                    .fixedSize(horizontal: false, vertical: true)
                                if product.merchant.isVerified {
                                    Image("verified_logo", bundle: .module)
                                        .padding(.top, WhoppahTheme.Size.Padding.tiniest)
                                }
                                Spacer()

                                if let _ = product.merchant.rating {
                                    Button {} label: {
                                        Text(viewStore.model.sellerComponent.readReviewsButtonTitle)
                                            .font(WhoppahTheme.Font.body)
                                            .foregroundColor(WhoppahTheme.Color.alert3)
                                            .fixedSize(horizontal: true, vertical: true)
                                    }.simultaneousGesture(TapGesture().onEnded({ _ in
                                        self.showReviews.toggle()
                                    }))
                                }
                            }
                            if let rating = product.merchant.rating {
                                HStack {
                                    Text("\(rating) / 5")
                                        .font(WhoppahTheme.Font.body)
                                        .foregroundColor(WhoppahTheme.Color.base1)
                                    Rating(withRating: Double(rating))
                                }
                            }
                        }
                        Spacer()
                    }

                    if !isMerchantsOwnProduct(merchant: product.merchant,
                                              currentUser: viewStore.state.user())
                    {
                        ZStack(alignment: .leading) {

                            TextEditor(text: $text)
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(self.text == viewStore.model.sellerComponent.placeholder ? WhoppahTheme.Color.border1 : WhoppahTheme.Color.base1)
                                .padding(.leading, WhoppahTheme.Size.Padding.extraMedium)
                                .padding(.trailing, WhoppahTheme.Size.Padding.superLarge)
                                .padding(.vertical, WhoppahTheme.Size.Padding.small)
                                .frame(minHeight: 50, maxHeight: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: WhoppahTheme.Size.Radius.superLarge)
                                        .stroke(WhoppahTheme.Color.base10, lineWidth: 1)
                                )
                                .background(Color.white)
                                .cornerRadius(WhoppahTheme.Size.Radius.superLarge)
                                .onTapGesture {
                                    self.action()
                                }

                            Text(viewStore.model.sellerComponent.placeholder)
                                .foregroundColor(WhoppahTheme.Color.border1)
                                .font(WhoppahTheme.Font.subtitle)
                                .padding(.leading, WhoppahTheme.Size.Padding.superMedium)
                                .isHidden(!$text.wrappedValue.isEmpty)

                            ///Note: This is must, so TextEditor can have dynamic height
                            Text(text).opacity(0)
                                .font(WhoppahTheme.Font.subtitle)
                                .padding(.leading, WhoppahTheme.Size.Padding.extraMedium)
                                .padding(.trailing, WhoppahTheme.Size.Padding.superLarge)
                                .padding(.vertical, WhoppahTheme.Size.Padding.small)

                            HStack {
                                Spacer()
                                Button {
                                    guard !text.isEmpty else { return }
                                    viewStore.send(.sendProductMessage(product: product, message: text))
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: WhoppahTheme.Size.Radius.extraMedium)
                                            .fill(WhoppahTheme.Color.alert3)
                                            .frame(width: WhoppahTheme.Size.RoundButton.width,
                                                   height: WhoppahTheme.Size.RoundButton.height)
                                        Image("send_text", bundle: .module)
                                    }
                                }
                                .padding([.trailing], WhoppahTheme.Size.Padding.mediumSmall)
                                .padding(.bottom, WhoppahTheme.Size.Padding.tiniest)
                                .frame(width: WhoppahTheme.Size.RoundButton.width,
                                       height: WhoppahTheme.Size.RoundButton.height)
                            }
                        }
                    }
                }
                .padding(.all, WhoppahTheme.Size.Padding.medium)
                .background(WhoppahTheme.Color.base9)
                .cornerRadius(WhoppahTheme.Size.Radius.small)
                .padding([.horizontal, .top], WhoppahTheme.Size.Padding.medium)
            }

            CallToAction(backgroundColor: WhoppahTheme.Color.alert3,
                         foregroundColor: WhoppahTheme.Color.base4,
                         title: viewStore.model.sellerComponent.showSellersItems,
                         showBorder: false)
            {
                viewStore.send(.outboundAction(.didTapShowMerchantProducts(id: product.merchant.id,
                                                                           merchantName: product.merchant.name)))
            }
            .padding([.horizontal, .bottom], WhoppahTheme.Size.Padding.medium)

            Rectangle()
                .fill(WhoppahTheme.Color.support7)
                .frame(height: WhoppahTheme.Size.Rectangle.height)
                .padding(.bottom, WhoppahTheme.Size.Padding.tiniest)
                .padding([.leading, .trailing], WhoppahTheme.Size.Padding.medium)
        }
    }
}

struct SellerComponentView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        SellerComponentView(store: store,
                            product: .random,
                            showReviews: .constant(false)) {}
    }
}
