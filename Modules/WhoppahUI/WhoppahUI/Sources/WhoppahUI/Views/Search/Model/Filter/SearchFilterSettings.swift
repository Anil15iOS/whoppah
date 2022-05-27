//
//  SearchView+Model+FilterSettings.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 30/03/2022.
//

import Foundation
import WhoppahModel

@dynamicMemberLookup
class SearchFilterSettings: ObservableObject {
    @Published var sortingOption: SearchView.Model.Filters.SortingOption = .default
    @Published var conditionOption: SearchView.Model.Filters.ConditionOption? = nil
    @Published var searchFilterSelection: SearchFilterSelection
    
    @Published var isReceivingKeyboardInput: Bool = false
    var currentPageIndex: Int = 1
    let defaultPaginationLimit: Int = 25
    let defaultFacets: [SearchFacetKey] = [
        .category,
        .color,
        .brand,
        .material,
        .country,
        .style
        ]
    
    var hasActiveFilters: Bool {
        searchFilterSelection.searchFilters.contains { $0.isActiveFilter }
    }
    
    var searchFilterString: String {
        var filterString = ""
        
        searchFilterSelection.searchFilters.forEach { filterable in
            if let singleSelectable = filterable as? SearchFiltering & SearchFilterSingleSelectable,
                singleSelectable.isActiveFilter
            {
                filterString += "\(singleSelectable.filterLabel), "
            } else if let multiSelectable = filterable as? SearchFiltering & SearchFilterMultiSelectable,
                      multiSelectable.isActiveFilter
            {
                multiSelectable.items.forEach { item in
                    filterString += "\(item.filterLabel), "
                }
            }
        }
        
        if filterString.hasSuffix(", ") {
            let index = filterString.index(filterString.startIndex, offsetBy: filterString.count - 2)
            filterString = String(filterString[..<index])
        }

        return filterString
    }
    
    public init() {
        searchFilterSelection = SearchFilterSelection()
        searchFilterSelection.registerPublisher(self.objectWillChange)
        
        searchFilterSelection.add(SearchFilter("", type: .query))
        searchFilterSelection.add(SearchFilterMultiOption([WhoppahModel.Category](), type: .category, key: .category))
        searchFilterSelection.add(SearchFilterMultiOption([SearchView.Model.Filters.PropertyOption](), type: .other))
        searchFilterSelection.add(SearchFilterMultiOption([WhoppahModel.Brand](), type: .brand, key: .brand))
        searchFilterSelection.add(SearchFilterMultiOption([WhoppahModel.Style](), type: .style, key: .style))
        searchFilterSelection.add(SearchFilterMultiOption([WhoppahModel.Material](), type: .material, key: .material))
        searchFilterSelection.add(SearchFilterMultiOption([WhoppahModel.Color](), type: .color, key: .color))
        searchFilterSelection.add(SearchFilterMultiOption([WhoppahModel.Country](), type: .country, key: .country))
        searchFilterSelection.add(SearchFilter(SearchFilterMinMaxValue(valuePostfix: "€"), type: .price, key: .price))
        searchFilterSelection.add(SearchFilter(SearchFilterMinMaxValue(valuePostfix: "cm"), type: .width, key: .width))
        searchFilterSelection.add(SearchFilter(SearchFilterMinMaxValue(valuePostfix: "cm"), type: .height, key: .height))
        searchFilterSelection.add(SearchFilter(SearchFilterMinMaxValue(valuePostfix: "cm"), type: .depth, key: .depth))
        searchFilterSelection.add(SearchFilter(Int(1), type: .numberOfItems, key: .numberOfItems))
    }
    
    func reset(_ defaultSortingOption: SearchView.Model.Filters.SortingOption? = nil) {
        sortingOption = defaultSortingOption ?? .default
        conditionOption = nil
        currentPageIndex = 1
        searchFilterSelection.reset()
    }
    
