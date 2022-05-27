//  
//  WhoppahReviews.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/12/2021.
//

import SwiftUI
import ComposableArchitecture

public struct WhoppahReviews: View, StoreInitializable {
    let store: Store<WhoppahReviews.ViewState, WhoppahReviews.Action>?

    public init(store: Store<WhoppahReviews.ViewState, WhoppahReviews.Action>?) {
        self.store = store
        
        if let store = store {
            let viewStore = ViewStore(store)
            viewStore.send(.loadContent)
        }
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                ScrollView {
                    VStack {
                        Group {
                            Text(viewStore.state.model.title)
                                .font(WhoppahTheme.Font.h2)
                                .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                                .multilineTextAlignment(.center)

                            Spacer().frame(height: WhoppahTheme.Size.Padding.medium)
                            
                            Text(viewStore.state.model.description)
                                .font(WhoppahTheme.Font.paragraph)
                                .lineSpacing(WhoppahTheme.Size.Paragraph.lineSpacing)
                                .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        ForEach(viewStore.state.model.reviews, id: \.self) { review in
                            ReviewItem(review: review)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, WhoppahTheme.Size.Padding.medium)
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct WhoppahReviews_Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: WhoppahReviews.Reducer().reducer,
                          environment: .init(localizationClient: WhoppahReviews.mockLocalizationClient,
                                             trackingClient: WhoppahReviews.mockTrackingClient,
                                             outboundActionClient: WhoppahReviews.mockOutboundActionClient,
                                             mainQueue: .main))
        
        WhoppahReviews(store: store)
    }
}
