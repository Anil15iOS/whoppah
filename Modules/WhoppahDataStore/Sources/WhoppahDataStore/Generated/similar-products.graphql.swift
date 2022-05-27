// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class SimilarProductsQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query similarProducts($user: UUID, $product: UUID!, $playlist: PlaylistType = HLS) {
        similarProducts(user: $user, product: $product) {
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
            allow_bid
            allow_buy_now
          }
          attributes {
            __typename
            ... on Label {
              __typename
              id
              slug
              color
              description
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
          arobject(platform: IOS) {
            __typename
            id
            thumbnail
            platform
            url
            type
            allows_pan
            allows_rotation
          }
        }
      }
      """

    public let operationName: String = "similarProducts"

    public var user: UUID?
    public var product: UUID
    public var playlist: PlaylistType?

    public init(user: UUID? = nil, product: UUID, playlist: PlaylistType? = nil) {
      self.user = user
      self.product = product
      self.playlist = playlist
    }

    public var variables: GraphQLMap? {
      return ["user": user, "product": product, "playlist": playlist]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("similarProducts", arguments: ["user": GraphQLVariable("user"), "product": GraphQLVariable("product")], type: .nonNull(.list(.nonNull(.object(SimilarProduct.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(similarProducts: [SimilarProduct]) {
        self.init(unsafeResultMap: ["__typename": "Query", "similarProducts": similarProducts.map { (value: SimilarProduct) -> ResultMap in value.resultMap }])
      }

      public var similarProducts: [SimilarProduct] {
        get {
          return (resultMap["similarProducts"] as! [ResultMap]).map { (value: ResultMap) -> SimilarProduct in SimilarProduct(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: SimilarProduct) -> ResultMap in value.resultMap }, forKey: "similarProducts")
        }
      }

      public struct SimilarProduct: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Product"]

        public static var selections: [GraphQLSelection] {
          return [
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
            GraphQLField("arobject", arguments: ["platform": "IOS"], type: .object(Arobject.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, title: String, slug: String, state: ProductState, width: Int? = nil, height: Int? = nil, favorite: Favorite? = nil, auction: Auction? = nil, attributes: [Attribute], images: [Image], videos: [Video], arobject: Arobject? = nil) {
          self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "slug": slug, "state": state, "width": width, "height": height, "favorite": favorite.flatMap { (value: Favorite) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }, "attributes": attributes.map { (value: Attribute) -> ResultMap in value.resultMap }, "images": images.map { (value: Image) -> ResultMap in value.resultMap }, "videos": videos.map { (value: Video) -> ResultMap in value.resultMap }, "arobject": arobject.flatMap { (value: Arobject) -> ResultMap in value.resultMap }])
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

        public var arobject: Arobject? {
          get {
            return (resultMap["arobject"] as? ResultMap).flatMap { Arobject(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "arobject")
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
              GraphQLField("allow_bid", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("allow_buy_now", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, state: AuctionState, buyNowPrice: BuyNowPrice? = nil, allowBid: Bool, allowBuyNow: Bool) {
            self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "allow_bid": allowBid, "allow_buy_now": allowBuyNow])
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

          public static func makeLabel(id: UUID, slug: String, color: String? = nil, description: String? = nil) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
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
                GraphQLField("color", type: .scalar(String.self)),
                GraphQLField("description", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, slug: String, color: String? = nil, description: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
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

            @available(*, deprecated, message: "No longer supported")
            public var color: String? {
              get {
                return resultMap["color"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "color")
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
              GraphQLField("thumbnail", type: .scalar(String.self)),
              GraphQLField("platform", type: .nonNull(.scalar(ARPlatform.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .scalar(ARObjectType.self)),
              GraphQLField("allows_pan", type: .scalar(Bool.self)),
              GraphQLField("allows_rotation", type: .scalar(Bool.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, thumbnail: String? = nil, platform: ARPlatform, url: String, type: ARObjectType? = nil, allowsPan: Bool? = nil, allowsRotation: Bool? = nil) {
            self.init(unsafeResultMap: ["__typename": "ARObject", "id": id, "thumbnail": thumbnail, "platform": platform, "url": url, "type": type, "allows_pan": allowsPan, "allows_rotation": allowsRotation])
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

          @available(*, deprecated, message: "Not required")
          public var thumbnail: String? {
            get {
              return resultMap["thumbnail"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "thumbnail")
            }
          }

          public var platform: ARPlatform {
            get {
              return resultMap["platform"]! as! ARPlatform
            }
            set {
              resultMap.updateValue(newValue, forKey: "platform")
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
          public var type: ARObjectType? {
            get {
              return resultMap["type"] as? ARObjectType
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
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
        }
      }
    }
  }
}
