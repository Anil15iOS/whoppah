//
//  ReservedView.swift
//  
//
//  Created by Marko Stojkovic on 13.4.22..
//

import SwiftUI
import Combine
import ComposableArchitecture

struct ReservedView: View {
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.model.product?.auction?.state == .reserved {
                VStack(alignment: .center,
                       spacing: WhoppahTheme.Size.Padding.small) {
                    Image("spark_red_medium", bundle: .module)
                        .padding(.top, WhoppahTheme.Size.Padding.extraMedium)
                    Text(viewStore.model.reservedInfo.title)
                    .font(WhoppahTheme.Font.h3)
                    .foregroundColor(WhoppahTheme.Color.base1)
                    Text(viewStore.model.reservedInfo.description)
                        .font(WhoppahTheme.Font.body)
                        .foregroundColor(WhoppahTheme.Color.base1)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, WhoppahTheme.Size.Padding.large)
                }
                .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                .frame(maxWidth: .infinity)
                .background(WhoppahTheme.Color.support6)
                .cornerRadius(WhoppahTheme.Size.Radius.small)
                .padding([.leading, .trailing, .top], WhoppahTheme.Size.Padding.medium)
            } else {
                EmptyView()
            }
        }
    }
}

struct ReservedView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        ReservedView(store: store)
    }
}
