//
//  ProductConditionView.swift
//  
//
//  Created by Marko Stojkovic on 17.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct ProductConditionView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    private let product: WhoppahModel.Product
    private let bulletPoint: String = "\u{2022}"
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                product: WhoppahModel.Product) {
        self.store = store
        self.product = product
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading,
                   spacing: WhoppahTheme.Size.Padding.medium) {
                HStack {
                    Text(viewStore.model.productCondition.mainConditionTitle)
                        .font(WhoppahTheme.Font.h3)
                        .foregroundColor(WhoppahTheme.Color.base1)
                    Text(product.quality.localized)
                        .font(WhoppahTheme.Font.h3)
                        .foregroundColor(WhoppahTheme.Color.alert3)
                    Spacer()
                }
                if let description = viewStore.model.productCondition.descriptions[product.quality] {
                    Text(description)
                        .font(WhoppahTheme.Font.subtitle)
                        .foregroundColor(WhoppahTheme.Color.base1)
                }
            }
            .padding(.all, WhoppahTheme.Size.Padding.medium)
        }
    }
}

struct ProductConditionView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        ProductConditionView(store: store, product: .random)
    }
}
