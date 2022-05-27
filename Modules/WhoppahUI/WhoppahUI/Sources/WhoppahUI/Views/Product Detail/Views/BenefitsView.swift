//
//  BenefitsView.swift
//  WhoppahUI
//
//  Created by Marko Stojkovic on 17.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture

struct BenefitsView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    @Binding private var presentPopup: Bool
    @Binding private var popupContent: ModalPopupContent
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                popupContent: Binding<ModalPopupContent>,
                showPopup: Binding<Bool>) {
        self.store = store
        self._popupContent = popupContent
        self._presentPopup = showPopup
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            
            VStack(alignment: .leading,
                   spacing: WhoppahTheme.Size.Padding.medium) {
                HStack(spacing: WhoppahTheme.Size.Padding.extraMedium) {
                    Image("sustainable_shopping_icon", bundle: .module)
                    Text(viewStore.model.benefits.sustainableShopping)
                        .font(WhoppahTheme.Font.subtitle)
                        .foregroundColor(WhoppahTheme.Color.base1)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
                HStack(spacing: WhoppahTheme.Size.Padding.extraMedium) {
                    Image("benefits_spark", bundle: .module)
                    Text(viewStore.model.benefits.itemsCurated)
                        .font(WhoppahTheme.Font.subtitle)
                        .foregroundColor(WhoppahTheme.Color.base1)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
                HStack(spacing: WhoppahTheme.Size.Padding.extraMedium) {
                    Image("benefits_delivery", bundle: .module)
                    Text(viewStore.model.benefits.delivered)
                        .font(WhoppahTheme.Font.subtitle)
                        .foregroundColor(WhoppahTheme.Color.base1)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
            }
            .padding(.all, WhoppahTheme.Size.Padding.medium)
            .frame(maxWidth: .infinity)
            .background(WhoppahTheme.Color.support2)
            .cornerRadius(WhoppahTheme.Size.Radius.small)
            .padding([.leading, .trailing, .bottom], WhoppahTheme.Size.Padding.medium)
        }
    }
}

struct BenefitsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)
        BenefitsView(store: store,
                     popupContent: .constant(.initial),
                     showPopup: .constant(false))
    }
}
