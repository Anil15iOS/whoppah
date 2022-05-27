//
//  SoldView.swift
//  
//
//  Created by Marko Stojkovic on 22.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct SoldView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if let soldPrice = viewStore.model.product?.auction?.soldAt {
                VStack(alignment: .center,
                       spacing: WhoppahTheme.Size.Padding.small) {
                    Image("spark_red_medium", bundle: .module)
                        .padding(.top, WhoppahTheme.Size.Padding.extraMedium)
                    Text("\(viewStore.model.soldInfo.title) \(soldPrice.formattedString)")
                    .font(WhoppahTheme.Font.h3)
                    .foregroundColor(WhoppahTheme.Color.base1)
                    Text(viewStore.model.soldInfo.description)
                        .font(WhoppahTheme.Font.body)
                        .foregroundColor(WhoppahTheme.Color.base1)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, WhoppahTheme.Size.Padding.extraMedium)
                }
                .padding([.leading, .trailing], WhoppahTheme.Size.Padding.extraMedium)
                .frame(maxWidth: .infinity)
                .background(WhoppahTheme.Color.support1)
                .cornerRadius(WhoppahTheme.Size.Radius.small)
                .padding([.leading, .trailing, .top], WhoppahTheme.Size.Padding.medium)
            } else {
                EmptyView()
            }
        }
    }
}

struct SoldView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        SoldView(store: store)
    }
}
