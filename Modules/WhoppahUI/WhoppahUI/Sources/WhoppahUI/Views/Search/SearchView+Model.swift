//  
//  SearchView+Model.swift
//  
//
//  Created by Dennis Ippel on 09/03/2022.
//

import Foundation
import SwiftUI
import WhoppahModel

public extension SearchView {
    struct Model: Equatable {
        public struct NoResults {
            public var noResults: (String) -> String
            public var notifyMeTitle: String
            
            static var initial: Self = .init(noResults: { _ in return .empty },
                                             notifyMeTitle: "")
            
            public init(noResults: @escaping (String) -> String,
                        notifyMeTitle: String)
            {
                self.noResults = noResults
                self.notifyMeTitle = notifyMeTitle
            }
        }
        
        var id = UUID()
        var title: String
        var searchPlaceholder: String
        var filterButtonTitle: String
        var bidFrom: (WhoppahModel.Price) -> String
        var filters: Filters
        var noResults: NoResults
        var userNotSignedInTitle: String
        var userNotSignedInDescription: String
        
        static var initial: Self = .init(
            title: .empty,
            filters: .initial,
            bidFrom: { _ in return .empty },
            searchPlaceholder: .empty,
            filterButtonTitle: .empty,
            noResults: .initial,
            userNotSignedInTitle: .empty,
            userNotSignedInDescription: .empty
        )
        
        public init(title: String,
                    filters: Filters,
                    bidFrom: @escaping (WhoppahModel.Price) -> String,
                    searchPlaceholder: String,
                    filterButtonTitle: String,
                    noResults: NoResults,
                    userNotSignedInTitle: String,
                    userNotSignedInDescription: String)
        {
            self.title = title
            self.filters = filters
            self.bidFrom = bidFrom
            self.searchPlaceholder = searchPlaceholder
            self.filterButtonTitle = filterButtonTitle
            self.noResults = noResults
            self.userNotSignedInTitle = userNotSignedInTitle
            self.userNotSignedInDescription = userNotSignedInDescription
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}
