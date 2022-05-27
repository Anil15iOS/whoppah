// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetMerchantFavoritesQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getMerchantFavorites($id: UUID!, $playlist: PlaylistType = HLS) {
        merchant(id: $id) {
          __typename
          id
          favorites {
            __typename
            item {
              __typename
              ... on Product {
                __typename
                id
                title
                slug
                state
                width
                height
                favorite {
                  __typename
                  id
                }
                auction {
                  __typename
                  id
                  state
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
                  allow_bid
                  allow_buy_now
                }
                attributes {
                  __typename
                  ... on Label {
                    __typename
                    id
                    slug
                    description
                    color
                  }
                }
                images {
                  __typename
                  id
                  url
                }
                videos {
                  __typename
                  id
                  url(playlist: $playlist)
                  thumbnail(size: SM)
                }
                arobjects {
                  __typename
                  id
                  url
                  detection
                  allows_pan
                  allows_rotation
                  url
                  thumbnail(size: LG)
                  type
                }
              }
            }
          }
        }
      }
      """

    public let operationName: String = "getMerchantFavorites"

    public var id: UUID
    public var playlist: PlaylistType?

    public init(id: UUID, playlist: PlaylistType? = nil) {
      self.id = id
      self.playlist = playlist
    }

    public var variables: GraphQLMap? {
      return ["id": id, "playlist": playlist]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("merchant", arguments: ["id": GraphQLVariable("id")], type: .object(Merchant.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(merchant: Merchant? = nil) {
        self.init(unsafeResultMap: ["__typename": "Query", "merchant": merchant.flatMap { (value: Merchant) -> ResultMap in value.resultMap }])
      }

      public var merchant: Merchant? {
        get {
          return (resultMap["merchant"] as? ResultMap).flatMap { Merchant(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "merchant")
        }
      }

      public struct Merchant: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Merchant"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("favorites", type: .nonNull(.list(.nonNull(.object(Favorite.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, favorites: [Favorite]) {
          self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "favorites": favorites.map { (value: Favorite) -> ResultMap in value.resultMap }])
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

        public var favorites: [Favorite] {
          get {
            return (resultMap["favorites"] as! [ResultMap]).map { (value: ResultMap) -> Favorite in Favorite(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Favorite) -> ResultMap in value.resultMap }, forKey: "favorites")
          }
        }

        public struct Favorite: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Favorite"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("item", type: .nonNull(.object(Item.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(item: Item) {
            self.init(unsafeResultMap: ["__typename": "Favorite", "item": item.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var item: Item {
            get {
              return Item(unsafeResultMap: resultMap["item"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "item")
            }
          }

          public struct Item: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Product", "Merchant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLTypeCase(
                  variants: ["Product": AsProduct.selections],
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

            public static func makeMerchant() -> Item {
              return Item(unsafeResultMap: ["__typename": "Merchant"])
            }

            public static func makeProduct(id: UUID, title: String, slug: String, state: ProductState, width: Int? = nil, height: Int? = nil, favorite: AsProduct.Favorite? = nil, auction: AsProduct.Auction? = nil, attributes: [AsProduct.Attribute], images: [AsProduct.Image], videos: [AsProduct.Video], arobjects: [AsProduct.Arobject]) -> Item {
              return Item(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "slug": slug, "state": state, "width": width, "height": height, "favorite": favorite.flatMap { (value: AsProduct.Favorite) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: AsProduct.Auction) -> ResultMap in value.resultMap }, "attributes": attributes.map { (value: AsProduct.Attribute) -> ResultMap in value.resultMap }, "images": images.map { (value: AsProduct.Image) -> ResultMap in value.resultMap }, "videos": videos.map { (value: AsProduct.Video) -> ResultMap in value.resultMap }, "arobjects": arobjects.map { (value: AsProduct.Arobject) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var asProduct: AsProduct? {
              get {
                if !AsProduct.possibleTypes.contains(__typename) { return nil }
                return AsProduct(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsProduct: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Product"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("title", type: .nonNull(.scalar(String.self))),
                  GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                  GraphQLField("state", type: .nonNull(.scalar(ProductState.self))),
                  GraphQLField("width", type: .scalar(Int.self)),
                  GraphQLField("height", type: .scalar(Int.self)),
                  GraphQLField("favorite", type: .object(Favorite.selections)),
                  GraphQLField("auction", type: .object(Auction.selections)),
                  GraphQLField("attributes", type: .nonNull(.list(.nonNull(.object(Attribute.selections))))),
                  GraphQLField("images", type: .nonNull(.list(.nonNull(.object(Image.selections))))),
                  GraphQLField("videos", type: .nonNull(.list(.nonNull(.object(Video.selections))))),
                  GraphQLField("arobjects", type: .nonNull(.list(.nonNull(.object(Arobject.selections))))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, title: String, slug: String, state: ProductState, width: Int? = nil, height: Int? = nil, favorite: Favorite? = nil, auction: Auction? = nil, attributes: [Attribute], images: [Image], videos: [Video], arobjects: [Arobject]) {
                self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "slug": slug, "state": state, "width": width, "height": height, "favorite": favorite.flatMap { (value: Favorite) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }, "attributes": attributes.map { (value: Attribute) -> ResultMap in value.resultMap }, "images": images.map { (value: Image) -> ResultMap in value.resultMap }, "videos": videos.map { (value: Video) -> ResultMap in value.resultMap }, "arobjects": arobjects.map { (value: Arobject) -> ResultMap in value.resultMap }])
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

              public var state: ProductState {
                get {
                  return resultMap["state"]! as! ProductState
                }
                set {
                  resultMap.updateValue(newValue, forKey: "state")
                }
              }

              public var width: Int? {
                get {
                  return resultMap["width"] as? Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "width")
                }
              }

              public var height: Int? {
                get {
                  return resultMap["height"] as? Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "height")
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

              public var images: [Image] {
                get {
                  return (resultMap["images"] as! [ResultMap]).map { (value: ResultMap) -> Image in Image(unsafeResultMap: value) }
                }
                set {
                  resultMap.updateValue(newValue.map { (value: Image) -> ResultMap in value.resultMap }, forKey: "images")
                }
              }

              public var videos: [Video] {
                get {
                  return (resultMap["videos"] as! [ResultMap]).map { (value: ResultMap) -> Video in Video(unsafeResultMap: value) }
                }
                set {
                  resultMap.updateValue(newValue.map { (value: Video) -> ResultMap in value.resultMap }, forKey: "videos")
                }
              }

              public var arobjects: [Arobject] {
                get {
                  return (resultMap["arobjects"] as! [ResultMap]).map { (value: ResultMap) -> Arobject in Arobject(unsafeResultMap: value) }
                }
                set {
                  resultMap.updateValue(newValue.map { (value: Arobject) -> ResultMap in value.resultMap }, forKey: "arobjects")
                }
              }

              public struct Favorite: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Favorite"]

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
                  self.init(unsafeResultMap: ["__typename": "Favorite", "id": id])
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

              public struct Auction: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Auction"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
                    GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
                    GraphQLField("minimum_bid", type: .object(MinimumBid.selections)),
                    GraphQLField("allow_bid", type: .nonNull(.scalar(Bool.self))),
                    GraphQLField("allow_buy_now", type: .nonNull(.scalar(Bool.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, state: AuctionState, buyNowPrice: BuyNowPrice? = nil, minimumBid: MinimumBid? = nil, allowBid: Bool, allowBuyNow: Bool) {
                  self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "minimum_bid": minimumBid.flatMap { (value: MinimumBid) -> ResultMap in value.resultMap }, "allow_bid": allowBid, "allow_buy_now": allowBuyNow])
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

                public var state: AuctionState {
                  get {
                    return resultMap["state"]! as! AuctionState
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "state")
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

                public struct BuyNowPrice: GraphQLSelectionSet {
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

                public static func makeLabel(id: UUID, slug: String, description: String? = nil, color: String? = nil) -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "description": description, "color": color])
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
                      GraphQLField("description", type: .scalar(String.self)),
                      GraphQLField("color", type: .scalar(String.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, slug: String, description: String? = nil, color: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "description": description, "color": color])
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

                  public var description: String? {
                    get {
                      return resultMap["description"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "description")
                    }
                  }

                  @available(*, deprecated, message: "No longer supported")
                  public var color: String? {
                    get {
                      return resultMap["color"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "color")
                    }
                  }
                }
              }

              public struct Image: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Image"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("url", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, url: String) {
                  self.init(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
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
              }

              public struct Video: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Video"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("url", arguments: ["playlist": GraphQLVariable("playlist")], type: .nonNull(.scalar(String.self))),
                    GraphQLField("thumbnail", arguments: ["size": "SM"], type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, url: String, thumbnail: String) {
                  self.init(unsafeResultMap: ["__typename": "Video", "id": id, "url": url, "thumbnail": thumbnail])
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

                public var thumbnail: String {
                  get {
                    return resultMap["thumbnail"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "thumbnail")
                  }
                }
              }

              public struct Arobject: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ARObject"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("url", type: .nonNull(.scalar(String.self))),
                    GraphQLField("detection", type: .scalar(ARDetection.self)),
                    GraphQLField("allows_pan", type: .scalar(Bool.self)),
                    GraphQLField("allows_rotation", type: .scalar(Bool.self)),
                    GraphQLField("url", type: .nonNull(.scalar(String.self))),
                    GraphQLField("thumbnail", arguments: ["size": "LG"], type: .scalar(String.self)),
                    GraphQLField("type", type: .scalar(ARObjectType.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, url: String, detection: ARDetection? = nil, allowsPan: Bool? = nil, allowsRotation: Bool? = nil, thumbnail: String? = nil, type: ARObjectType? = nil) {
                  self.init(unsafeResultMap: ["__typename": "ARObject", "id": id, "url": url, "detection": detection, "allows_pan": allowsPan, "allows_rotation": allowsRotation, "thumbnail": thumbnail, "type": type])
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

                @available(*, deprecated, message: "Not required")
                public var detection: ARDetection? {
                  get {
                    return resultMap["detection"] as? ARDetection
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "detection")
                  }
                }

                @available(*, deprecated, message: "Not required")
                public var allowsPan: Bool? {
                  get {
                    return resultMap["allows_pan"] as? Bool
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "allows_pan")
                  }
                }

                @available(*, deprecated, message: "Not required")
                public var allowsRotation: Bool? {
                  get {
                    return resultMap["allows_rotation"] as? Bool
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "allows_rotation")
                  }
                }

                @available(*, deprecated, message: "Not required")
                public var thumbnail: String? {
                  get {
                    return resultMap["thumbnail"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "thumbnail")
                  }
                }

                @available(*, deprecated, message: "Not required")
                public var type: ARObjectType? {
                  get {
                    return resultMap["type"] as? ARObjectType
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "type")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
