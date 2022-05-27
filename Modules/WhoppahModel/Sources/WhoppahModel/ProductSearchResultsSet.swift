//
//  ProductSearchResultsSet.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 31/03/2022.
//

import Foundation

public struct ProductSearchResultsSet: Equatable {
    public struct Pagination: Equatable {
        public let page: Int
        public let pages: Int
        public let count: Int
        
        public init(page: Int, pages: Int, count: Int) {
            self.page = page
            self.pages = pages
            self.count = count
        }
    }
    
    public let items: [ProductTileItem]
    public let pagination: Pagination
    public let facets: [SearchFacet]
    
    public init(items: [ProductTileItem],
                pagination: Pagination,
                facets: [SearchFacet])
    {
        self.items = items
        self.pagination = pagination
        self.facets = facets
    }
    
    public static func == (lhs: ProductSearchResultsSet, rhs: ProductSearchResultsSet) -> Bool {
        return lhs.pagination == rhs.pagination &&
            lhs.items == rhs.items &&
            lhs.facets == rhs.facets
    }
}

extension ProductSearchResultsSet: CustomStringConvertible {
    public var description: String {
        "🔍 Search results page \(pagination.page)/\(pagination.pages): \(items.count) items."
    }
}
