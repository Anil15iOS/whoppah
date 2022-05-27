//
//  PaginatedView.swift
//  Whoppah
//
//  Created by Eddie Long on 13/06/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

#if DEBUG
    let fakeInfiniteScroll = false
#else
    let fakeInfiniteScroll = false
#endif

public struct PagedView {
    private var _currentPage: Int = 1
    private var _nextPage: Int = 1
    private var _depth = 0
    public let pageSize: Int

    public init(pageSize: Int) {
        self.pageSize = pageSize
    }

    public var currentPage: Int { _currentPage }

    public var nextPage: Int { _nextPage }

    public var currentDepth: Int { _depth }

    public mutating func resetToFirstPage() {
        _currentPage = 1
        _nextPage = 1
        _depth = 0
    }

    public func isFirstPage() -> Bool {
        _currentPage == 1
    }

    public func hasMorePages() -> Bool {
        guard !fakeInfiniteScroll else { return true }
        return _currentPage < _nextPage
    }

    public mutating func onListFetched(page: Int, total: Int, limit: Int) {
        if page == 1 {
            _depth = limit
        } else {
            _depth += limit
        }
        _currentPage = page
        if fakeInfiniteScroll {
            _nextPage = min(_currentPage + 1, 1000)
        } else {
            _nextPage = min(_currentPage + 1, total)
        }
    }

    public func getPagination() -> GraphQL.Pagination {
        if fakeInfiniteScroll {
            // Always load the first page
            return GraphQL.Pagination(page: 1, limit: pageSize)
        } else {
            return GraphQL.Pagination(page: nextPage, limit: pageSize)
        }
    }
}
