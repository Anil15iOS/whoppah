//
//  ProductTile.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/03/2022.
//

import SwiftUI
import ComposableArchitecture
import WhoppahModel

struct ProductTile: View {
    private let searchItem: ProductTileItem
    
    typealias OnRemoveFavoriteClosure = (UUID, Favorite) -> Void
    typealias OnCreateFavoriteClosure = (UUID) -> Void
    typealias BidFromFormatterClosure = (WhoppahModel.Price) -> String
    
    private let onRemoveFavorite: OnRemoveFavoriteClosure
    private let onCreateFavorite: OnCreateFavoriteClosure
    private let bidFromFormatterClosure: BidFromFormatterClosure
    
    init(searchItem: ProductTileItem,
         onRemoveFavorite: @escaping OnRemoveFavoriteClosure,
         onCreateFavorite: @escaping OnCreateFavoriteClosure,
         bidFromFormatterClosure: @escaping BidFromFormatterClosure)
    {
        self.searchItem = searchItem
        self.onRemoveFavorite = onRemoveFavorite
        self.onCreateFavorite = onCreateFavorite
        self.bidFromFormatterClosure = bidFromFormatterClosure
    }
    
    var body: some View {
        GeometryReader { geom in
            VStack(spacing: WhoppahTheme.Size.Padding.tiny) {
                
                //
                // 🌅 Placeholder & thumbnail
                //
                
                VStack {
                    if let urlString = searchItem.image?.url,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) {
                            PlaceholderRectangle()
                                .scaledToFit()
                        } image: { image in
                            ZStack {
                                image
                                    .resizable()
                                    .scaledToFit()
                                
                                if [AuctionState.completed, .reserved].contains(searchItem.auction?.state) {
                                    Text(searchItem.auction!.state.localized.uppercased())
                                        .font(WhoppahTheme.Font.h4)
                                        .foregroundColor(WhoppahTheme.Color.base4)
                                        .padding(.all, WhoppahTheme.Size.Padding.medium)
                                        .background(WhoppahTheme.Color.primary1)
                                } else {
                                    
                                    // Only show these when the item hasn't been sold or reserved.
                                    // Otherwise these will overlap.
                                    
                                    if let labels = searchItem.labelAttributes {
                                        VStack(spacing: WhoppahTheme.Size.Padding.tiny) {
                                            ForEach(labels, id: \.self) { label in
                                                ProductTileLabel(label: label)
                                            }
                                            Spacer()
                                        }
                                        .padding(.top, WhoppahTheme.Size.Padding.tiny)
                                        .padding(.trailing, WhoppahTheme.Size.Padding.tiny)
                                    }
                                }
                                
                                //
                                // ❤️ Like button
                                //
                                
                                VStack {
                                    Spacer()
                                    
                                    HStack {
                                        Spacer()
                                        
                                        ProductTileLikeButton(favorite: searchItem.favorite) { favorite in
                                            if let favorite = favorite {
                                                onRemoveFavorite(searchItem.id, favorite)
                                            } else {
                                                onCreateFavorite(searchItem.id)
                                            }
                                        }
                                        .padding(.all, WhoppahTheme.Size.Padding.small)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: geom.size.width,
                       height: geom.size.width)
                .background(WhoppahTheme.Color.base3)
                
                //
                // 💰 Product Price
                //

                HStack {
                    buildPriceLabel(searchItem.auction, bidFromFormatter: bidFromFormatterClosure)
                        .font(WhoppahTheme.Font.h4)
                        .foregroundColor(WhoppahTheme.Color.base1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                //
                // 🖌 Product Title
                //

                Text(searchItem.title)
                    .font(WhoppahTheme.Font.body)
                    .foregroundColor(WhoppahTheme.Color.base1)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .aspectRatio(WhoppahTheme.Size.GridItem.aspectRatio,
                     contentMode: .fill)
    }
        
    @ViewBuilder private func buildPriceLabel(_ auction: Auction?, bidFromFormatter: BidFromFormatterClosure) -> some View {
        if let auction = searchItem.auction {
            if auction.allowBid, let minimumBid = auction.minimumBid {
                FlowLayout(mode: .scrollable,
                           binding: .constant(3),
                           items: bidFromFormatterClosure(minimumBid).components(separatedBy: " ")) { item, isLastItem in
                    Text(isLastItem ? item : "\(item) ")
                }
            } else if let buyNowPrice = auction.buyNowPrice {
                Text("\(buyNowPrice.formattedString)")
            } else {
                EmptyView()
            }
        }
    }
}

struct ProductTile_Previews: PreviewProvider {
    static var previews: some View {
        let item = ProductTileItem(
            id: UUID(),
            state: .accepted,
            title: "Title",
            slug: "product",
            description: "Description",
            favorite: nil,
            auction: nil,
            image: nil)
        ProductTile(searchItem: item,
                    onRemoveFavorite: { _, _ in },
                    onCreateFavorite: {_ in },
                    bidFromFormatterClosure: { _ in "" })
    }
}
