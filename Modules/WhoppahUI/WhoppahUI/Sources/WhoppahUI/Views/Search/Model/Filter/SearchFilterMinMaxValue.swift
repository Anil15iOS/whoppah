//
//  SearchFilterMinMaxValue.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation
import WhoppahModel
import Combine

class SearchFilterMinMaxValue: Equatable &
            SearchFilterResettable &
            SearchFilterValueInspectable &
            SearchFilterInputConfigurable &
            SearchFilterPublisher
{
    static func == (lhs: SearchFilterMinMaxValue, rhs: SearchFilterMinMaxValue) -> Bool {
        lhs.min == rhs.min && lhs.max == rhs.max
    }
    
    let id = UUID()
    
    var min: String = .empty {
        willSet { publisher?.send() }
    }
    var max: String = .empty {
        willSet { publisher?.send() }
    }
    var valuePostfix: String
    
    private weak var publisher: ObservableObjectPublisher?
    
    init(valuePostfix: String) {
        self.valuePostfix = valuePostfix
    }
    
    func reset() {
        min = .empty
        max = .empty
    }
    
    func from(input: SearchProductsInput,
              key: SearchFilterKey,
              attributesToMatch: [AbstractAttribute]?)
    {
        guard let value = input.filters?.compactMap({ $0.key == key ? $0.value: nil }).first else { return }
        parse(value: value)
    }
    
    func registerPublisher(_ publisher: ObservableObjectPublisher?) {
        self.publisher = publisher
    }
    
    private func parse(value: String?) {
        if let inputPrice = value,
           let priceMin = inputPrice.components(separatedBy: ",").first,
           let priceMax = inputPrice.components(separatedBy: ",").last,
           let _ = Int(priceMin),
           let _ = Int(priceMax)
        {
            self.min = priceMin
            self.max = priceMax
        } else {
            reset()
        }
    }
    
    private func concatenate(withSeparator separator: String) -> String {
        let minValue = Int(min) ?? 0
        let maxValue = Int(max) ?? Int.max
        
        return "\(minValue)\(separator)\(maxValue)"
    }
    
    var attributeValue: String {
        concatenate(withSeparator: ",")
    }
    
    var isActiveFilter: Bool {
        return !(min.isEmpty && max.isEmpty)
    }
    
    var filterLabel: String {
        concatenate(withSeparator: " - ").appending(valuePostfix.isEmpty ? "" : " \(valuePostfix)")
    }
}
