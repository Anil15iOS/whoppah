//  
//  SearchView+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 09/03/2022.
//

import Foundation
import WhoppahModel

public extension SearchView.Model {
    static var mock: Self {
        let sortingOptions: [Filters.SortingOption] = [
            .init(title: "Most relevant", sortOrder: .desc, sortType: .default),
            .init(title: "Price - lowest first", sortOrder: .asc, sortType: .price),
            .init(title: "Price - highest first", sortOrder: .desc, sortType: .price),
            .init(title: "Date - newest first", sortOrder: .desc, sortType: .created),
            .init(title: "Date - oldest first", sortOrder: .asc, sortType: .created),
            .init(title: "Popularity - highest first", sortOrder: .desc, sortType: .popularity),
            .init(title: "Popularity - lowest first", sortOrder: .asc, sortType: .popularity)
        ]
        
        let conditionOptions: [Filters.ConditionOption] = [
            .init(title: "Good", quality: .good),
            .init(title: "Very good", quality: .great),
            .init(title: "Excellent", quality: .perfect)
        ]
        
        let propertyOptions: [Filters.PropertyOption] = [
            .init(title: "SALE", property: .label, valueWhenSelected: "lowered-in-price"),
            .init(title: "Bidding possible", property: .allowBid, valueWhenSelected: "true"),
            .init(title: "In showroom", property: .inShowroom, valueWhenSelected: "true"),
            .init(title: "Show only available items", property: .availability, valueWhenSelected: "true")
        ]
        
        let filters = Filters(
            title: "Filters",
            doneButtonTitle: "Done",
            resetFiltersTitle: "Reset filters",
            sortTitle: "Sort",
            categoryTitle: "Categories",
            priceTitle: "Price",
            dimensionsTitle: "Dimensions",
            widthTitle: "Width",
            heightTitle: "Height",
            depthTitle: "Depth",
            conditionTitle: "Condition",
            brandTitle: "Brand",
            brandPlaceholder: "Search for a brand",
            styleTitle: "Style",
            materialTitle: "Material",
            colorTitle: "Color",
            numberOfItemsTitle: "Number of items (set)",
            locationTitle: "Location",
            showResultsTitle: { "Show \($0) results" },
            minPlaceholder: "min",
            maxPlaceholder: "max",
            sortingOptions: sortingOptions,
            conditionOptions: conditionOptions,
            propertyOptions: propertyOptions)
        
        let noResults = NoResults(
            noResults: { "We don't have results for \($0)" },
            notifyMeTitle: "Notify me!")

        return .init(
            title: "Search",
            filters: filters,
            bidFrom: { "Bid from \($0.formattedString)" },
            searchPlaceholder: "Search",
            filterButtonTitle: "Filter",
            noResults: noResults,
            userNotSignedInTitle: "Please sign in",
            userNotSignedInDescription: "Sign in description")
    }
}
