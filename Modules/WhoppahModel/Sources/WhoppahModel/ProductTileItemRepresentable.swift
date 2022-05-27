//
//  ProductTileItemRepresentable.swift
//  WhoppahModel
//
//  Created by Dennis Ippel on 18/03/2022.
//

import Foundation

public protocol ProductTileItemRepresentable {
    var id: UUID { get }
    var state: ProductState { get }
    var title: String { get }
    var slug: String { get }
    var description: String? { get }
    var favorite: Favorite? { get }
    var auction: Auction? { get }
    var image: Image? { get }
}
