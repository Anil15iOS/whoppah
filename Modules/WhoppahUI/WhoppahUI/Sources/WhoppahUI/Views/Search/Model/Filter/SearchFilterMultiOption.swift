//
//  SearchFilterMultiOption.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import Combine
import WhoppahModel

protocol SearchFilterIdentifiable {
    var filterId: String { get }
}

class SearchFilterMultiOption<T: SearchFilterValueInspectable & SearchFilterSingleSelectable & SearchFilterIdentifiable>:
    Equatable &
    SearchFiltering &
    SearchFilterMultiSelectable &
    SearchFilterInputConfigurable
{
    @Published var items: [SearchFilterSingleSelectable & SearchFilterValueInspectable & SearchFilterIdentifiable]
    
    let id = UUID()
    var filterId: String { id.uuidString }
    let filterType: SearchFilterType
    let searchFilterKey: SearchFilterKey?
    
    private weak var publisher: ObservableObjectPublisher?
    
    static func == (lhs: SearchFilterMultiOption<T>, rhs: SearchFilterMultiOption<T>) -> Bool {
        lhs.id == rhs.id &&
        lhs.items.count == rhs.items.count
    }
    
    var isActiveFilter: Bool { items.count > 0 }
    var filterLabel: String { "" }
    var count: Int { items.count }
    var attributeValue: String { "" }
    
    init(_ items: [T],
         type filterType: SearchFilterType,
         key: SearchFilterKey? = nil)
    {
        self.items = items
        self.filterType = filterType
        self.searchFilterKey = key
    }
    
    func reset() {
        items.removeAll()
    }

    func append(_ item: Item) {
        items.append(item)
        publisher?.send()
    }
    
    func remove(_ item: Item) {
        items.removeAll { $0.filterId == item.filterId }
        publisher?.send()
    }
    
    func removeLast(_ numItems: Int) {
        items.removeLast(numItems)
        publisher?.send()
    }
    
    func firstIndex(of item: Item) -> Int? {
        items.firstIndex { $0.filterId == item.filterId}
    }
    
    func contains(_ item: Item) -> Bool {
        items.contains { $0.filterId == item.filterId }
    }
    
    func replaceAll(with items: [Item]) {
        self.items.removeAll()
        self.items += items
        publisher?.send()
    }
    
    func registerPublisher(_ publisher: ObservableObjectPublisher?) {
        self.publisher = publisher
    }
    
    func from(input: SearchProductsInput,
              key: SearchFilterKey,
              attributesToMatch: [AbstractAttribute]?)
    {
        guard key == self.searchFilterKey,
              let attributesToMatch = attributesToMatch,
              let values = attributes(ofType: key,
                                      fromInput: input,
                                      matching: attributesToMatch) as? [Item]
        else { return }

        replaceAll(with: values)
    }
    
    private func attributes(ofType filterType: SearchFilterKey,
                            fromInput input: SearchProductsInput,
                            matching: [AbstractAttribute]) -> [AbstractAttribute]
    {
        var matches = [AbstractAttribute]()
        
        if let inputAttributes = input
            .filters?
            .compactMap({ $0.key == filterType ? $0.value : nil })
        {
            matching.forEach { attributeToMatch in
                if let _ = inputAttributes.first(where: { $0 == attributeToMatch.slug }) {
                    matches.append(attributeToMatch)
                }
            }
            
        }
        
        return matches
    }
}
