//
//  ProductDetailBuyerProtectionView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/05/2022.
//

import SwiftUI
import ComposableArchitecture

struct ProductDetailBuyerProtectionView: View {
    private enum Action {
        case didTapReadMore
    }
    
    private let viewStore: ViewStore<ProductDetailView.ViewState, ProductDetailView.Action>
    private var stringsWithActions = [StringWithOptionalAction<Action>]()
    
    @Binding private var presentPopup: Bool
    @Binding private var popupContent: ModalPopupContent
    
    public init(viewStore: ViewStore<ProductDetailView.ViewState, ProductDetailView.Action>,
                popupContent: Binding<ModalPopupContent>,
                showPopup: Binding<Bool>)
    {
        self.viewStore = viewStore
        self._popupContent = popupContent
        self._presentPopup = showPopup
        
        viewStore.model.buyerProtection.description.components(separatedBy: " ").forEach { word in
            stringsWithActions.append(.init(text: "\(word) ", action: nil))
        }
        stringsWithActions.append(.init(text: viewStore.model.buyerProtection.moreInformationButtonTitle, action: .didTapReadMore))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: WhoppahTheme.Size.Padding.medium) {
            HStack {
                Image("buyer_protection_spark", bundle: .module)

                Text(viewStore.model.buyerProtection.title)
                    .font(WhoppahTheme.Font.h3)
                    .foregroundColor(WhoppahTheme.Color.BuyerProtection.foreground)
                    .padding(.vertical, WhoppahTheme.Size.Padding.small)
                
                Spacer()
            }
            
            StringsWithOptionalActionsFlowLayout(stringsWithActions,
                                                 textColor: WhoppahTheme.Color.base1,
                                                 actionColor: WhoppahTheme.Color.alert2,
                                                 font: WhoppahTheme.Font.paragraph) { action in
                switch action {
                case .didTapReadMore:
                    withAnimation(.linear(duration: 0.2)) {
                        popupContent = viewStore.model.buyerProtection.buyerProtectionInfo
                        presentPopup.toggle()
                    }
                }
            }
        }
        .padding(.all, WhoppahTheme.Size.Padding.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(
                cornerRadius: WhoppahTheme.Size.Radius.small)
                .strokeBorder(WhoppahTheme.Color.BuyerProtection.border, lineWidth: 1)
                .background(WhoppahTheme.Color.BuyerProtection.background))
        .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
    }
}

struct ProductDetailBuyerProtectionView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)
        ProductDetailBuyerProtectionView(viewStore: ViewStore(store),
                                         popupContent: .constant(.initial),
                                         showPopup: .constant(false))
    }
}
