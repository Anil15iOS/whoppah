//  
//  SearchView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/03/2022.
//

import SwiftUI
import ComposableArchitecture
import WhoppahModel
import Combine

public struct SearchView: View, StoreInitializable {
    private let store: Store<ViewState, Action>?
    private let loadNewPageThreshold = 5

    @ObservedObject private var filterSettings = SearchFilterSettings()
    
    @State private var showFilterView: Bool = false
    @State private var cancellables = [AnyCancellable]()
    @State private var didSetDefaults: Bool = false
    @State private var currentCategory: WhoppahModel.Category? = nil
    @State private var initialSearchInput: SearchProductsInput?

    var columns: [GridItem] {
        if isIPad {
            return Array(repeating: GridItem(
                .adaptive(
                    minimum: WhoppahTheme.Size.GridItem.minimumSizeIPad,
                    maximum: WhoppahTheme.Size.GridItem.maximumSizeIPad)),
                                            count: 1)
        } else {
            return Array(repeating: GridItem(
                .adaptive(
                    minimum: WhoppahTheme.Size.GridItem.minimumSize,
                    maximum: WhoppahTheme.Size.GridItem.maximumSize)),
                                            count: 1)
        }
    }
    
    var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isLandscapeIPad: Bool {
        guard let orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation,
              orientation == .landscapeLeft || orientation == .landscapeRight
        else { return false }
        
        return isIPad
    }

    public init(store: Store<SearchView.ViewState, SearchView.Action>?) {
        self.store = store
    }
    
    public init(store: Store<SearchView.ViewState, SearchView.Action>?,
                searchInput: SearchProductsInput? = nil) {
        self.init(store: store)
        
        if let searchInput = searchInput {
            self.initialSearchInput = searchInput
        }
    }

