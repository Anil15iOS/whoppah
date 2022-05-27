//
//  WhoppahUI+MockSearchClient.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/03/2022.
//

import Foundation
import WhoppahModel
import SwiftUI
import ComposableArchitecture

extension WhoppahUI.SearchClient {
    private static var currentSet = [ProductTileItem]()
    private static var currentLimit: Int = 25
    
    private static func generateCompleteSet() {
        var searchItems = [ProductTileItem]()
        
        for _ in 0..<500 {
            var attributes: [AbstractAttribute]? = nil
            
            if Int.random(in: 0...3) == 0 {
                attributes = [AbstractAttribute]()
                for _ in 0..<Int.random(in: 1...3) {
                    attributes?.append(WhoppahModel.Label.random)
                }
            }
            
            let id = UUID()
            let imageWidth = Int.random(in: 200...600)
            let imageHeight = Int.random(in: 200...600)
            let searchItem = ProductTileItem(
                id: id,
                state: .accepted,
                title: RandomWord.randomWords(1...6),
                slug: id.uuidString,
                description: "Description of product \(id.uuidString).",
                favorite: Int.random(in: 0...3) == 0 ? .init(id: UUID(), created: Date()) : nil,
                auction: Auction.random,
                image: Image(id: id,
                             url: "https://picsum.photos/\(imageWidth)/\(imageHeight)?id=\(id.uuidString)",
                             type: .cover,
                             position: 0),
            attributes: attributes)
            searchItems.append(searchItem)
        }
        
        currentSet = searchItems
    }
    
    static let mockClient = WhoppahUI.SearchClient(search: { search in
        let pageIndex = search.pagination?.page ?? 1
        
        if pageIndex == 1 {
            generateCompleteSet()
        }
        
        let lowerBound = currentLimit * (pageIndex - 1)
        let upperBound = min(lowerBound + currentLimit, currentSet.count)
        
        let resultsSet = ProductSearchResultsSet(
            items: Array(currentSet[lowerBound..<upperBound]),
            pagination: .init(page: pageIndex,
                              pages: currentSet.count / currentLimit,
                              count: currentSet.count),
            facets: [])
        
        return Effect(value: resultsSet)
            .eraseToEffect()
    }, saveSearch: { searchInput in
        return Effect(value: true)
            .delay(for: 1.0, scheduler: DispatchQueue.main)
            .eraseToEffect()
    })
}
