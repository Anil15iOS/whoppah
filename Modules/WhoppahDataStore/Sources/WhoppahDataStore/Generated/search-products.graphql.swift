// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class SearchProductsQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query searchProducts($query: String, $pagination: Pagination, $sort: SearchSort, $order: Ordering, $facets: [SearchFacetKey], $filters: [FilterInput]) {
        searchProducts(
          input: {query: $query, pagination: $pagination, sort: $sort, order: $order, facets: $facets, filters: $filters}
        ) {
          __typename
          pagination {
            __typename
            page
            pages
            count
          }
          facets {
            __typename
            key
            values {
              __typename
              value
              category {
                __typename
                id
                description
              }
              count
            }
          }
          items {
            __typename
            id
            title
            slug
            description
            state
            image {
              __typename
              id
              url
              type
              position
            }
            favorite {
              __typename
              id
              created
            }
            auction {
              __typename
              id
              identifier
              state
              product {
                __typename
                id
              }
              buy_now_price {
                __typename
                currency
                amount
              }
              minimum_bid {
                __typename
                currency
                amount
              }
              buy_now_price {
                __typename
                currency
                amount
              }
              allow_bid
              allow_buy_now
            }
            attributes {
              __typename
              ... on Label {
                __typename
                id
                slug
                title
                description
                hex
              }
            }
          }
        }
      }
      """

    public let operationName: String = "searchProducts"

    public var query: String?
    public var pagination: Pagination?
    public var sort: SearchSort?
    public var order: Ordering?
    public var facets: [SearchFacetKey?]?
    public var filters: [FilterInput?]?

    public init(query: String? = nil, pagination: Pagination? = nil, sort: SearchSort? = nil, order: Ordering? = nil, facets: [SearchFacetKey?]? = nil, filters: [FilterInput?]? = nil) {
      self.query = query
      self.pagination = pagination
      self.sort = sort
      self.order = order
      self.facets = facets
      self.filters = filters
    }

    public var variables: GraphQLMap? {
      return ["query": query, "pagination": pagination, "sort": sort, "order": order, "facets": facets, "filters": filters]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("searchProducts", arguments: ["input": ["query": GraphQLVariable("query"), "pagination": GraphQLVariable("pagination"), "sort": GraphQLVariable("sort"), "order": GraphQLVariable("order"), "facets": GraphQLVariable("facets"), "filters": GraphQLVariable("filters")]], type: .object(SearchProduct.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(searchProducts: SearchProduct? = nil) {
        self.init(unsafeResultMap: ["__typename": "Query", "searchProducts": searchProducts.flatMap { (value: SearchProduct) -> ResultMap in value.resultMap }])
      }

      public var searchProducts: SearchProduct? {
        get {
          return (resultMap["searchProducts"] as? ResultMap).flatMap { SearchProduct(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "searchProducts")
        }
      }

      public struct SearchProduct: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SearchProductsResult"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("pagination", type: .object(Pagination.selections)),
            GraphQLField("facets", type: .list(.object(Facet.selections))),
            GraphQLField("items", type: .list(.object(Item.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(pagination: Pagination? = nil, facets: [Facet?]? = nil, items: [Item?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "SearchProductsResult", "pagination": pagination.flatMap { (value: Pagination) -> ResultMap in value.resultMap }, "facets": facets.flatMap { (value: [Facet?]) -> [ResultMap?] in value.map { (value: Facet?) -> ResultMap? in value.flatMap { (value: Facet) -> ResultMap in value.resultMap } } }, "items": items.flatMap { (value: [Item?]) -> [ResultMap?] in value.map { (value: Item?) -> ResultMap? in value.flatMap { (value: Item) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var pagination: Pagination? {
          get {
            return (resultMap["pagination"] as? ResultMap).flatMap { Pagination(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "pagination")
          }
        }

        public var facets: [Facet?]? {
          get {
            return (resultMap["facets"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Facet?] in value.map { (value: ResultMap?) -> Facet? in value.flatMap { (value: ResultMap) -> Facet in Facet(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Facet?]) -> [ResultMap?] in value.map { (value: Facet?) -> ResultMap? in value.flatMap { (value: Facet) -> ResultMap in value.resultMap } } }, forKey: "facets")
          }
        }

        public var items: [Item?]? {
          get {
            return (resultMap["items"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Item?] in value.map { (value: ResultMap?) -> Item? in value.flatMap { (value: ResultMap) -> Item in Item(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Item?]) -> [ResultMap?] in value.map { (value: Item?) -> ResultMap? in value.flatMap { (value: Item) -> ResultMap in value.resultMap } } }, forKey: "items")
          }
        }

        public struct Pagination: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PaginationResult"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("page", type: .nonNull(.scalar(Int.self))),
              GraphQLField("pages", type: .nonNull(.scalar(Int.self))),
              GraphQLField("count", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(page: Int, pages: Int, count: Int) {
            self.init(unsafeResultMap: ["__typename": "PaginationResult", "page": page, "pages": pages, "count": count])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var page: Int {
            get {
              return resultMap["page"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "page")
            }
          }

          public var pages: Int {
            get {
              return resultMap["pages"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "pages")
            }
          }

          public var count: Int {
            get {
              return resultMap["count"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "count")
            }
          }
        }

        public struct Facet: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["SearchFacet"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("key", type: .scalar(SearchFacetKey.self)),
              GraphQLField("values", type: .list(.object(Value.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(key: SearchFacetKey? = nil, values: [Value?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "SearchFacet", "key": key, "values": values.flatMap { (value: [Value?]) -> [ResultMap?] in value.map { (value: Value?) -> ResultMap? in value.flatMap { (value: Value) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: SearchFacetKey? {
            get {
              return resultMap["key"] as? SearchFacetKey
            }
            set {
              resultMap.updateValue(newValue, forKey: "key")
            }
          }

          public var values: [Value?]? {
            get {
              return (resultMap["values"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Value?] in value.map { (value: ResultMap?) -> Value? in value.flatMap { (value: ResultMap) -> Value in Value(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Value?]) -> [ResultMap?] in value.map { (value: Value?) -> ResultMap? in value.flatMap { (value: Value) -> ResultMap in value.resultMap } } }, forKey: "values")
            }
          }

          public struct Value: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["SearchFacetValue"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("value", type: .scalar(String.self)),
                GraphQLField("category", type: .object(Category.selections)),
                GraphQLField("count", type: .scalar(Int.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(value: String? = nil, category: Category? = nil, count: Int? = nil) {
              self.init(unsafeResultMap: ["__typename": "SearchFacetValue", "value": value, "category": category.flatMap { (value: Category) -> ResultMap in value.resultMap }, "count": count])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var value: String? {
              get {
                return resultMap["value"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "value")
              }
            }

            public var category: Category? {
              get {
                return (resultMap["category"] as? ResultMap).flatMap { Category(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "category")
              }
            }

            public var count: Int? {
              get {
                return resultMap["count"] as? Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "count")
              }
            }

            public struct Category: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Category"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("description", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, description: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Category", "id": id, "description": description])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: UUID {
                get {
                  return resultMap["id"]! as! UUID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }

              public var description: String? {
                get {
                  return resultMap["description"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "description")
                }
              }
            }
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Product"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("state", type: .nonNull(.scalar(ProductState.self))),
              GraphQLField("image", type: .object(Image.selections)),
              GraphQLField("favorite", type: .object(Favorite.selections)),
              GraphQLField("auction", type: .object(Auction.selections)),
              GraphQLField("attributes", type: .nonNull(.list(.nonNull(.object(Attribute.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, title: String, slug: String, description: String? = nil, state: ProductState, image: Image? = nil, favorite: Favorite? = nil, auction: Auction? = nil, attributes: [Attribute]) {
            self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "slug": slug, "description": description, "state": state, "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }, "favorite": favorite.flatMap { (value: Favorite) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }, "attributes": attributes.map { (value: Attribute) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: UUID {
            get {
              return resultMap["id"]! as! UUID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          public var slug: String {
            get {
              return resultMap["slug"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "slug")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }

          public var state: ProductState {
            get {
              return resultMap["state"]! as! ProductState
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
            }
          }

          public var image: Image? {
            get {
              return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "image")
            }
          }

          public var favorite: Favorite? {
            get {
              return (resultMap["favorite"] as? ResultMap).flatMap { Favorite(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "favorite")
            }
          }

          public var auction: Auction? {
            get {
              return (resultMap["auction"] as? ResultMap).flatMap { Auction(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "auction")
            }
          }

          public var attributes: [Attribute] {
            get {
              return (resultMap["attributes"] as! [ResultMap]).map { (value: ResultMap) -> Attribute in Attribute(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Attribute) -> ResultMap in value.resultMap }, forKey: "attributes")
            }
          }

          public struct Image: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("url", type: .nonNull(.scalar(String.self))),
                GraphQLField("type", type: .nonNull(.scalar(ImageType.self))),
                GraphQLField("position", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, url: String, type: ImageType, position: Int) {
              self.init(unsafeResultMap: ["__typename": "Image", "id": id, "url": url, "type": type, "position": position])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: UUID {
              get {
                return resultMap["id"]! as! UUID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            public var url: String {
              get {
                return resultMap["url"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            public var type: ImageType {
              get {
                return resultMap["type"]! as! ImageType
              }
              set {
                resultMap.updateValue(newValue, forKey: "type")
              }
            }

            public var position: Int {
              get {
                return resultMap["position"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "position")
              }
            }
          }

          public struct Favorite: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Favorite"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, created: DateTime) {
              self.init(unsafeResultMap: ["__typename": "Favorite", "id": id, "created": created])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: UUID {
              get {
                return resultMap["id"]! as! UUID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            public var created: DateTime {
              get {
                return resultMap["created"]! as! DateTime
              }
              set {
                resultMap.updateValue(newValue, forKey: "created")
              }
            }
          }

          public struct Auction: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Auction"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("identifier", type: .nonNull(.scalar(String.self))),
                GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
                GraphQLField("product", type: .nonNull(.object(Product.selections))),
                GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
                GraphQLField("minimum_bid", type: .object(MinimumBid.selections)),
                GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
                GraphQLField("allow_bid", type: .nonNull(.scalar(Bool.self))),
                GraphQLField("allow_buy_now", type: .nonNull(.scalar(Bool.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, identifier: String, state: AuctionState, product: Product, buyNowPrice: BuyNowPrice? = nil, minimumBid: MinimumBid? = nil, allowBid: Bool, allowBuyNow: Bool) {
              self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "identifier": identifier, "state": state, "product": product.resultMap, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "minimum_bid": minimumBid.flatMap { (value: MinimumBid) -> ResultMap in value.resultMap }, "allow_bid": allowBid, "allow_buy_now": allowBuyNow])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: UUID {
              get {
                return resultMap["id"]! as! UUID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            public var identifier: String {
              get {
                return resultMap["identifier"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "identifier")
              }
            }

            public var state: AuctionState {
              get {
                return resultMap["state"]! as! AuctionState
              }
              set {
                resultMap.updateValue(newValue, forKey: "state")
              }
            }

            public var product: Product {
              get {
                return Product(unsafeResultMap: resultMap["product"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "product")
              }
            }

            public var buyNowPrice: BuyNowPrice? {
              get {
                return (resultMap["buy_now_price"] as? ResultMap).flatMap { BuyNowPrice(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "buy_now_price")
              }
            }

            public var minimumBid: MinimumBid? {
              get {
                return (resultMap["minimum_bid"] as? ResultMap).flatMap { MinimumBid(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "minimum_bid")
              }
            }

            public var allowBid: Bool {
              get {
                return resultMap["allow_bid"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "allow_bid")
              }
            }

            public var allowBuyNow: Bool {
              get {
                return resultMap["allow_buy_now"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "allow_buy_now")
              }
            }

            public struct Product: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Product"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID) {
                self.init(unsafeResultMap: ["__typename": "Product", "id": id])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: UUID {
                get {
                  return resultMap["id"]! as! UUID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }
            }

            public struct BuyNowPrice: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Price"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(currency: Currency, amount: Double) {
                self.init(unsafeResultMap: ["__typename": "Price", "currency": currency, "amount": amount])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var currency: Currency {
                get {
                  return resultMap["currency"]! as! Currency
                }
                set {
                  resultMap.updateValue(newValue, forKey: "currency")
                }
              }

              public var amount: Double {
                get {
                  return resultMap["amount"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "amount")
                }
              }
            }

            public struct MinimumBid: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Price"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(currency: Currency, amount: Double) {
                self.init(unsafeResultMap: ["__typename": "Price", "currency": currency, "amount": amount])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var currency: Currency {
                get {
                  return resultMap["currency"]! as! Currency
                }
                set {
                  resultMap.updateValue(newValue, forKey: "currency")
                }
              }

              public var amount: Double {
                get {
                  return resultMap["amount"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "amount")
                }
              }
            }
          }

          public struct Attribute: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLTypeCase(
                  variants: ["Label": AsLabel.selections],
                  default: [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  ]
                )
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public static func makeArtist() -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "Artist"])
            }

            public static func makeBrand() -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "Brand"])
            }

            public static func makeColor() -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "Color"])
            }

            public static func makeDesigner() -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "Designer"])
            }

            public static func makeMaterial() -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "Material"])
            }

            public static func makeStyle() -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "Style"])
            }

            public static func makeUsageSign() -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "UsageSign"])
            }

            public static func makeAdditionalInfo() -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "AdditionalInfo"])
            }

            public static func makeSubject() -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "Subject"])
            }

            public static func makeLabel(id: UUID, slug: String, title: String, description: String? = nil, hex: String? = nil) -> Attribute {
              return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "title": title, "description": description, "hex": hex])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var asLabel: AsLabel? {
              get {
                if !AsLabel.possibleTypes.contains(__typename) { return nil }
                return AsLabel(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsLabel: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Label"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                  GraphQLField("title", type: .nonNull(.scalar(String.self))),
                  GraphQLField("description", type: .scalar(String.self)),
                  GraphQLField("hex", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, slug: String, title: String, description: String? = nil, hex: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "title": title, "description": description, "hex": hex])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: UUID {
                get {
                  return resultMap["id"]! as! UUID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }

              public var slug: String {
                get {
                  return resultMap["slug"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "slug")
                }
              }

              public var title: String {
                get {
                  return resultMap["title"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "title")
                }
              }

              public var description: String? {
                get {
                  return resultMap["description"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "description")
                }
              }

              public var hex: String? {
                get {
                  return resultMap["hex"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "hex")
                }
              }
            }
          }
        }
      }
    }
  }
}
