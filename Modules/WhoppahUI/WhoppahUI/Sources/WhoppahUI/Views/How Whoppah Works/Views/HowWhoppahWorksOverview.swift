//
//  HowWhoppahWorksOverview.swift
//  
//
//  Created by Dennis Ippel on 08/11/2021.
//

import SwiftUI
import ComposableArchitecture

struct HowWhoppahWorksOverview: View {
    let title: String
    let pages: [HowWhoppahWorks.Model.Page]
    let store: Store<HowWhoppahWorks.ViewState, HowWhoppahWorks.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 16) {
                Spacer().frame(height: 1)
                ForEach(pages, id: \.self) { page in
                    NavigationLink(destination: HowWhoppahWorksDetail(page: page, store: store)
                                    .onAppear { track(pageId: page.pageId, store: viewStore)}
                    ) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(WhoppahTheme.Color.base3)
                            HStack {
                                Text(page.overviewTitle)
                                    .font(WhoppahTheme.Font.button)
                                    .foregroundColor(WhoppahTheme.Color.base1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(page.overviewIconName, bundle: .module)
                                    .frame(alignment: .trailing)
                            }
                            .padding(.all, 24)
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .frame(height: 85)
                }
                Spacer()
            }
            .navigationBarTitle(Text(title), displayMode: .inline)
        }
    }
    
    private func track(pageId: String, store: ViewStore<HowWhoppahWorks.ViewState, HowWhoppahWorks.Action>) {
        switch pageId {
        case "payments":            store.send(.trackingAction(.didSelectPayments))
        case "shipping_delivery":   store.send(.trackingAction(.didSelectShippingAndDelivery))
        case "bidding":             store.send(.trackingAction(.didSelectBidding))
        case "curation":            store.send(.trackingAction(.didSelectCuration))
        case "faqs":                store.send(.trackingAction(.didSelectFAQ))
        default:                    break
        }
    }
}

struct HowWhoppahWorksOverview_Previews: PreviewProvider {
    static var previews: some View {
        HowWhoppahWorksOverview(title: HowWhoppahWorks.Model.mock.title,
                                pages: HowWhoppahWorks.Model.mock.pages,
                                store: Store(initialState: .initial,
                                             reducer: HowWhoppahWorks.Reducer().reducer,
                                             environment: .mock))
    }
}
