//
//  SearchProductsInput+Extensions.swift
//  
//
//  Created by Dennis Ippel on 08/04/2022.
//

import Foundation

extension SearchProductsInput: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.query == rhs.query &&
        lhs.pagination == rhs.pagination &&
        lhs.sort == rhs.sort &&
        lhs.order == rhs.order &&
        lhs.facets == rhs.facets &&
        lhs.filters == rhs.filters
    }
}

extension Pagination: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.limit == rhs.limit &&
        lhs.page == rhs.page
    }
}

extension FilterInput: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value &&
        lhs.key == rhs.key
    }
}
