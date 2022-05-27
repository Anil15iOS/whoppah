//
//  HeroImageView.swift
//  
//
//  Created by Marko Stojkovic on 24.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct HeroImageView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    @Binding private var showImageGallery: Bool
    @Binding private var selectedPage: Int
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                showImageGallery: Binding<Bool>,
                selectedPage: Binding<Int>) {
        self.store = store
        self._showImageGallery = showImageGallery
        self._selectedPage = selectedPage
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if let product = viewStore.model.product {
                ZStack(alignment: .bottom) {
                    if product.thumbnails.count > 0 {
                        VStack {
                            TabView (selection: Binding(
                                get: { selectedPage },
                                set: {
                                    selectedPage = $0
                                }
                            )) {
                                ForEach(thumbnailInfo(product)) { thumbnail in
                                    Group {
                                        AsyncImage(url: thumbnail.url) {
                                            PlaceholderRectangle()
                                                .scaledToFit()
                                        } image: { loadedImage in
                                            loadedImage
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: .infinity)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .tag(thumbnail.tag)
                                    .simultaneousGesture(TapGesture().onEnded({ _ in
                                        showImageGallery.toggle()
                                    }))
                                    .onAppear {
                                        viewStore.send(
                                            .trackingAction(
                                                .trackPhotoViewed(product: product,
                                                                  photoId: thumbnail.id)))
                                    }
                                }
                            }
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom)
                            )
                            .tabViewStyle(.page)
                            .frame(height: WhoppahTheme.Size.HeroImage.height)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: WhoppahTheme.Size.Padding.smaller) {
                            HStack(spacing: WhoppahTheme.Size.Padding.smaller) {
                                Image("heart_white_filled", bundle: .module)
                                Text("\(product.favoriteCount)")
                                    .foregroundColor(Color.white)
                                    .font(WhoppahTheme.Font.body)
                            }
                            
                            HStack(spacing: WhoppahTheme.Size.Padding.smaller) {
                                Image("eye_white_filled", bundle: .module)
                                Text("\(product.viewCount)")
                                    .foregroundColor(Color.white)
                                    .font(WhoppahTheme.Font.body)
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing,
                               spacing: 0) {
                            HStack(spacing: WhoppahTheme.Size.Padding.smaller) {
                                Button {} label: {
                                    Image("share_gray", bundle: .module)
                                }
                                .frame(width: WhoppahTheme.Size.RoundButton.width,
                                       height: WhoppahTheme.Size.RoundButton.height)
                                .background(Color.white)
                                .cornerRadius(WhoppahTheme.Size.Radius.extraMedium)
                                .simultaneousGesture(TapGesture().onEnded({ _ in
                                    viewStore.send(.outboundAction(.didTapShareProduct(product: product)))
                                    viewStore.send(.trackingAction(.trackShareClicked(product: product)))
                                }))
                            }
                            
                            ProductDetailLikeButton(favorite: product.favorite,
                                                    didTapButton: { favorite in
                                if let favorite = favorite {
                                    viewStore.send(.removeFavorite(productId: product.id,
                                                                   favorite: favorite))
                                    viewStore.send(.trackingAction(.trackFavouriteStatusChanged(product: product, favorited: false)))
                                } else {
                                    viewStore.send(.createFavorite(productId: product.id))
                                    viewStore.send(.trackingAction(.trackFavouriteStatusChanged(product: product,
                                                                                                favorited: true)))
                                }
                            })
                            .padding(.trailing, -WhoppahTheme.Size.Padding.medium)
                        }
                    }
                    .padding([.bottom, .leading, .trailing], WhoppahTheme.Size.Padding.medium)
                }
            }  else {
                EmptyView()
            }
        }
    }
    
    private struct ThumbnailInfo: Equatable, Identifiable {
        let id: UUID
        let url: URL
        let tag: Int
    }
    
    private func thumbnailInfo(_ product: WhoppahModel.Product) -> [ThumbnailInfo] {
        var info = [ThumbnailInfo]()
        var tag = 0
        product.thumbnails.forEach { thumbnail in
            if let url = URL(string: thumbnail.url) {
                info.append(ThumbnailInfo(id: thumbnail.id,
                                          url: url,
                                          tag: tag))
                tag += 1
            }
        }
            
        return info
    }
}

struct HeroImageView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        HeroImageView(store: store,
                      showImageGallery: .constant(false),
                      selectedPage: .constant(0))
    }
}
