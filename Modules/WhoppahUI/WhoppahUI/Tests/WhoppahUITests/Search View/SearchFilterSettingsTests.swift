//
//  SearchFilterSettingsTest.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 11/04/2022.
//

import Foundation
@testable import WhoppahUI
import XCTest
import WhoppahModel
import ComposableArchitecture
import Combine

final class SearchFilterSettingsTest: SearchViewTestsBase {
    var randomBrand: WhoppahModel.Brand {
        return viewStore.model.filters.brands.randomElement() ??
            .init(id: UUID(), title: "", slug: "")
    }
    
    var randomCategory: WhoppahModel.Category {
        return viewStore.model.filters.categories.randomElement() ??
            .init(id: UUID(), title: "", slug: "", images: [], videos: [])
    }
    
    var randomStyle: WhoppahModel.Style {
        return viewStore.model.filters.styles.randomElement() ??
            .init(id: UUID(), title: "", slug: "")
    }
    
    var randomMaterial: WhoppahModel.Material {
        return viewStore.model.filters.materials.randomElement() ??
            .init(id: UUID(), title: "", slug: "")
    }
    
    var randomFacets: [WhoppahModel.SearchFacetKey] {
        var facets = [WhoppahModel.SearchFacetKey]()
        
        WhoppahModel.SearchFacetKey.allCases.forEach { key in
            if key != .unknown && Int.random(in: 0...1) == 1 {
                facets.append(key)
            }
        }
        
        return facets
    }
    
    var randomSearchFilters: [FilterInput] {
        var filters = [FilterInput]()
        
        filters.append(.init(key: .brand, value: randomBrand.slug))
        filters.append(.init(key: .allowBid, value: String(Int.random(in: 0...1) == 0)))
        filters.append(.init(key: .category, value: randomCategory.slug))
        filters.append(.init(key: .height, value: String(Int.random(in: 0...100))))
        filters.append(.init(key: .width, value: String(Int.random(in: 0...100))))
        filters.append(.init(key: .depth, value: String(Int.random(in: 0...100))))
        filters.append(.init(key: .style, value: randomStyle.slug))
        filters.append(.init(key: .inShowroom, value: String(Int.random(in: 0...1) == 0)))
        filters.append(.init(key: .material, value: randomMaterial.slug))
        filters.append(.init(key: .label, value: RandomWord.randomWords(0...1)))
        filters.append(.init(key: .price, value: String(Int.random(in: 0...1000))))
        
        return filters
    }
    
    func testSearchFilterSettingsInputOutput() throws {
        viewStore.send(.loadContent)
        
        scheduler.advance(by: 0.0001)
        
        let randomSorting = randomSortingOption
        
        let input = SearchProductsInput(
            query: randomQuery,
            pagination: .init(),
            sort: randomSorting.sortType,
            order: randomSorting.sortOrder,
            facets: randomFacets,
            filters: randomSearchFilters)
        
        let filterSettings = SearchFilterSettings()
        filterSettings.fromInput(input, filterModel: viewStore.state.model.filters)

        let asInput = filterSettings.asInput
        XCTAssert(asInput.query == input.query,
                  "Query mismatch: \(asInput.query ?? "nil") != \(input.query ?? "nil")")

        XCTAssert(asInput.sort == input.sort,
                  "Sort mismatch: \(asInput.sort?.rawValue ?? "nil") != \(input.sort?.rawValue ?? "nil")")
        XCTAssert(asInput.order == input.order,
                  "Order mismatch: \(asInput.order?.rawValue ?? "nil") != \(input.order?.rawValue ?? "nil")")

        let filters = try XCTUnwrap(input.filters)
        let asFilters = try XCTUnwrap(asInput.filters)
        XCTAssert(filters.count == asFilters.count,
                  "Filters mismatch: \(filters.count) != \(asFilters.count)")
        
        let facets = try XCTUnwrap(filterSettings.defaultFacets)
        let asFacets = try XCTUnwrap(asInput.facets)
        XCTAssert(facets.count == asFacets.count,
                  "Facets mismatch: \(facets.count) != \(asFacets.count)")
    }
    
