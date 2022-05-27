//
//  SellerBoostView.swift
//  
//
//  Created by Marko Stojkovic on 14.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture

struct SellerBoostView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading,
                   spacing: WhoppahTheme.Size.Padding.extraMedium) {
                HStack(spacing: WhoppahTheme.Size.Padding.superMedium) {
                    Image("thunder", bundle: .module)
                        .padding(.bottom, WhoppahTheme.Size.Padding.extraLarge)
                    VStack(alignment: .leading,
                           spacing: WhoppahTheme.Size.Padding.tiniest) {
                        
                        Text(viewStore.model.sellerBoost.boostAdTitle)
                            .font(WhoppahTheme.Font.paragraphBold)
                            .foregroundColor(WhoppahTheme.Color.alert2)
                        
                        if let adComponents = viewStore.model.sellerBoost.adComponents, adComponents.count == 2 {
                            Text(viewStore.model.sellerBoost.adComponents[0] + " ")
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base1)
                            +
                            Text(viewStore.model.sellerBoost.currency +
                                 viewStore.model.sellerBoost.adPrice + " ")
                            .font(WhoppahTheme.Font.bodyBold)
                            .foregroundColor(WhoppahTheme.Color.base1)
                            +
                            Text(viewStore.model.sellerBoost.adComponents[1])
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base1)
                        }
                    }
                }
                .padding(.leading, WhoppahTheme.Size.Padding.smaller)
                .padding(.trailing, WhoppahTheme.Size.Padding.medium)
                
                CallToAction(backgroundColor: WhoppahTheme.Color.alert2,
                             foregroundColor: Color.white,
                             iconName: nil,
                             title: viewStore.model.sellerBoost.boostAdTitle,
                             showBorder: false) {
                    viewStore.send(.outboundAction(.didTapBoostAd))
                }
            }
            .padding(.all, WhoppahTheme.Size.Padding.medium)
            .background(WhoppahTheme.Color.support2)
            .cornerRadius(WhoppahTheme.Size.CTA.cornerRadius)
            .padding(WhoppahTheme.Size.Padding.medium)
        }
    }
}

struct SellerBoostView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        SellerBoostView(store: store)
    }
}
