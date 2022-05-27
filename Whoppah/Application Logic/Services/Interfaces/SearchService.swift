//
//  SearchService.swift
//  Whoppah
//
//  Created by Eddie Long on 31/10/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import WhoppahDataStore

protocol SearchService {
    /// The search phrase/query to filter items on
    var searchText: String? { get set }
    /// The filter minimum price (in Euros)
    var minPrice: Money? { get set }
    /// The filter maximum price (in Euros)
    var maxPrice: Money? { get set }
    /// The address to filter items by
    var address: LegacyAddressInput? { get set }
    /// The postcode to filter items by, only used if the radius is set
    var postcode: Observable<String?> { get }
    /// The radius about the postcode to filter items around
    var radiusKilometres: Int? { get set }
    /// Required filter quality
    var quality: GraphQL.ProductQuality? { get set }
    /// Categories to filter by
    var categories: Set<FilterAttribute> { get set }
    /// Brands to filter by
    var brands: [FilterAttribute] { get set }
    /// Styles to filter by
    var styles: [FilterAttribute] { get set }
    /// Artists to filter by
    var artists: [FilterAttribute] { get set }
    /// Designers to filter by
    var designers: [FilterAttribute] { get set }
    /// Materials to filter by
    var materials: [FilterAttribute] { get set }
    /// Colors to filter by
    var colors: [FilterAttribute] { get set }
    /// Filter whether AR enabled items are enabled or not
    var arReady: Bool? { get set }
    /// The filter input to send to the server
    var filterInput: GraphQL.SearchFilterInput { get }
    /// Number of filters applied
    var filtersCount: Int { get }

    /// Removes all currently set filters
    func removeAllFilters()

    /// Sets all filters from a given saved search
    ///
    /// - Parameter search The saved search
    func setFrom(search: GraphQL.SavedSearchesQuery.Data.SavedSearch.Item)

    /// Gets a saved search from the current set of filters
    ///
    /// - Returns: The saved search input to send to the backend
    func toSavedSearch() -> GraphQL.SavedSearchInput
}
