//
//  HowWhoppahWorksDetail.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/11/2021.
//

import SwiftUI
import ComposableArchitecture

struct HowWhoppahWorksDetail: View {
    enum NavigationRequest {
        case bookCourier
        case none
    }

    let page: HowWhoppahWorks.Model.Page
    let store: Store<HowWhoppahWorks.ViewState, HowWhoppahWorks.Action>
    
    @State var navigationRequest: NavigationRequest = .none
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    Spacer().frame(height: WhoppahTheme.Size.Padding.medium)
                    Image(page.iconName, bundle: .module)
                    Text(page.longTitle)
                        .font(WhoppahTheme.Font.h2)
                        .padding(.horizontal, WhoppahTheme.Size.Padding.larger)
                        .multilineTextAlignment(.center)
                    ForEach(page.sections, id: \.self) { section in
                        HowWhoppahWorksSection(section: section,
                                               backgroundColor: page.sectionBackgroundColor,
                                               foregroundColor: page.sectionForegroundColor,
                                               navigationRequest: $navigationRequest)
                            .padding(.horizontal, section.ignorePadding ? 0 : WhoppahTheme.Size.Padding.medium)
                            .padding(.vertical, section.ignorePadding ? 0 : WhoppahTheme.Size.Padding.tiny)
                    }
                    Spacer()
                }
                .navigationBarTitle(Text(page.headerTitle), displayMode: .inline)
                .valueChanged(value: $navigationRequest.wrappedValue) { navigationRequest in
                    switch navigationRequest {
                    case .bookCourier:
                        viewStore.send(.outboundAction(.bookCourier))
                    case .none:
                        break
                    }
                }
            }
        }
    }
}

struct HowWhoppahWorksDetail_Previews: PreviewProvider {
    static var previews: some View {
        HowWhoppahWorksDetail(page: HowWhoppahWorks.Model.mock.pages[2],
                              store: Store(initialState: .initial,
                                           reducer: HowWhoppahWorks.Reducer().reducer,
                                           environment: .mock))
    }
}
