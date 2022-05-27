//
//  Array+ProductSearchItemRepresentable.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 04/04/2022.
//

import Foundation
import WhoppahModel

extension Array where Element: ProductTileItemRepresentable {
    @discardableResult
    mutating func replaceFavorite(product: FavoritedProduct,
                                  replacementClosure: (Element) -> Element) -> Bool
    {
        guard let index = firstIndex(where: { $0.id == product.productId }),
              let item = first(where: { $0.id == product.productId })
        else { return false }

        let replacement = replacementClosure(item)
        
        remove(at: index)
        insert(replacement, at: index)
        return true
    }
}
