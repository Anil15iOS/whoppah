//
//  SearchView+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 09/03/2022.
//  Copyright © 2022 Whoppah. All rights reserved.
//

import Foundation
import WhoppahUI
import WhoppahLocalization

extension SearchView.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        let sortingOptions: [Filters.SortingOption] = [
            .init(title: l.search_sort_most_relevant(), sortOrder: .desc, sortType: .default),
            .init(title: l.search_sort_price_lowest_first(), sortOrder: .asc, sortType: .price),
            .init(title: l.search_sort_price_highest_first(), sortOrder: .desc, sortType: .price),
            .init(title: l.search_sort_date_newest_first(), sortOrder: .desc, sortType: .created),
            .init(title: l.search_sort_date_oldest_first(), sortOrder: .asc, sortType: .created),
            .init(title: l.search_sort_popularity_highest_first(), sortOrder: .desc, sortType: .popularity),
            .init(title: l.search_sort_popularity_lowest_first(), sortOrder: .asc, sortType: .popularity)
        ]
        
        let conditionOptions: [Filters.ConditionOption] = [
            .init(title: l.conditionGood(), quality: .good),
            .init(title: l.conditionGreat(), quality: .great),
            .init(title: l.conditionPerfect(), quality: .perfect)
        ]
        
        let propertyOptions: [Filters.PropertyOption] = [
            .init(title: l.commonSale(), property: .label, valueWhenSelected: "lowered-in-price"),
            .init(title: l.listingBiddingPossible(), property: .allowBid, valueWhenSelected: "true"),
            .init(title: l.listingShowroomItems(), property: .inShowroom, valueWhenSelected: "true"),
            .init(title: l.listingAvailableItems(), property: .availability, valueWhenSelected: "true")
        ]
              
        let filters = Filters(
            title: l.filterTitle(),
            doneButtonTitle: l.commonDone(),
            resetFiltersTitle: l.filterClearAll(),
            sortTitle: l.commonSortBy(),
            categoryTitle: l.filterCategory(),
            priceTitle: l.filterPrice(),
            dimensionsTitle: l.filterDimensions(),
            widthTitle: l.search_filters_width_placeholder(),
            heightTitle: l.search_filters_height_placeholder(),
            depthTitle: l.search_filters_depth_placeholder(),
            conditionTitle: l.filterCondition(),
            brandTitle: l.filterBrand(),
            brandPlaceholder: l.filterSelectBrand(),
            styleTitle: l.filterStyle(),
            materialTitle: l.filterMaterial(),
            colorTitle: l.filterColor(),
            numberOfItemsTitle: l.number_of_items(),
            locationTitle: l.filterCountry(),
            showResultsTitle: { l.filterShowResultsWithCount("\($0)") },
            minPlaceholder: l.filterMinPlaceholder(),
            maxPlaceholder: l.filterMaxPlaceholder(),
            sortingOptions: sortingOptions,
            conditionOptions: conditionOptions,
            propertyOptions: propertyOptions)
        
        let noResults = NoResults(
            noResults: { l.listingNoSearchResultsHeading($0) },
            notifyMeTitle: l.search_fb_save_search())

        return .init(title: l.navSearchPlaceholder(),
                     filters: filters,
                     bidFrom: { l.commonBidFromPrice($0.formattedString) },
                     searchPlaceholder: l.navSearchPlaceholder(),
                     filterButtonTitle: l.filterTitle(),
                     noResults: noResults,
                     userNotSignedInTitle: R.string.localizable.contextualSignupFavoritesTitle(),
                     userNotSignedInDescription: R.string.localizable.contextualSignupFavoritesDescription())
    }
}
