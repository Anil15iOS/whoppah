//
//  SellerInfoView.swift
//  
//
//  Created by Marko Stojkovic on 15.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct SellerInfoView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if let merchantId = viewStore.state.user()?.merchantId,
               let productSellerId = viewStore.model.product?.merchant.id,
               merchantId == productSellerId
            {
                HStack(spacing: WhoppahTheme.Size.Padding.medium) {
                    Image("information_icon", bundle: .module)
                    Text(viewStore.model.productTitle.sellerInfo)
                        .font(WhoppahTheme.Font.body)
                        .foregroundColor(WhoppahTheme.Color.alert3.opacity(0.87))
                    Spacer()
                }
                .padding([.leading, .top, .bottom], WhoppahTheme.Size.Padding.medium)
                .background(WhoppahTheme.Color.base7)
                .cornerRadius(WhoppahTheme.Size.Radius.smaller)
                .padding(.top, WhoppahTheme.Size.Padding.small)
            } else {
                EmptyView()
            }
        }
    }
}

struct SellerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        SellerInfoView(store: store)
    }
}
