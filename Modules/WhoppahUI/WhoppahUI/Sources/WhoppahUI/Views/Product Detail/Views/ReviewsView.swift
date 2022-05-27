//
//  ReviewsView.swift
//  
//
//  Created by Marko Stojkovic on 5.5.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct ReviewsView: View {

    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    @Binding private var showReviews: Bool
    @State private var contentSize: CGSize = .zero

    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                showReviews: Binding<Bool>) {
        self.store = store
        self._showReviews = showReviews
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                if self.showReviews {
                    Color.black.opacity(self.showReviews ? 0.5 : 0).edgesIgnoringSafeArea(.all).onTapGesture {
                        withAnimation(.linear(duration: 0.1)) {
                            self.showReviews = false
                        }
                    }
                    VStack(alignment: .leading,
                           spacing: WhoppahTheme.Size.Padding.medium) {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.linear(duration: 0.1)) {
                                    self.showReviews = false
                                }
                            } label: {
                                Image("close-small", bundle: .module)
                            }
                            .padding([.trailing, .top], WhoppahTheme.Size.Padding.mediumSmall)
                        }
                        Text("Reviews")
                            .foregroundColor(WhoppahTheme.Color.base1)
                            .font(WhoppahTheme.Font.h2)
                            .frame(maxWidth: .infinity)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            Group {
                                ZStack {
                                    RoundedRectangle(cornerRadius: WhoppahTheme.Size.CTA.cornerRadius)
                                        .fill(WhoppahTheme.Color.base9)
                                    RoundedRectangle(cornerRadius: WhoppahTheme.Size.CTA.cornerRadius)
                                        .stroke(WhoppahTheme.Color.base10)
                                    
                                    HStack(alignment: .top) {
                                        if let urlString = viewStore.model.product?.merchant.image?.url,
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
                                                let verified = viewStore.model.product?.merchant.isVerified ?? false
                                                Text(verified ? viewStore.model.sellerComponent.verifiedSeller : viewStore.model.product?.merchant.businessName ?? viewStore.model.product?.merchant.name ?? "")
                                                    .font(WhoppahTheme.Font.h4)
                                                    .foregroundColor(WhoppahTheme.Color.base1)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                if verified {
                                                    Image("verified_logo", bundle: .module)
                                                        .padding(.top, WhoppahTheme.Size.Padding.tiniest)
                                                }
                                                Spacer()
                                            }
                                            if let rating = viewStore.model.product?.merchant.rating {
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
                                    .padding(.all, WhoppahTheme.Size.Padding.medium)
                                }
                                .padding(.all, WhoppahTheme.Size.Padding.medium)
                                .cornerRadius(WhoppahTheme.Size.Radius.small)
                                
                                ForEach(viewStore.state.reviews) { review in
                                    HStack{
                                        Text(review.anonymous ? "" : review.reviewerName ?? "")
                                            .font(WhoppahTheme.Font.h4)
                                            .foregroundColor(WhoppahTheme.Color.base1)
                                        Spacer()
                                        if let rating = review.score {
                                            Rating(withRating: Double(rating))
                                        }
                                    }
                                    .padding(.top, WhoppahTheme.Size.Radius.regularMedium)
                                    Text(review.review ?? "")
                                        .padding(.top,WhoppahTheme.Size.Padding.small )
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                        .font(WhoppahTheme.Font.body)
                                        .foregroundColor(WhoppahTheme.Color.base1)
                                    Rectangle()
                                        .fill(WhoppahTheme.Color.support7)
                                        .frame(height: WhoppahTheme.Size.Rectangle.height)
                                        .padding(.bottom, WhoppahTheme.Size.Rectangle.paddingSmall)
                                }
                            }
                            .overlay(
                                GeometryReader { geo in
                                    Color.clear.onAppear {
                                        contentSize = geo.size
                                    }
                                })
                        }
                        .frame(maxHeight: contentSize.height)
                        
                        CallToAction(backgroundColor: Color.white,
                                     foregroundColor: WhoppahTheme.Color.base1,
                                     iconName: nil,
                                     title: viewStore.model.review.goBackButtonTitle,
                                     showBorder: true)
                        {
                            withAnimation(.linear(duration: 0.2)) {
                                self.showReviews = false
                            }
                        }
                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                        
                    }
                    .padding(.all, WhoppahTheme.Size.Padding.medium)
                    .background(Color.white)
                    .cornerRadius(WhoppahTheme.Size.Radius.small)
                    .padding(.all, WhoppahTheme.Size.Padding.medium)
                    .padding(.top, WhoppahTheme.Size.Padding.extraLarge)
                }
            }
        }
    }
}
