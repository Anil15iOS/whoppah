//
//  SearchService.swift
//  Whoppah
//
//  Created by Boris Sagan on 12/25/18.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import CoreLocation
import Resolver
import WhoppahDataStore

class SearchServiceImpl: SearchService {
    var searchText: String?
    var minPrice: Money?
    var maxPrice: Money?
    var address: LegacyAddressInput? {
        didSet {
            if let address = address, let point = address.point {
                if address.postalCode.isEmpty {
                    lookupPostcode(point: point)
                } else {
                    _postcode.accept(address.postalCode)
                }
            } else {
                _postcode.accept(nil)
            }
        }
    }

    var postcode: Observable<String?> {
        _postcode.asObservable()
    }

    private let _postcode = BehaviorRelay<String?>(value: nil)
    @Injected private var location: LocationService

    var radiusKilometres: Int?
    var quality: GraphQL.ProductQuality?
    var categories = Set<FilterAttribute>()
    var brands: [FilterAttribute] = []
    var styles: [FilterAttribute] = []
    var artists: [FilterAttribute] = []
    var designers: [FilterAttribute] = []
    var materials: [FilterAttribute] = []
    var colors: [FilterAttribute] = []
    var arReady: Bool?

    var filterInput: GraphQL.SearchFilterInput {
        var input = GraphQL.SearchFilterInput()
        if let point = address?.point, let radius = radiusKilometres {
            input.location = GraphQL.LocationSearchFilterInput(latitude: point.latitude, longitude: point.longitude, address: address?.postalCode, distance: radius)
        }
        if minPrice != nil || maxPrice != nil {
            input.price = GraphQL.PriceSearchFilterInput(currency: .eur, from: minPrice, to: maxPrice)
        }
        var properties = [GraphQL.PropertySearchFilterInput]()
        if let quality = quality {
            properties.append(GraphQL.PropertySearchFilterInput(key: .quality, value: quality.rawValue))
        }
        if let arReady = arReady {
            properties.append(GraphQL.PropertySearchFilterInput(key: .hasAr, value: arReady.description))
        }
        input.properties = properties
        var attributes = [GraphQL.AttributeSearchFilterInput]()
        if !categories.isEmpty {
            input.categories = GraphQL.CategorySearchFilterInput(value: categories.map { $0.slug })
        }
        if !styles.isEmpty {
            attributes.append(GraphQL.AttributeSearchFilterInput(key: .style, value: styles.map { $0.slug }))
        }
        if !designers.isEmpty {
            attributes.append(GraphQL.AttributeSearchFilterInput(key: .designer, value: designers.map { $0.slug }))
        }
        if !brands.isEmpty {
            attributes.append(GraphQL.AttributeSearchFilterInput(key: .brand, value: brands.map { $0.slug }))
        }
        if !artists.isEmpty {
            attributes.append(GraphQL.AttributeSearchFilterInput(key: .artist, value: artists.map { $0.slug }))
        }
        if !materials.isEmpty {
            attributes.append(GraphQL.AttributeSearchFilterInput(key: .material, value: materials.map { $0.slug }))
        }
        if !colors.isEmpty {
            attributes.append(GraphQL.AttributeSearchFilterInput(key: .color, value: colors.map { $0.slug }))
        }
        input.attributes = attributes
        return input
    }

    var filtersCount: Int {
        var count = 0

        if minPrice != nil || maxPrice != nil {
            count += 1
        }

        if address != nil {
            count += 1
        }

        if radiusKilometres != nil {
            count += 1
        }

        if quality != nil {
            count += 1
        }

        count += categories.count
        count += brands.count
        count += styles.count
        count += materials.count
        count += colors.count
        count += designers.count
        count += artists.count

        if arReady ?? false {
            count += 1
        }

        return count
    }

    // MARK: -

    func removeAllFilters() {
        searchText = nil
        minPrice = nil
        maxPrice = nil
        address = nil
        radiusKilometres = nil
        quality = nil
        categories.removeAll()
        brands.removeAll()
        styles.removeAll()
        materials.removeAll()
        colors.removeAll()
        artists.removeAll()
        designers.removeAll()
        arReady = nil
    }

    func setFrom(search _: GraphQL.SavedSearchesQuery.Data.SavedSearch.Item) {}

    private func lookupPostcode(point: PointInput) {
        let clLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
        location.address(by: clLocation) { [weak self] _, placemark, error in
            guard let self = self, error == nil else { return }
            if let placemark = placemark, let postcode = placemark.postalCode {
                // Makle sure the search hasn't changed
                if let existingPt = self.address?.point, existingPt.longitude.isApproxEqual(point.longitude), existingPt.latitude.isApproxEqual(point.latitude) {
                    self.address?.postalCode = postcode
                    self._postcode.accept(postcode)
                }
            }
        }
    }

    func toSavedSearch() -> GraphQL.SavedSearchInput {
        GraphQL.SavedSearchInput(title: getDefaultSavedSearchTitle(), query: searchText, filters: filterInput)
    }

    private func getDefaultSavedSearchTitle() -> String {
        var components = [String]()
        if let search = searchText {
            components.append(search)
        }
        if let quality = quality {
            components.append(getFilterCellQuality(quality))
        }
        if minPrice != nil || maxPrice != nil {
            components.append(getFilterCellPrice(min: minPrice, max: maxPrice))
        }

        components.append(contentsOf: categories.compactMap { $0.title.value })
        let allattributes = brands + styles + artists + designers + materials + colors
        for attribute in allattributes {
            if let title = attribute.title.value {
                components.append(title)
            }
        }

        if arReady != nil {
            components.append(R.string.localizable.search_filters_ar())
        }
        return components.joined(separator: ", ")
    }
}
