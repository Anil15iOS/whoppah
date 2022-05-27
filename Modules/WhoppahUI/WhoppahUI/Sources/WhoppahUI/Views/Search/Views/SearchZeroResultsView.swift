//
//  SearchZeroResultsView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 04/04/2022.
//

import SwiftUI
import ComposableArchitecture

struct SearchZeroResultsView: View {
    @EnvironmentObject private var filterSettings: SearchFilterSettings
    @State private var saveSearchIsShowingProgress: Bool = false
    
    private let store: Store<SearchView.ViewState, SearchView.Action>
    
    init(store: Store<SearchView.ViewState, SearchView.Action>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Spacer()
                WhoppahTheme.Color.alert3.mask(
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .rotation3DEffect(.degrees(180),
                                          axis: (x: 0, y: 1, z: 0))
                        .frame(width: WhoppahTheme.Size.Search.noResultsIconSize,
                               height: WhoppahTheme.Size.Search.noResultsIconSize)
                )
                .frame(width: WhoppahTheme.Size.Search.noResultsIconSize,
                       height: WhoppahTheme.Size.Search.noResultsIconSize)
                
                Text(viewStore.state.model.noResults.noResults(filterSettings.searchFilterString))
                    .font(WhoppahTheme.Font.h2)
                    .foregroundColor(WhoppahTheme.Color.base1)
                    .multilineTextAlignment(.center)
                
                Spacer()
                /*
                 
                 Disabled for now, waiting for a backend implementation.
                 
                CallToAction(backgroundColor: viewStore.saveSearchState.color,
                             foregroundColor: WhoppahTheme.Color.base4,
                             iconName: viewStore.saveSearchState.iconName,
                             title: viewStore.state.model.noResults.notifyMeTitle,
                             showBorder: false,
                             showingProgress: $saveSearchIsShowingProgress) {
                    withAnimation {
                        saveSearchIsShowingProgress = true
                    }
                    viewStore.send(.didTapSaveSearch(input: filterSettings.asInput))
                }
                .disabled(viewStore.saveSearchState.disablesButton)
                 */
            }
            .padding(.bottom, WhoppahTheme.Size.Padding.medium)
            .onReceive(viewStore.publisher.saveSearchState) { saveSearchState in
                guard saveSearchState != .saving else { return }
                
                withAnimation {
                    saveSearchIsShowingProgress = false
                }
            }
        }
    }
}

struct SearchZeroResultsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: SearchView.Reducer().reducer,
                      environment: .mock)
        
        SearchZeroResultsView(store: store)
    }
}
