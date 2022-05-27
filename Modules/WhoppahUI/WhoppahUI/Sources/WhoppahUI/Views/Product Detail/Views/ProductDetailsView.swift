//
//  ProductDetailsView.swift
//  
//
//  Created by Marko Stojkovic on 15.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct ProductDetailsView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    private let product: WhoppahModel.Product
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                product: WhoppahModel.Product) {
        self.store = store
        self.product = product
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading,
                   spacing: WhoppahTheme.Size.Padding.medium) {
                Text(viewStore.model.productDetails.title)
                    .font(WhoppahTheme.Font.h3)
                    .foregroundColor(WhoppahTheme.Color.base1)
                
                if let description = product.brand?.description {
                    Text(description)
                        .font(WhoppahTheme.Font.subtitle)
                        .foregroundColor(WhoppahTheme.Color.base1)
                        .padding(.bottom, WhoppahTheme.Size.Padding.medium)
                }
                
                VStack(alignment: .leading,
                       spacing: WhoppahTheme.Size.Padding.tiny) {
                    
                    if product.colors.count > 0 {
                        HStack(spacing: WhoppahTheme.Size.Padding.small) {
                            Text(viewStore.model.productDetails.colourTitle)
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base1)
                            Spacer()
                            ForEach(product.colors, id: \.id) { color in
                                Circle()
                                    .strokeBorder(WhoppahTheme.Color.base2, lineWidth: 1)
                                    .background(Circle().fill(Color(hex: color.hex)))
                                    .frame(width: WhoppahTheme.Size.ColorView.width,
                                           height: WhoppahTheme.Size.ColorView.height,
                                           alignment: .leading)
                            }
                        }
                    }
                    
                    if product.styles.count > 0 {
                        ItemDetailView(item: viewStore.model.productDetails.styleTitle,
                                       itemValues: product.styles.map({ $0.localize(\.title) }).joined(separator: ", "))
                    }
                    if product.materials.count > 0 {
                        ItemDetailView(item: viewStore.model.productDetails.materialTitle,
                                       itemValues: product.materials.map({ $0.localize(\.title) }).joined(separator: ", "))
                    }
                    if let numberOfItems = product.numberOfItems {
                        ItemDetailView(item: viewStore.model.productDetails.numberOfItemsTitle,
                                       itemValues: "\(numberOfItems)")
                    }
                    if let width = product.width {
                        ItemDetailView(item: viewStore.model.productDetails.widthTitle,
                                       itemValues: "\(width) cm")
                    }
                    if let height = product.height {
                        ItemDetailView(item: viewStore.model.productDetails.heightTitle,
                                       itemValues: "\(height) cm")
                    }
                    if let depth = product.depth {
                        ItemDetailView(item: viewStore.model.productDetails.depthTitle,
                                       itemValues: "\(depth) cm")
                    }
                        
                    Rectangle()
                        .fill(WhoppahTheme.Color.support7)
                        .frame(height: WhoppahTheme.Size.Rectangle.height)
                        .padding(.top, WhoppahTheme.Size.Rectangle.padding)
                }
            }
            .padding([.leading, .trailing], WhoppahTheme.Size.Padding.medium)
        }
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        ProductDetailsView(store: store, product: .random)
    }
}