    public var body: some View {
        if let store = store {
            WithViewStore(store) { viewStore in
                HStack {
                    //
                    // 🎛 Filters & Sorting (iPad Landscape)
                    //
                    
                    if isLandscapeIPad {
                        if showFilterView {
                            SearchFilterView(
                                store: store,
                                showFilterView: $showFilterView)
                            .frame(width: WhoppahTheme.Size.SearchFilter.maxWidth)
                        }
                    }
                    
                    ZStack {
                        VStack(spacing: WhoppahTheme.Size.Padding.extraMedium) {
                            VStack {
                                ZStack {
                                    Text(currentCategory?.localize(\.title) ?? viewStore.state.model.title)
                                        .font(WhoppahTheme.Font.h3)
                                        .foregroundColor(WhoppahTheme.Color.base1)
                                        .frame(maxWidth: .infinity, alignment: .center)

                                    HStack {
                                        Button {
                                            viewStore.send(.outboundAction(.didTapCloseButton))
                                        } label: {
                                            Image(systemName: "chevron.left")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(WhoppahTheme.Color.base1)
                                                .frame(width: WhoppahTheme.Size.NavBar.backButtonSize,
                                                       height: WhoppahTheme.Size.NavBar.backButtonSize)
                                        }
                                        .padding(WhoppahTheme.Size.Padding.small)
                                        .contentShape(Rectangle())

                                        Spacer()
                                    }
                                }
                                .padding(.vertical, WhoppahTheme.Size.Padding.small)
                                .background(WhoppahTheme.Color.base4)
                                
                                if let queryFilter: SearchFilter<String> = filterSettings.query {
                                    HStack {
                                        
                                        SearchBox(searchText: .init(get: { queryFilter.value },
                                                                    set: { queryFilter.value = $0 }),
                                                  backgroundColor: WhoppahTheme.Color.base4,
                                                  foregroundColor: WhoppahTheme.Color.base2,
                                                  placeholderText: viewStore.state.model.searchPlaceholder)
                                        .onReceive(Just(queryFilter.value)) { _ in
                                            viewStore.send(.trackingAction(.didPerformSearch(query: queryFilter.value)))
                                        }
                                        
                                        Button {
                                            viewStore.send(.didTapShowFiltersButton)
                                            viewStore.send(.trackingAction(.didTapShowFilters))
                                            withAnimation(.easeOut(duration: 0.15)) {
                                                showFilterView.toggle()
                                            }
                                        } label: {
                                            VStack(spacing: 0) {
                                                Spacer()
                                                Image("search_filter_icon", bundle: .module)
                                                Text(viewStore.state.model.filterButtonTitle)
                                                    .font(WhoppahTheme.Font.paragraph)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(WhoppahTheme.Color.base1)
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                                Spacer()
                                            }
                                            .frame(width: WhoppahTheme.Size.TextInput.height,
                                                   height: WhoppahTheme.Size.TextInput.height)
                                        }
                                    }
                                } else {
                                    EmptyView()
                                }
                            }
                            .background(WhoppahTheme.Color.base4)
                            .frame(maxWidth: WhoppahTheme.Size.Form.maxWidth)
                            .transition(.move(edge: .top))

                            if viewStore.state.currentSearchResults.count > 0 {
                                GeometryReader { geom in
                                    ScrollView {
                                        VStack {
                                            if let categories = viewStore.state.visibleSubCategories,
                                               let categoryFilter: SearchFilterMultiSelectable = filterSettings.category
                                            {
                                                SearchCategoryScrollView(categories: categories) { selectedCategory in
                                                    withAnimation {
                                                        self.currentCategory = selectedCategory
                                                    }
                                                    categoryFilter.append(selectedCategory)
                                                    self.filterSettings.currentPageIndex = 1
                                                    viewStore.send(.searchAction(input: filterSettings.asInput,
                                                                                clearCurrentResults: true))
                                                    viewStore.send(.fetchCategories(bySlug: selectedCategory.slug))
                                                }
                                                .transition(.move(edge: .trailing))
                                            } else {
                                                Spacer()
                                                    .frame(height: WhoppahTheme.Size.Padding.medium)
                                            }
                                        }
                                        
                                        SearchFilterDismissibleFilterLabels(filtersModel: viewStore.state.model.filters)
                                        
                                        LazyVGrid(columns: columns, alignment: .center) {
                                            ForEach(viewStore.state.currentSearchResults) { item in
                                                ProductTile(
                                                    searchItem: item,
                                                    onRemoveFavorite: { productId, favorite in
                                                        viewStore.send(
                                                            .removeFavorite(productId: productId,
                                                                            favorite: favorite))
                                                    }, onCreateFavorite: { productId in
                                                        viewStore.send(
                                                            .createFavorite(productId: productId))
                                                    }, bidFromFormatterClosure: viewStore.model.bidFrom)
                                                    .id(item.id)
                                                    .onTapGesture {
                                                        viewStore.send(.outboundAction(.didSelectProduct(id: item.id)))
                                                        viewStore.send(.trackingAction(.didSelectProduct(id: item)))
                                                    }
                                                    .onAppear {
                                                        loadMoreItemsIfNeeded(viewStore: viewStore,
                                                                              item: item)
                                                    }
                                            }
                                        }
                                        if viewStore.state.searchState == .loading || viewStore.state.loadingState.isLoading {
                                            VStack {
                                                Spacer()
                                                ActivityIndicator(isAnimating: .constant(true),
                                                                  style: .large,
                                                                  color: WhoppahTheme.Color.base1)
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            } else if viewStore.state.loadingState == .finished && viewStore.searchState != .loading {
                                SearchZeroResultsView(store: store)
                            } else {
                                Spacer()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding([.horizontal, .bottom], WhoppahTheme.Size.Padding.medium)
                        .padding(.top, 0)
                        .edgesIgnoringSafeArea(.bottom)
                        
                        //
                        // 🎛 Filters & Sorting (non iPad Landscape)
                        //
                        
                        if !isLandscapeIPad {
                            if showFilterView {
                                SearchFilterView(
                                    store: store,
                                    showFilterView: $showFilterView)
                            }
                        }
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    handleOnAppear(viewStore: viewStore)
                }
                .onReceive(viewStore.publisher.model.filters.sortingOptions) { _ in
                    configureDefaultSortingOption(viewStore: viewStore)
                }
                .onReceive(filterSettings.objectWillChange) { _ in
                    guard viewStore.loadingState == .finished,
                          !filterSettings.isReceivingKeyboardInput
                    else { return }

                    filterSettings.currentPageIndex = 1
                    viewStore.send(.searchAction(input: filterSettings.asInput,
                                                 clearCurrentResults: true))
                    
                    if let categoryFilter: SearchFilterMultiSelectable = filterSettings.category {
                        withAnimation {
                            currentCategory = categoryFilter.items.last as? WhoppahModel.Category
                            if let slug = currentCategory?.slug {
                                viewStore.send(.fetchCategories(bySlug: slug))
                            }
                        }
                    }
                }
                .onReceive(viewStore.publisher.loadingState) { loadingState in
                    guard loadingState == .finished else { return }

                    if let initialSearchInput = initialSearchInput {
                        if let categorySlug = initialSearchInput
                            .filters?
                            .first(where: { $0.key == .category })?
                            .value
                        {
                            withAnimation {
                                currentCategory = findCategory(viewStore.model.filters.categories,
                                                               slug: categorySlug)
                                if let slug = currentCategory?.slug {
                                    viewStore.send(.fetchCategories(bySlug: slug))
                                }
                            }
                            
                            if let currentCategory = currentCategory {
                                let hierarchy = viewStore.state.model.filters
                                    .categoryHierarchy(for: currentCategory)
                                    .sorted { $0.level ?? 0 < $1.level ?? 0 }
                                
                                var filters = initialSearchInput.filters ?? []
                                
                                hierarchy.forEach { category in
                                    if category.slug != currentCategory.slug {
                                        filters.append(.init(key: .category, value: category.slug))
                                    }
                                }
                                
                                self.initialSearchInput = .init(
                                    query: initialSearchInput.query,
                                    pagination: initialSearchInput.pagination,
                                    sort: initialSearchInput.sort,
                                    order: initialSearchInput.order,
                                    facets: initialSearchInput.facets,
                                    filters: filters)
                            }
                            
                        }
                        
                        filterSettings.fromInput(self.initialSearchInput!,
                                                 filterModel: viewStore.state.model.filters)

                        self.initialSearchInput = nil

                        self.filterSettings.currentPageIndex = 1
                        viewStore.send(.searchAction(input: filterSettings.asInput,
                                                     clearCurrentResults: true))
                    }
                }
                .onChange(of: viewStore.state.searchState) { newState in
                    guard newState == .finished && viewStore.state.viewState == .showingSearchResults else { return }
                    
                    withAnimation {
                        if let categoryFilter: SearchFilterMultiSelectable = filterSettings.category {
                            withAnimation {
                                currentCategory = categoryFilter.items.last as? WhoppahModel.Category
                            }
                        }
                    }
                }
            }
            .environmentObject(filterSettings)
        } else {
            EmptyView()
        }
    }
    
    private func loadMoreItemsIfNeeded(viewStore: ViewStore<ViewState, Action>,
                                       item: ProductTileItem)
    {
        guard let searchResultsSet = viewStore.state.latestSearchResultsSet else { return }
        
        let isLoadingNewResults = viewStore.searchState == .loading
        let didRequestNextResultsPage = searchResultsSet.pagination.page != filterSettings.currentPageIndex
        let isSearchPending = isLoadingNewResults || didRequestNextResultsPage
        let morePagesAvailable = searchResultsSet.pagination.page < searchResultsSet.pagination.pages
        
        guard !isSearchPending,
              morePagesAvailable,
              let index = viewStore.state.currentSearchResults.firstIndex(of: item)
        else { return }
        
        if viewStore.state.currentSearchResults.count - index < loadNewPageThreshold
        {
            filterSettings.currentPageIndex = searchResultsSet.pagination.page + 1
            viewStore.send(.searchAction(input: filterSettings.asInput,
                                         clearCurrentResults: false))
            viewStore.send(.trackingAction(.didScrollSearch(page: filterSettings.currentPageIndex)))
        }
    }
    
    private func handleOnAppear(viewStore: ViewStore<ViewState, Action>) {
        if viewStore.loadingState == .uninitialized {
            viewStore.send(.loadContent)
        } else if let _ = viewStore.currentlySelectedProduct {
            viewStore.send(.fetchUserFavorites)
        }
    }
    
    private func configureDefaultSortingOption(viewStore: ViewStore<ViewState, Action>) {
        if !didSetDefaults,
           let sortingOption = viewStore.model.filters.sortingOptions.first
        {
            filterSettings.sortingOption = sortingOption
            didSetDefaults = true
        }
    }
    
    private func findCategory(_ categories: [WhoppahModel.Category],
                              slug: String) -> WhoppahModel.Category?
    {
        for i in 0..<categories.count {
            let category = categories[i]
            if category.slug == slug {
                return category
            }
            
            if let children = category.children {
                if let foundCategory = findCategory(children, slug: slug) {
                    return foundCategory
                }
            }
        }
        
        return nil
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
            let store = Store(initialState: .initial,
                          reducer: SearchView.Reducer().reducer,
                          environment: .mock)
        
        SearchView(store: store)
    }
}
