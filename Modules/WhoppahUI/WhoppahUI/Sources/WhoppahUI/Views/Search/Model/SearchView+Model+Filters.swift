//
//  SearchView+Model+Filters.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 05/04/2022.
//

import Foundation
import SwiftUI
import WhoppahModel

extension SearchView.Model {
    public struct Filters: Equatable {
        public struct SortingOption: Equatable, Hashable {
            var id = UUID()
            var title: String
            var sortOrder: Ordering
            var sortType: SearchSort
            
            public init(title: String,
                        sortOrder: Ordering,
                        sortType: SearchSort)
            {
                self.title = title
                self.sortOrder = sortOrder
                self.sortType = sortType
            }
            
            public static func == (lhs: Self, rhs: Self) -> Bool {
                lhs.sortOrder == rhs.sortOrder &&
                lhs.sortType == rhs.sortType
            }
            
            public static var `default`: Self = .init(title: "",
                                                      sortOrder: .desc,
                                                      sortType: .created)
        }
        
        public struct ConditionOption: Equatable, Hashable, Identifiable {
            public var id = UUID()
            var title: String
            var quality: ProductQuality
            
            public init(title: String,
                        quality: ProductQuality)
            {
                self.title = title
                self.quality = quality
            }
            
            public static func == (lhs: Self, rhs: Self) -> Bool {
                lhs.id == rhs.id
            }
        }
        
        public struct PropertyOption: Equatable, Hashable, Identifiable {
            public let id = UUID()
            var title: String
            var property: SearchFilterKey
            var valueWhenSelected: String
            
            public init(title: String,
                        property: SearchFilterKey,
                        valueWhenSelected: String)
            {
                self.title = title
                self.property = property
                self.valueWhenSelected = valueWhenSelected
            }
        }

        let id = UUID()
        var title: String
        var doneButtonTitle: String
        var resetFiltersTitle: String
        var sortTitle: String
        var categoryTitle: String
        var priceTitle: String
        var dimensionsTitle: String
        var widthTitle: String
        var heightTitle: String
        var depthTitle: String
        var conditionTitle: String
        var brandTitle: String
        var brandPlaceholder: String
        var styleTitle: String
        var materialTitle: String
        var colorTitle: String
        var numberOfItemsTitle: String
        var locationTitle: String
        var showResultsTitle: (Int) -> String
        var minPlaceholder: String
        var maxPlaceholder: String
        var sortingOptions: [SortingOption]
        var conditionOptions: [ConditionOption]
        var propertyOptions: [PropertyOption]
        
        var brands = [WhoppahModel.Brand]()
        var materials = [WhoppahModel.Material]()
        var styles = [WhoppahModel.Style]()
        var colors = [WhoppahModel.Color]()
        var categories = [WhoppahModel.Category]()
        
        func attributes(forKey key: SearchFilterKey) -> [AbstractAttribute]? {
            switch key {
            case .brand: return brands
            case .material: return materials
            case .style: return styles
            case .color: return colors
            case .category: return categories.flattened
            default: return nil
            }
        }

        public init(
            title: String,
            doneButtonTitle: String,
            resetFiltersTitle: String,
            sortTitle: String,
            categoryTitle: String,
            priceTitle: String,
            dimensionsTitle: String,
            widthTitle: String,
            heightTitle: String,
            depthTitle: String,
            conditionTitle: String,
            brandTitle: String,
            brandPlaceholder: String,
            styleTitle: String,
            materialTitle: String,
            colorTitle: String,
            numberOfItemsTitle: String,
            locationTitle: String,
            showResultsTitle: @escaping (Int) -> String,
            minPlaceholder: String,
            maxPlaceholder: String,
            sortingOptions: [SortingOption],
            conditionOptions: [ConditionOption],
            propertyOptions: [PropertyOption])
        {
            self.title = title
            self.doneButtonTitle = doneButtonTitle
            self.resetFiltersTitle = resetFiltersTitle
            self.sortTitle = sortTitle
            self.categoryTitle = categoryTitle
            self.priceTitle = priceTitle
            self.dimensionsTitle = dimensionsTitle
            self.widthTitle = widthTitle
            self.heightTitle = heightTitle
            self.depthTitle = depthTitle
            self.conditionTitle = conditionTitle
            self.brandTitle = brandTitle
            self.brandPlaceholder = brandPlaceholder
            self.styleTitle = styleTitle
            self.materialTitle = materialTitle
            self.colorTitle = colorTitle
            self.numberOfItemsTitle = numberOfItemsTitle
            self.locationTitle = locationTitle
            self.showResultsTitle = showResultsTitle
            self.minPlaceholder = minPlaceholder
            self.maxPlaceholder = maxPlaceholder
            self.sortingOptions = sortingOptions
            self.conditionOptions = conditionOptions
            self.propertyOptions = propertyOptions
        }
        
        static var initial: Self = .init(
            title: .empty,
            doneButtonTitle: .empty,
            resetFiltersTitle: .empty,
            sortTitle: .empty,
            categoryTitle: .empty,
            priceTitle: .empty,
            dimensionsTitle: .empty,
            widthTitle: .empty,
            heightTitle: .empty,
            depthTitle: .empty,
            conditionTitle: .empty,
            brandTitle: .empty,
            brandPlaceholder: .empty,
            styleTitle: .empty,
            materialTitle: .empty,
            colorTitle: .empty,
            numberOfItemsTitle: .empty,
            locationTitle: .empty,
            showResultsTitle: { _ in .empty },
            minPlaceholder: .empty,
            maxPlaceholder: .empty,
            sortingOptions: [],
            conditionOptions: [],
            propertyOptions: [])
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id &&
            lhs.showResultsTitle(0) == rhs.showResultsTitle(0) &&
            lhs.sortingOptions == rhs.sortingOptions &&
            lhs.conditionOptions == rhs.conditionOptions &&
            lhs.propertyOptions == rhs.propertyOptions
        }
        
        func categoryHierarchy(for category: WhoppahModel.Category) -> [WhoppahModel.Category] {
            var hierarchy = [WhoppahModel.Category]()
            
            var currentCategory: WhoppahModel.Category? = category
            
            while let parentId = currentCategory?.parent,
                  let parentCategory = findParentCategory(withId: parentId, categories: self.categories)
            {
                hierarchy.append(parentCategory)
                currentCategory = parentCategory
            }
            
            return hierarchy.reversed()
        }
        
        private func findParentCategory(withId parentId: UUID, categories: [WhoppahModel.Category]) -> WhoppahModel.Category? {
            for i in 0..<categories.count {
                let category = categories[i]
                if category.id == parentId {
                    return category
                }
                else if let children = category.children, children.count > 0 {
                    if let parentCategory = findParentCategory(withId: parentId,
                                                               categories: children)
                    {
                        return parentCategory
                    }
                }
            }
            
            return nil
        }
    }
}