    var asInput: SearchProductsInput {
        var query = ""
        
        if let queryFilter: SearchFilter<String> = self.query {
            query = queryFilter.value
        }
        
        return .init(
            query: query,
            pagination: .init(page: currentPageIndex, limit: defaultPaginationLimit),
            sort: sortingOption.sortType,
            order: sortingOption.sortOrder,
            facets: defaultFacets,
            filters: filterInput)
    }
    
    func fromInput(_ input: SearchProductsInput,
                   filterModel: SearchView.Model.Filters)
    {
        reset()
        
        if let query = input.query,
           let queryFilter: SearchFilter<String> = self.query
        {
            queryFilter.value = query
        }
        
        searchFilterSelection.searchFilters.forEach { searchFilter in
            if let key = searchFilter.searchFilterKey,
               var configurable = searchFilter as? SearchFilterInputConfigurable
            {
                configurable.from(input: input,
                                  key: key,
                                  attributesToMatch: filterModel.attributes(forKey: key))
            }
        }

        sortingOption(fromInput: input, sortingOptions: filterModel.sortingOptions)

        let propertyOptions: [SearchView.Model.Filters.PropertyOption]? = input.filters?.compactMap({
            if let key = $0.key,
                let property = filterModel.propertyOptions.first(where: { $0.property == key })
            {
                return property
            }
            return nil
        })
        
        if let otherFilter: SearchFilterMultiSelectable = self.other,
           let propertyOptions = propertyOptions
         {
            otherFilter.replaceAll(with: propertyOptions)
        }
    }
    
    private func sortingOption(fromInput input: SearchProductsInput,
                               sortingOptions: [SearchView.Model.Filters.SortingOption])
    {
        let sortType = input.sort ?? .default
        let sortOrder = input.order ?? .desc
        
        self.sortingOption = sortingOptions.first(where: {
            $0.sortType == sortType && $0.sortOrder == sortOrder
        }) ?? .default
    }
    
    private var filterInput: [FilterInput] {
        var filterInput = [FilterInput]()
        
        searchFilterSelection.searchFilters.forEach { searchFilter in
            if let multiSelection = searchFilter as? SearchFilterMultiSelectable & SearchFiltering,
               let key = multiSelection.searchFilterKey,
               multiSelection.count > 0
            {
                var value = ""
                
                if key == .category,
                   let items = multiSelection.items as? [WhoppahModel.Category]
                {
                    // only the child leaf category
                    value += items.sorted(by: { $0.level ?? 0 < $1.level ?? 0 }).last?.attributeValue ?? ""
                } else {
                    multiSelection.items.forEach { item in
                        value += "\(item.attributeValue),"
                    }
                }
                filterInput.append(.init(key: key, value: value))
            } else if let key = searchFilter.searchFilterKey,
                      searchFilter.isActiveFilter
            {
                filterInput.append(.init(key: key, value: searchFilter.attributeValue))
            }
        }
        
        if let conditionOption = conditionOption {
            filterInput.append(.init(key: .quality, value: conditionOption.quality.rawValue))
        }
        
        if let otherOptions: SearchFilterMultiSelectable = self.other {
            let items: [SearchView.Model.Filters.PropertyOption] = otherOptions.items.compactMap { $0 as? SearchView.Model.Filters.PropertyOption }
            
            items.forEach { propertyOption in
                filterInput.append(.init(key: propertyOption.property, value: propertyOption.valueWhenSelected))
            }
        }

        return filterInput
    }
    
    subscript(dynamicMember member: SearchFilterType) -> SearchFilter<SearchFilterMinMaxValue>? {
        searchFilterSelection.get(member) as? SearchFilter<SearchFilterMinMaxValue>
    }
    
    subscript(dynamicMember member: SearchFilterType) -> SearchFilter<Int>? {
        searchFilterSelection.get(member) as? SearchFilter<Int>
    }
    
    subscript(dynamicMember member: SearchFilterType) -> SearchFilter<String>? {
        searchFilterSelection.get(member) as? SearchFilter<String>
    }
    
    subscript(dynamicMember member: SearchFilterType) -> SearchFilterMultiSelectable? {
        searchFilterSelection.get(member) as? SearchFilterMultiSelectable
    }
}
