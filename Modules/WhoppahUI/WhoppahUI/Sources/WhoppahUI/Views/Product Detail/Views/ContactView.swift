//
//  SwiftUIView.swift
//  
//
//  Created by Marko Stojkovic on 11.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture

struct ContactView: View {
    
    private let store: Store<ProductDetailView.ViewState, ProductDetailView.Action>
    private var contactComponents: [String]?
    
    public init(store: Store<ProductDetailView.ViewState, ProductDetailView.Action>) {
        self.store = store
        
        let viewStore = ViewStore(store)
        
        contactComponents = viewStore.model.contactSupport.contactComponents
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading,
                   spacing: WhoppahTheme.Size.Padding.small) {
                HStack {
                    Image("spark_red", bundle: .module)
                    Spacer()
                }.padding(.bottom, WhoppahTheme.Size.Padding.small)
                
                Text(viewStore.model.contactSupport.title)
                    .foregroundColor(WhoppahTheme.Color.base6)
                    .font(WhoppahTheme.Font.h3)
                
                if let contactComponents = contactComponents, contactComponents.count == 3 {
                    VStack(alignment: .leading) {
                        Text(contactComponents[0] + " ")
                            .font(WhoppahTheme.Font.body)
                        
                        Text(contactComponents[1] + " ")
                            .font(WhoppahTheme.Font.h4)
                            .foregroundColor(WhoppahTheme.Color.base6)
                            .onTapGesture {
                                let phoneNumber = viewStore.model.contactSupport.phoneNumber
                                viewStore.send(.outboundAction(.didTapCallNumber(phoneNumber: phoneNumber)))
                            }
                        
                        Text(contactComponents[2])
                            .foregroundColor(WhoppahTheme.Color.primary4)
                            .font(WhoppahTheme.Font.body)
                            .onTapGesture {
                                let email = viewStore.model.contactSupport.supportEmail
                                viewStore.send(.outboundAction(.didTapContactSupport(email: email,
                                                                                     subject: "",
                                                                                     body: "")))
                            }
                    }
                }
            }
            .padding(EdgeInsets(top: WhoppahTheme.Size.Padding.regularMedium,
                                       leading: WhoppahTheme.Size.Padding.medium,
                                       bottom: WhoppahTheme.Size.Padding.extraMedium,
                                       trailing: WhoppahTheme.Size.Padding.medium))
            .background(WhoppahTheme.Color.support6)
            .cornerRadius(WhoppahTheme.Size.CTA.cornerRadius)
            .padding(WhoppahTheme.Size.Padding.medium)
        }
    }
}
