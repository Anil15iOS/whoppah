//
//  SearchFilterSelection.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import SwiftUI
import Combine
import WhoppahModel

class SearchFilterSelection {
    @Published var searchFilters = [SearchFiltering]()
    
    private weak var publisher: ObservableObjectPublisher?
    
    init() {}
    
    func registerPublisher(_ publisher: ObservableObjectPublisher) {
        self.publisher = publisher
    }
    
    func add(_ searchFilter: SearchFiltering) {
        guard !searchFilters.contains(where: { $0.filterType == searchFilter.filterType }) else {
            assertionFailure()
            return
        }
        searchFilter.registerPublisher(publisher)
        searchFilters.append(searchFilter)
    }
    
    func get(_ filterType: SearchFilterType) -> SearchFiltering? {
        searchFilters.first { $0.filterType == filterType }
    }
    
    func reset() {
        for var searchFilter in searchFilters { searchFilter.reset() }
        publisher?.send()
    }
}
