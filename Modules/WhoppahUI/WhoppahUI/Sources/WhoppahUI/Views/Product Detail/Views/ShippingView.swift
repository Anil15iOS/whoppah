//
//  ShippingView.swift
//  WhoppahUI
//
//  Created by Marko Stojkovic on 22.3.22..
//

import Foundation
import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct ShippingView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    private let product: WhoppahModel.Product
    private let userLocale: String
    @State private var selectedShippingCountry: WhoppahModel.ShippingMethodCountryPrice = .init(country: "NL", price: .init(amount: 0, currency: .eur))

    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>,
                product: WhoppahModel.Product) {
        self.store = store
        self.product = product
        self.userLocale = Locale.current.regionCode?.uppercased() ?? "NL"
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: WhoppahTheme.Size.Padding.medium) {
                HStack(spacing: WhoppahTheme.Size.Padding.smaller) {
                    Text(viewStore.model.shippingInfo.shippingTitle)
                        .font(WhoppahTheme.Font.h3)
                        .foregroundColor(WhoppahTheme.Color.base1)
                    
                    Menu {
                        Text(viewStore.model.shippingInfo.shippingInfoTooltip)
                            .padding(WhoppahTheme.Size.Padding.small)
                            .background(WhoppahTheme.Color.base1.opacity(0.5))
                            .foregroundColor(WhoppahTheme.Color.base4)
                            .font(WhoppahTheme.Font.caption)
                    } label: {
                        Image("question_info", bundle: .module)
                    }
                    
                    Spacer()
                }.padding(.top, WhoppahTheme.Size.Padding.small)
                
                ZStack {
                    RoundedRectangle(cornerRadius: WhoppahTheme.Size.CTA.cornerRadius)
                        .fill(Color.white)
                    RoundedRectangle(cornerRadius: WhoppahTheme.Size.Radius.small)
                        .stroke(WhoppahTheme.Color.base10, lineWidth: 1)
                    HStack(spacing: 0) {
                        Text("\(viewStore.model.shippingInfo.shippingToTitle): ")
                            .font(WhoppahTheme.Font.subtitle)
                            .foregroundColor(WhoppahTheme.Color.base2)
                            .padding(.vertical, WhoppahTheme.Size.Padding.mediumSmall)
                            .padding(.leading, WhoppahTheme.Size.Padding.mediumSmall)
                            .padding(.trailing, 0)

                        ZStack(alignment: .center) {
                            HStack {
                                Spacer()
                                Image("dropdown", bundle: .module)
                                    .padding(.trailing, WhoppahTheme.Size.Padding.mediumSmall)
                            }
                            
                            Menu {
                                ForEach(product.shippingMethodPrices, id: \.self) { shippingMethodPrice in
                                    Button {
                                        selectedShippingCountry = shippingMethodPrice
                                    } label: {
                                        Text(shippingMethodPrice.localize(\.country))
                                            .font(WhoppahTheme.Font.body)
                                            .foregroundColor(WhoppahTheme.Color.base1)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.all, 0)
                                    .frame(maxWidth: .infinity,
                                           maxHeight: .infinity)
                                }
                            } label: {
                                Text(selectedShippingCountry.localize(\.country))
                                    .frame(maxWidth: .infinity,
                                           maxHeight: .infinity,
                                           alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accentColor(WhoppahTheme.Color.base1)
                        }
                    }
                }
                
                VStack(alignment: .leading,
                       spacing: WhoppahTheme.Size.Padding.smaller) {
                    if let selectedShippingCountry = selectedShippingCountry {
                        HStack {
                            Text(viewStore.model.shippingInfo.shipping)
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base1)
                            Spacer()
                            Text(selectedShippingCountry.price.formattedString)
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base1)
                        }
                        .padding([.top, .bottom], WhoppahTheme.Size.Padding.small)
                    }
                    
                    if product.deliveryMethod == .pickup || product.deliveryMethod == .pickupDelivery {
                        Rectangle()
                            .fill(WhoppahTheme.Color.support7)
                            .frame(height: WhoppahTheme.Size.Rectangle.height)
                        
                        HStack(alignment: .top) {
                            Text("\(viewStore.model.shippingInfo.productPickupTitle) \(product.isInShowroom == true ? viewStore.model.shippingInfo.showroomCity : product.address?.city ?? "")")
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base1)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            Text(viewStore.model.shippingInfo.free)
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base1)
                        }
                        .padding([.top, .bottom], WhoppahTheme.Size.Padding.medium)
                    }
                }
            }
            .padding(.all, WhoppahTheme.Size.Padding.medium)
            .background(WhoppahTheme.Color.base9)
            .cornerRadius(WhoppahTheme.Size.Radius.small)
            .padding(.all, WhoppahTheme.Size.Padding.medium)
            .onAppear {
                if let selected =
                    product.shippingMethodPrices.first(where: { $0.country == userLocale }) ??
                    product.shippingMethodPrices.first(where: { $0.country == "NL" })
                {
                    self.selectedShippingCountry = selected
                }
            }
        }
    }
}

struct ShippingView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                          reducer: ProductDetailView.Reducer().reducer,
                          environment: .mock)

        ShippingView(store: store, product: .random)
    }
}
