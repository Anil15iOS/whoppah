//
//  SearchFilter.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import Combine
import WhoppahModel

class SearchFilter<T: SearchFilterResettable & SearchFilterValueInspectable & Equatable>:
    Equatable &
    SearchFiltering &
    SearchFilterSingleSelectable &
    SearchFilterInputConfigurable
{
    let id = UUID()
    var filterId: String { id.uuidString }
    let filterType: SearchFilterType
    let searchFilterKey: SearchFilterKey?
    var isActiveFilter: Bool { value.isActiveFilter }
    var attributeValue: String { value.attributeValue }
    
    private weak var publisher: ObservableObjectPublisher?
    
    @Published var value: T {
        willSet {
            publisher?.send()
        }
    }
    
    init(_ value: T,
         type filterType: SearchFilterType,
         key: SearchFilterKey? = nil)
    {
        self.value = value
        self.filterType = filterType
        self.searchFilterKey = key
    }
    
    func reset() {
        self.value.reset()
    }
    
    var filterLabel: String { value.filterLabel }
    
    func registerPublisher(_ publisher: ObservableObjectPublisher?) {
        self.publisher = publisher
        
        if let publishingValue = value as? SearchFilterPublisher {
            publishingValue.registerPublisher(publisher)
        }
    }
    
    func from(input: SearchProductsInput,
              key: SearchFilterKey,
              attributesToMatch: [AbstractAttribute]?)
    {
        guard key == self.searchFilterKey,
              var configurable = value as? SearchFilterInputConfigurable
        else { return }

        configurable.from(input: input,
                          key: key,
                          attributesToMatch: attributesToMatch)
    }
    
    static func == (lhs: SearchFilter<T>, rhs: SearchFilter<T>) -> Bool {
        lhs.id == rhs.id &&
        lhs.value == rhs.value
    }
}
