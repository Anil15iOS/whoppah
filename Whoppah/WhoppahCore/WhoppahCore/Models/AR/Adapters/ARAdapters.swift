//
//  ARAdapters.swift
//  WhoppahCore
//
//  Created by Eddie Long on 05/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahDataStore

extension GraphQL.ProductQuery.Data.Product.Arobject: LegacyARObject {
    public var allowsPan: Bool { true }
    public var allowsRotation: Bool { true  }
    public var image: URL? { nil }
    public var downloadUrl: URL? { URL(string: url) }
    public var detection: GraphQL.ARDetection { .horizontal }
}

extension GraphQL.ProductsQuery.Data.Product.Item.Arobject: LegacyARObject {
    public var allowsPan: Bool { true }
    public var allowsRotation: Bool { true  }
    public var image: URL? { nil }
    public var downloadUrl: URL? { URL(string: url) }
    public var detection: GraphQL.ARDetection { .horizontal }
}

extension GraphQL.OrdersQuery.Data.Order.Item.Product.Arobject: LegacyARObject {
    public var allowsPan: Bool { true }
    public var allowsRotation: Bool { true  }
    public var image: URL? { nil }
    public var downloadUrl: URL? { URL(string: url) }
    public var detection: GraphQL.ARDetection { .horizontal }
}

extension GraphQL.GetPageQuery.Data.PageByKey.Block.AsProductBlock.Product.Arobject: LegacyARObject {
    public var allowsPan: Bool { true }
    public var allowsRotation: Bool { true  }
    public var image: URL? { nil }
    public var downloadUrl: URL? { URL(string: url) }
    public var detection: GraphQL.ARDetection { .horizontal }
}

extension GraphQL.SearchQuery.Data.Search.Item.AsProduct.Arobject: LegacyARObject {
    public var allowsPan: Bool { true }
    public var allowsRotation: Bool { true  }
    public var image: URL? { nil }
    public var downloadUrl: URL? { URL(string: url) }
    public var detection: GraphQL.ARDetection { .horizontal }
}

extension GraphQL.GetMerchantFavoritesQuery.Data.Merchant.Favorite.Item.AsProduct.Arobject: LegacyARObject {
    public var allowsPan: Bool { true }
    public var allowsRotation: Bool { true  }
    public var image: URL? { nil }
    public var downloadUrl: URL? { URL(string: url) }
    public var detection: GraphQL.ARDetection { .horizontal }
}

extension GraphQL.RecommendedProductsQuery.Data.RecommendedProduct.Arobject: LegacyARObject {
    public var allowsPan: Bool { true }
    public var allowsRotation: Bool { true  }
    public var image: URL? { nil }
    public var downloadUrl: URL? { URL(string: url) }
    public var detection: GraphQL.ARDetection { .horizontal }
}