    func testSearchFilterSettingsActiveFilters() {
        viewStore.send(.loadContent)
        
        scheduler.advance(by: 0.0001)
        
        let filterSettings = SearchFilterSettings()
        XCTAssertFalse(filterSettings.hasActiveFilters)
        
        let randomSorting = randomSortingOption
        
        let input = SearchProductsInput(
            query: randomQuery,
            pagination: .init(),
            sort: randomSorting.sortType,
            order: randomSorting.sortOrder,
            facets: randomFacets,
            filters: randomSearchFilters)
        
        filterSettings.fromInput(input, filterModel: viewStore.state.model.filters)
        XCTAssertTrue(filterSettings.hasActiveFilters)
        
        filterSettings.reset()
        XCTAssertFalse(filterSettings.hasActiveFilters)
        
        let queryFilter: SearchFilter<String>? = filterSettings.query
        queryFilter?.value = "Not empty"
        XCTAssertTrue(filterSettings.hasActiveFilters)
        
        queryFilter?.value = .empty
        XCTAssertFalse(filterSettings.hasActiveFilters)
        
        let categoryFilter: SearchFilterMultiSelectable? = filterSettings.category
        categoryFilter?.append(randomCategory)
        XCTAssertTrue(filterSettings.hasActiveFilters)
        
        categoryFilter?.removeLast(1)
        XCTAssertFalse(filterSettings.hasActiveFilters)
        
        let priceFilter: SearchFilter<SearchFilterMinMaxValue>? = filterSettings.price
        priceFilter?.value.min = "0"
        priceFilter?.value.max = "100"
        XCTAssertTrue(filterSettings.hasActiveFilters)
        
        priceFilter?.value.min = .empty
        priceFilter?.value.max = .empty
        XCTAssertFalse(filterSettings.hasActiveFilters)
    }
    
    func testSearchFilterSelectionsNotNull() {
        let filterSettings = SearchFilterSettings()
        let queryFilter: SearchFilter<String>? = filterSettings.query
        XCTAssertNotNil(queryFilter)
        
        let categoryFilter: SearchFilterMultiSelectable? = filterSettings.category
        XCTAssertNotNil(categoryFilter)
        let otherFilter: SearchFilterMultiSelectable? = filterSettings.other
        XCTAssertNotNil(otherFilter)
        let brandFilter: SearchFilterMultiSelectable? = filterSettings.brand
        XCTAssertNotNil(brandFilter)
        let styleFilter: SearchFilterMultiSelectable? = filterSettings.style
        XCTAssertNotNil(styleFilter)
        let materialFilter: SearchFilterMultiSelectable? = filterSettings.material
        XCTAssertNotNil(materialFilter)
        let colorFilter: SearchFilterMultiSelectable? = filterSettings.color
        XCTAssertNotNil(colorFilter)
        let countryFilter: SearchFilterMultiSelectable? = filterSettings.country
        XCTAssertNotNil(countryFilter)
        let priceFilter: SearchFilter<SearchFilterMinMaxValue>? = filterSettings.price
        XCTAssertNotNil(priceFilter)
        let widthFilter: SearchFilter<SearchFilterMinMaxValue>? = filterSettings.width
        XCTAssertNotNil(widthFilter)
        let heightFilter: SearchFilter<SearchFilterMinMaxValue>? = filterSettings.height
        XCTAssertNotNil(heightFilter)
        let depthFilter: SearchFilter<SearchFilterMinMaxValue>? = filterSettings.depth
        XCTAssertNotNil(depthFilter)
        let numberOfItems: SearchFilter<Int>? = filterSettings.numberOfItems
        XCTAssertNotNil(numberOfItems)
    }
}
