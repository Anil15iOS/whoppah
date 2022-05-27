//
//  SearchFilterViewFilters.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import SwiftUI
import ComposableArchitecture
import WhoppahModel

struct SearchFilterViewFilters: View {
    typealias SearchResult = SearchView.Model.SearchFacetsSet.SearchResult
    
    @EnvironmentObject var filterSettings: SearchFilterSettings
    @State private var brandSearch: String = .empty
    // These are @State vars so we can enable animation
    @State private var categories = [SearchResult<WhoppahModel.Category>]()
    @State private var colors = [SearchResult<WhoppahModel.Color>]()
    @State private var materials = [SearchResult<WhoppahModel.Material>]()
    @State private var locations = [SearchResult<WhoppahModel.Country>]()
    @State private var styles = [SearchResult<WhoppahModel.Style>]()
    @State private var brands = [SearchResult<WhoppahModel.Brand>]()
    
    @State private var isReceivingKeyboardInput: Bool = false {
        didSet { filterSettings.isReceivingKeyboardInput = isReceivingKeyboardInput }
    }
    @State private var elementToScrollTo: FilterElement? = nil
    
    private enum FilterElement {
        case other
        case sortBy
        case category
        case price
        case dimensions
        case color
        case condition
        case brand
        case material
        case location
        case style
    }
    
    private let store: Store<SearchView.ViewState, SearchView.Action>
    private let viewStore: ViewStore<SearchView.ViewState, SearchView.Action>
    private let maxNumberOfVisibleFiltersItems: Int = 10
    private let footerSize: CGFloat
    
    var brandSearchResults: [SearchResult<WhoppahModel.Brand>] {
        if brandSearch.isEmpty {
            return brands.firstNumberOfElements(maxNumberOfVisibleFiltersItems)
        } else {
            let filteredBrands = viewStore.state.latestSearchFacetsSet.brands.filter { $0.value.title.lowercased().contains(brandSearch.lowercased()) }
            return filteredBrands.firstNumberOfElements(maxNumberOfVisibleFiltersItems)
        }
    }
    
    var filterModel: SearchView.Model.Filters {
        viewStore.state.model.filters
    }
    
