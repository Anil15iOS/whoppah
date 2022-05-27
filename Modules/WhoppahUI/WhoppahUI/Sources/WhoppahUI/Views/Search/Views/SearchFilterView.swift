//
//  SearchFilterView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 22/03/2022.
//

import SwiftUI
import ComposableArchitecture
import WhoppahModel

struct SearchFilterView: View {
    private let store: Store<SearchView.ViewState, SearchView.Action>
    
    @Binding private var showFilterView: Bool
    @EnvironmentObject var filterSettings: SearchFilterSettings
    @State private var footerSize: CGSize = .zero
    @State private var keyboardHeight: CGFloat = 0
    @State private var searchResultsButtonTitle: String = ""
    @State private var buttonIsShowingProgress = false
    
    init(store: Store<SearchView.ViewState, SearchView.Action>,
         showFilterView: Binding<Bool>)
    {
        self.store = store
        self._showFilterView = showFilterView
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Button {
                        viewStore.send(.didTapCloseFiltersButton)
                        withAnimation(.easeOut(duration: 0.15)) { showFilterView = false }
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: WhoppahTheme.Size.Menu.itemHeight / 2,
                                   height: WhoppahTheme.Size.Menu.itemHeight / 2)
                    }
                    .padding(.trailing, WhoppahTheme.Size.Padding.extraMedium)
                    
                    Text(viewStore.state.model.filters.title)
                        .font(WhoppahTheme.Font.h1)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
                .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            filterSettings.reset(viewStore.state.model.filters.sortingOptions.first)
                        }
                    } label: {
                        Text(viewStore.state.model.filters.resetFiltersTitle)
                            .font(WhoppahTheme.Font.caption)
                            .foregroundColor(WhoppahTheme.Color.alert3)
                    }
                    .frame(alignment: .trailing)
                }
                .padding(.horizontal, WhoppahTheme.Size.Padding.medium)
                
                KeyboardEnabledView(doneButtonTitle: viewStore.state.model.filters.doneButtonTitle) {
                    
                    VStack {
                        SearchFilterViewFilters(store: store,
                                                footerSize: footerSize.height)
                    }
                        
                    //
                    // 📙 Sticky footer button
                    //
                    
                    StickyFooter {
                        CallToAction(backgroundColor: WhoppahTheme.Color.alert3,
                                     foregroundColor: WhoppahTheme.Color.base4,
                                     title: searchResultsButtonTitle,
                                     showBorder: false,
                                     showingProgress: $buttonIsShowingProgress) {
                            guard !buttonIsShowingProgress else { return }
                            
                            viewStore.send(.didTapShowResultsButton)

                            withAnimation(.easeOut(duration: 0.15)) {
                                showFilterView = false
                            }
                        }
                    } onSizeChange: { newSize in
                        footerSize = newSize
                    }
                } keyboardSizeDidChange: { keyboardHeight in
                    self.keyboardHeight = keyboardHeight
                }
            }
            .background(WhoppahTheme.Color.base4)
            .transition(.move(edge: .bottom))
            .zIndex(12)
            .onReceive(viewStore.publisher.searchState, perform: { state in
                let count = viewStore.state.latestSearchFacetsSet.count
                withAnimation {
                    buttonIsShowingProgress = viewStore.state.searchState == .loading
                    searchResultsButtonTitle = viewStore.state.model.filters.showResultsTitle(count)
                }
            })
        }
    }
}

struct SearchFilterView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: SearchView.Reducer().reducer,
                      environment: .mock)
        
        SearchFilterView(store: store, showFilterView: .constant(true))
    }
}
