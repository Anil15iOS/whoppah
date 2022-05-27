//
//  UpdateAppDialog.swift
//  
//
//  Created by Dennis Ippel on 16/11/2021.
//

import SwiftUI
import ComposableArchitecture

public struct UpdateAppDialog: View, StoreInitializable {
    let store: Store<UpdateAppDialog.ViewState, UpdateAppDialog.Action>?
    
    public init(store: Store<UpdateAppDialog.ViewState, UpdateAppDialog.Action>?) {
        self.store = store
    }
    
    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                ModalDialog(title: viewStore.model.title,
                            description: viewStore.model.description)
                {
                    viewStore.send(.outboundAction(.closeDialog))
                } content: {
                    CallToAction(backgroundColor: WhoppahTheme.Color.alert2,
                                 foregroundColor: WhoppahTheme.Color.base4,
                                 iconName: nil,
                                 title: viewStore.model.ctaTitle,
                                 showBorder: false)
                    {
                        viewStore.send(.outboundAction(.updateAppNow))
                    }
                }
                .onAppear {
                    viewStore.send(.loadContent)
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct UpdateAppDialog_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAppDialog(store: Store(initialState: .initial,
                                     reducer: UpdateAppDialog.Reducer().reducer,
                                     environment: .mock))
    }
}
