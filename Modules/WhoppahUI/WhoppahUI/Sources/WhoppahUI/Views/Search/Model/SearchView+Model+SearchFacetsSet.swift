//
//  SearchView+Model+SearchFacetsSet.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 06/04/2022.
//

import Foundation
import WhoppahModel

extension SearchView.Model {
    public struct SearchFacetsSet: Equatable {
        public struct SearchResult<T: Equatable & Hashable>: Equatable & Hashable {
            let value: T
            let count: Int
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.count == rhs.count &&
            lhs.searchResultsSet == rhs.searchResultsSet &&
            lhs.filterModel == rhs.filterModel &&
            lhs.countries == rhs.countries &&
            lhs.categories == rhs.categories &&
            lhs.brands == rhs.brands &&
            lhs.materials == rhs.materials &&
            lhs.styles == rhs.styles
        }
        
        private var searchResultsSet: ProductSearchResultsSet?
        private var filterModel: Filters = .initial
        
        private(set) var countries = [SearchResult<WhoppahModel.Country>]()
        private(set) var categories = [SearchResult<WhoppahModel.Category>]()
        private(set) var brands = [SearchResult<WhoppahModel.Brand>]()
        private(set) var materials = [SearchResult<WhoppahModel.Material>]()
        private(set) var styles = [SearchResult<WhoppahModel.Style>]()
        private(set) var colors = [SearchResult<WhoppahModel.Color>]()
        
        var count: Int {
            searchResultsSet?.pagination.count ?? 0
        }
        
        public init() {}
        
        mutating public func update(from searchResultsSet: ProductSearchResultsSet,
                                    filterModel: Filters)
        {
            self.searchResultsSet = searchResultsSet
            self.filterModel = filterModel
            
            self.countries = parse()
            self.categories = parse(key: .category, modelItems: filterModel.categories.flattened)
            self.brands = parse(key: .brand, modelItems: filterModel.brands)
            self.materials = parse(key: .material, modelItems: filterModel.materials)
            self.styles = parse(key: .style, modelItems: filterModel.styles)
            self.colors = parse(key: .color, modelItems: filterModel.colors)
        }
        
        private func parse<T: AbstractAttribute>(key: SearchFacetKey, modelItems: [T]) -> [SearchResult<T>] {
            guard let facet = searchResultsSet?.facets.first(where: { $0.key == key })
            else { return [] }
            
            var results = [SearchResult<T>]()

            modelItems.forEach { item in
                if let facetItem = facet.values?.first(where: { $0.value?.lowercased() == item.slug }) {
                    results.append(.init(value: item, count: facetItem.count ?? 0))
                }
            }
            
            return results.sorted { $0.count > $1.count }
        }
        
        private func parse() -> [SearchResult<WhoppahModel.Country>] {
            guard let countriesFacet = searchResultsSet?.facets.first(where: { $0.key == .country })
            else { return [] }
            
            var countries = [SearchResult<WhoppahModel.Country>]()
            
            WhoppahModel.Country.allCases.forEach { country in
                if let facetCountry = countriesFacet.values?.first(where: { $0.value?.lowercased() == country.rawValue })
                {
                    countries.append(.init(value: country, count: facetCountry.count ?? 0))
                }
            }
            
            return countries.sorted { $0.count > $1.count }
        }
    }
}