    init(store: Store<SearchView.ViewState, SearchView.Action>,
         footerSize: CGFloat) {
        self.store = store
        self.viewStore = ViewStore(store)
        self.footerSize = footerSize
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollViewReader { scrollViewValue in
                VStack {
                    Group {
                        
                        //
                        // ✔️ Properties Filter
                        //
                        
                        if let otherOptions: SearchFilterMultiSelectable = filterSettings.other {
                            FlowLayout(mode: .scrollable,
                                       binding: .constant(3),
                                       items: filterModel.propertyOptions) { propertyOption, _ in
                                SearchFilterButton(propertyOption.title,
                                                   value: propertyOption,
                                                   isSelected: otherOptions.contains(propertyOption),
                                                   style: .multiSelect) { selectedPropertyOption in
                                    if otherOptions.contains(selectedPropertyOption) {
                                        otherOptions.remove(selectedPropertyOption)
                                    } else {
                                        otherOptions.append(selectedPropertyOption)
                                    }
                                }
                            }
                            .id(FilterElement.other)
                            .disabled(isReceivingKeyboardInput)
                        }
                        
                        //
                        // ↕️ Sort Filter
                        //
                        
                        CollapsableFilter(title: filterModel.sortTitle) {
                            FlowLayout(mode: .scrollable,
                                       binding: .constant(3),
                                       items: filterModel.sortingOptions) { sortingOption, _ in
                                SearchFilterButton(sortingOption.title,
                                                   value: sortingOption,
                                                   isSelected: filterSettings.sortingOption == sortingOption) { selectedSortingOption in
                                    self.filterSettings.sortingOption = selectedSortingOption
                                    viewStore.send(.trackingAction(.didTapSort(type: selectedSortingOption.sortType,
                                                                               order: selectedSortingOption.sortOrder)))
                                }
                            }
                        }
                        .id(FilterElement.sortBy)
                        .disabled(isReceivingKeyboardInput)
                        
                        //
                        // 🗄 Categories Filter
                        //
                        
                        CategoriesFilterView(title: filterModel.categoryTitle,
                                             categories: categories)
                        .id(FilterElement.category)
                        .disabled(isReceivingKeyboardInput)
                        
                        //
                        // 💰 Price Filter
                        //

                        if let price: SearchFilter<SearchFilterMinMaxValue> = filterSettings.price {
                            CollapsableFilter(title: filterModel.priceTitle) {
                                HStack(spacing: WhoppahTheme.Size.Padding.medium) {
                                    SearchFilterTextInput(placeholderText: filterModel.minPlaceholder,
                                                          value: .init(get: { price.value.min },
                                                                       set: { price.value.min = $0 }))
                                    .keyboardType(.numberPad)

                                    SearchFilterTextInput(placeholderText: filterModel.maxPlaceholder,
                                                          value: .init(get: { price.value.max },
                                                                       set: { price.value.max = $0 }))
                                    .keyboardType(.numberPad)
                                }
                            }
                            .id(FilterElement.price)
                            .onTapGesture {
                                self.elementToScrollTo = FilterElement.price
                            }
                        }
                        
                        //
                        // 📐 Dimensions Filter
                        //
                        
                        CollapsableFilter(title: filterModel.dimensionsTitle) {
                            DimensionsFilterView(filtersModel: filterModel)
                        }
                        .id(FilterElement.dimensions)
                        .onTapGesture {
                            self.elementToScrollTo = FilterElement.dimensions
                        }
                        
                        //
                        // 🎨 Color Filter
                        //

                        if let colorFilter: SearchFilterMultiSelectable = filterSettings.color,
                           colors.count > 0
                        {
                            CollapsableFilter(title: filterModel.colorTitle) {
                                FlowLayout(mode: .scrollable,
                                           binding: .constant(3),
                                           items: colors) { color, _ in
                                    SearchFilterColor(color: color.value,
                                                      isSelected: colorFilter.contains(color.value)) { selectedColor in
                                        if colorFilter.contains(selectedColor) {
                                            colorFilter.remove(selectedColor)
                                        } else {
                                            colorFilter.append(selectedColor)
                                        }
                                    }
                                }
                            }
                            .id(FilterElement.color)
                            .disabled(isReceivingKeyboardInput)
                        }
                        
                        //
                        // 🛋 Condition Filter
                        //
                        
                        CollapsableFilter(title: filterModel.conditionTitle) {
                            HStack(spacing: WhoppahTheme.Size.Padding.medium) {
                                ForEach(filterModel.conditionOptions) { conditionOption in
                                    SearchFilterConditionButton(option: conditionOption,
                                                                isSelected: filterSettings.conditionOption == conditionOption) { selectedOption in
                                        if filterSettings.conditionOption == selectedOption {
                                            filterSettings.conditionOption = nil
                                        } else {
                                            filterSettings.conditionOption = selectedOption
                                        }
                                    }
                                }
                            }
                            .id(FilterElement.condition)
                            .disabled(isReceivingKeyboardInput)
                        }
                    }
                    
                    Group {

                        //
                        //  🏤 Brand Filter
                        //

                        if let brandsFilter: SearchFilterMultiSelectable = filterSettings.brand,
                           brands.count > 0
                        {
                            CollapsableFilter(title: filterModel.brandTitle) {
                                VStack {
                                    SearchBox(searchText: $brandSearch,
                                              backgroundColor: WhoppahTheme.Color.base4,
                                              foregroundColor: WhoppahTheme.Color.base2,
                                              placeholderText: filterModel.brandPlaceholder)
                                    .padding(.bottom, WhoppahTheme.Size.Padding.medium)

                                    FlowLayout(mode: .scrollable,
                                               binding: .constant(3),
                                               items: brandSearchResults) { brand, _ in
                                        SearchFilterButton("\(brand.value.title) (\(brand.count))",
                                                           value: brand.value,
                                                           isSelected: brandsFilter.contains(brand.value),
                                                           style: .multiSelect) { selectedBrand in
                                            if brandsFilter.contains(selectedBrand) {
                                                brandsFilter.remove(selectedBrand)
                                            } else {
                                                brandsFilter.append(selectedBrand)
                                            }
                                        }
                                    }
                                }
                            }
                            .id(FilterElement.brand)
                            .disabled(isReceivingKeyboardInput)
                        }

                        //
                        // 🧱 Material Filter
                        //

                        if let materialsFilter: SearchFilterMultiSelectable = filterSettings.material,
                           materials.count > 0
                        {
                            CollapsableFilter(title: filterModel.materialTitle) {
                                FlowLayout(mode: .scrollable,
                                           binding: .constant(3),
                                           items: materials) { material, _ in
                                    SearchFilterButton("\(material.value.localize(\.title)) (\(material.count))",
                                                       value: material.value,
                                                       isSelected: materialsFilter.contains(material.value),
                                                       style: .multiSelect) { selectedMaterial in
                                        if materialsFilter.contains(selectedMaterial) {
                                            materialsFilter.remove(selectedMaterial)
                                        } else {
                                            materialsFilter.append(selectedMaterial)
                                        }
                                    }
                                }
                            }
                            .id(FilterElement.material)
                            .disabled(isReceivingKeyboardInput)
                        }

                        //
                        // 🔢 Number of Items
                        //
                        /*
                         
                         TEMPORARILY REMOVED BECAUSE IT DOESN'T WORK ON THE BACKEND YET.
                         
                        if let numberOfItems: SearchFilter<Int> = filterSettings.numberOfItems {
                            CollapsableFilter(title: filterModel.numberOfItemsTitle) {
                                NumericStepperWithTextInput(currentValue: .init(get: { numberOfItems.value },
                                                                                set: { numberOfItems.value = $0 }))
                            }
                        }
                         */

                        //
                        // 🌎 Locations
                        //

                        if let countryFilter: SearchFilterMultiSelectable = filterSettings.country,
                           locations.count > 0
                        {
                            CollapsableFilter(title: filterModel.locationTitle) {
                                FlowLayout(mode: .scrollable,
                                           binding: .constant(3),
                                           items: locations) { countryFacet, _ in
                                    SearchFilterButton("\(countryFacet.value.localized) (\(countryFacet.count))",
                                                       value: countryFacet.value,
                                                       isSelected: countryFilter.contains(countryFacet.value),
                                                       style: .multiSelect) { selectedCountry in
                                        if countryFilter.contains(selectedCountry) {
                                            countryFilter.remove(selectedCountry)
                                        } else {
                                            countryFilter.append(selectedCountry)
                                        }
                                    }
                                }
                            }
                            .id(FilterElement.location)
                            .disabled(isReceivingKeyboardInput)
                        }

                        //
                        // 👩🏽‍🎨 Style Filter
                        //

                        if let styleFilter: SearchFilterMultiSelectable = filterSettings.style,
                           styles.count > 0
                        {
                            CollapsableFilter(title: filterModel.styleTitle) {
                                FlowLayout(mode: .scrollable,
                                           binding: .constant(3),
                                           items: styles) { style, _ in
                                    SearchFilterButton("\(style.value.localize(\.title)) (\(style.count))",
                                                       value: style.value,
                                                       isSelected: styleFilter.contains(style.value),
                                                       style: .multiSelect) { selectedStyle in
                                        if styleFilter.contains(selectedStyle) {
                                            styleFilter.remove(selectedStyle)
                                        } else {
                                            styleFilter.append(selectedStyle)
                                        }
                                    }
                                }
                            }
                            .id(FilterElement.style)
                            .disabled(isReceivingKeyboardInput)
                        }
                    }
                    
                    Spacer()
                        .frame(height: footerSize)
                }
                .padding(.all, WhoppahTheme.Size.Padding.medium)
                .scrollWithAdaptiveBounce(.vertical, showsIndicators: true)
                .onReceive(filterSettings.objectWillChange) { _ in
                    guard !isReceivingKeyboardInput, let elementToScrollTo = elementToScrollTo else {
                        return
                    }
                    withAnimation {
                        scrollViewValue.scrollTo(elementToScrollTo, anchor: .center)
                    }
                    self.elementToScrollTo = nil
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                    isReceivingKeyboardInput = false
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                    isReceivingKeyboardInput = true
                }
                .onReceive(viewStore.publisher.latestSearchFacetsSet.brands) { brands in
                    withAnimation {
                        self.brands = brands
                    }
                }
                .onReceive(viewStore.publisher.latestSearchFacetsSet.categories) { categories in
                    withAnimation {
                        self.categories = categories.firstNumberOfElements(maxNumberOfVisibleFiltersItems)
                    }
                }
                .onReceive(viewStore.publisher.latestSearchFacetsSet.colors) { colors in
                    withAnimation {
                        self.colors = colors
                    }
                }
                .onReceive(viewStore.publisher.latestSearchFacetsSet.materials) { materials in
                    withAnimation {
                        self.materials = materials.firstNumberOfElements(maxNumberOfVisibleFiltersItems)
                    }
                }
                .onReceive(viewStore.publisher.latestSearchFacetsSet.countries) { countries in
                    withAnimation {
                        self.locations = countries
                    }
                }
                .onReceive(viewStore.publisher.latestSearchFacetsSet.styles) { styles in
                    withAnimation {
                        self.styles = styles.firstNumberOfElements(maxNumberOfVisibleFiltersItems)
                    }
                }
            }
        }
    }
}

struct SearchFilterViewFilters_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .initial,
                      reducer: SearchView.Reducer().reducer,
                      environment: .mock)
        
        SearchFilterViewFilters(store: store,
                                footerSize: 10)
    }
}
