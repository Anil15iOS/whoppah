//
//  SearchFilterMultiSelectable.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 07/04/2022.
//

import Foundation

protocol SearchFilterMultiSelectable {
    typealias Item = SearchFilterValueInspectable & SearchFilterSingleSelectable & SearchFilterIdentifiable
    var items: [Item] { get }
    var count: Int { get }
    func append(_ item: Item)
    func remove(_ item: Item)
    func removeLast(_ numItems: Int)
    func firstIndex(of item: Item) -> Int?
    func contains(_ item: Item) -> Bool
    func replaceAll(with items: [Item])
}
