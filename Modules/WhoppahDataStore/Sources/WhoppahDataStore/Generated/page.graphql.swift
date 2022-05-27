// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetPageQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getPage($key: PageFilterKey = SLUG, $value: String!, $playlist: PlaylistType = HLS) {
        pageByKey(key: $key, value: $value) {
          __typename
          id
          title
          blocks {
            __typename
            ... on ProductBlock {
              __typename
              id
              title
              slug
              link
              products {
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
            ... on TextBlock {
              __typename
              id
              title
              summary
              link
              slug
              image
              sections {
                __typename
                ... on TextSection {
                  __typename
                  id
                  slug
                  title
                  image
                  description
                  button
                  link
                }
              }
            }
            ... on MerchantBlock {
              __typename
              id
              title
              slug
              link
              merchants {
                __typename
                id
                slug
                type
                name
                business_name
                avatar: image(type: AVATAR) {
                  __typename
                  id
                  url
                }
              }
            }
            ... on CategoryBlock {
              __typename
              id
              title
              slug
              link
              categories {
                __typename
                id
                title
                slug
                categoryImage: image {
                  __typename
                  id
                  url
                }
              }
            }
            ... on AttributeBlock {
              __typename
              id
              link
              location
              title
              slug
              attributes {
                __typename
                ... on Artist {
                  __typename
                  id
                  title
                  slug
                  description
                  images: media(type: IMAGE) {
                    __typename
                    ... on Image {
                      __typename
                      url
                    }
                  }
                }
                ... on Brand {
                  __typename
                  id
                  title
                  slug
                  description
                  images: media(type: IMAGE) {
                    __typename
                    ... on Image {
                      __typename
                      url
                    }
                  }
                }
                ... on Color {
                  __typename
                  id
                  title
                  slug
                  hex
                  description
                  images: media(type: IMAGE) {
                    __typename
                    ... on Image {
                      __typename
                      url
                    }
                  }
                }
                ... on Designer {
                  __typename
                  id
                  title
                  slug
                  description
                  images: media(type: IMAGE) {
                    __typename
                    ... on Image {
                      __typename
                      url
                    }
                  }
                }
                ... on Material {
                  __typename
                  id
                  title
                  slug
                  description
                  images: media(type: IMAGE) {
                    __typename
                    ... on Image {
                      __typename
                      url
                    }
                  }
                }
                ... on Style {
                  __typename
                  id
                  title
                  slug
                  description
                  images: media(type: IMAGE) {
                    __typename
                    ... on Image {
                      __typename
                      url
                    }
                  }
                }
              }
            }
          }
        }
      }
      """

    public let operationName: String = "getPage"

    public var key: PageFilterKey?
    public var value: String
    public var playlist: PlaylistType?

    public init(key: PageFilterKey? = nil, value: String, playlist: PlaylistType? = nil) {
      self.key = key
      self.value = value
      self.playlist = playlist
    }

    public var variables: GraphQLMap? {
      return ["key": key, "value": value, "playlist": playlist]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("pageByKey", arguments: ["key": GraphQLVariable("key"), "value": GraphQLVariable("value")], type: .object(PageByKey.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(pageByKey: PageByKey? = nil) {
        self.init(unsafeResultMap: ["__typename": "Query", "pageByKey": pageByKey.flatMap { (value: PageByKey) -> ResultMap in value.resultMap }])
      }

      public var pageByKey: PageByKey? {
        get {
          return (resultMap["pageByKey"] as? ResultMap).flatMap { PageByKey(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "pageByKey")
        }
      }

      public struct PageByKey: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Page"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
            GraphQLField("blocks", type: .nonNull(.list(.nonNull(.object(Block.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, title: String, blocks: [Block]) {
          self.init(unsafeResultMap: ["__typename": "Page", "id": id, "title": title, "blocks": blocks.map { (value: Block) -> ResultMap in value.resultMap }])
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

        public var blocks: [Block] {
          get {
            return (resultMap["blocks"] as! [ResultMap]).map { (value: ResultMap) -> Block in Block(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Block) -> ResultMap in value.resultMap }, forKey: "blocks")
          }
        }

        public struct Block: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["AttributeBlock", "CategoryBlock", "MerchantBlock", "MemberBlock", "ImageBlock", "AudioBlock", "VideoBlock", "QueryBlock", "ProductBlock", "TextBlock"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLTypeCase(
                variants: ["ProductBlock": AsProductBlock.selections, "TextBlock": AsTextBlock.selections, "MerchantBlock": AsMerchantBlock.selections, "CategoryBlock": AsCategoryBlock.selections, "AttributeBlock": AsAttributeBlock.selections],
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

          public static func makeMemberBlock() -> Block {
            return Block(unsafeResultMap: ["__typename": "MemberBlock"])
          }

          public static func makeImageBlock() -> Block {
            return Block(unsafeResultMap: ["__typename": "ImageBlock"])
          }

          public static func makeAudioBlock() -> Block {
            return Block(unsafeResultMap: ["__typename": "AudioBlock"])
          }

          public static func makeVideoBlock() -> Block {
            return Block(unsafeResultMap: ["__typename": "VideoBlock"])
          }

          public static func makeQueryBlock() -> Block {
            return Block(unsafeResultMap: ["__typename": "QueryBlock"])
          }

          public static func makeProductBlock(id: UUID, title: String, slug: String, link: String? = nil, products: [AsProductBlock.Product]) -> Block {
            return Block(unsafeResultMap: ["__typename": "ProductBlock", "id": id, "title": title, "slug": slug, "link": link, "products": products.map { (value: AsProductBlock.Product) -> ResultMap in value.resultMap }])
          }

          public static func makeTextBlock(id: UUID, title: String, summary: String? = nil, link: String? = nil, slug: String, image: String, sections: [AsTextBlock.Section]) -> Block {
            return Block(unsafeResultMap: ["__typename": "TextBlock", "id": id, "title": title, "summary": summary, "link": link, "slug": slug, "image": image, "sections": sections.map { (value: AsTextBlock.Section) -> ResultMap in value.resultMap }])
          }

          public static func makeMerchantBlock(id: UUID, title: String, slug: String, link: String? = nil, merchants: [AsMerchantBlock.Merchant]) -> Block {
            return Block(unsafeResultMap: ["__typename": "MerchantBlock", "id": id, "title": title, "slug": slug, "link": link, "merchants": merchants.map { (value: AsMerchantBlock.Merchant) -> ResultMap in value.resultMap }])
          }

          public static func makeCategoryBlock(id: UUID, title: String, slug: String, link: String? = nil, categories: [AsCategoryBlock.Category]) -> Block {
            return Block(unsafeResultMap: ["__typename": "CategoryBlock", "id": id, "title": title, "slug": slug, "link": link, "categories": categories.map { (value: AsCategoryBlock.Category) -> ResultMap in value.resultMap }])
          }

          public static func makeAttributeBlock(id: UUID, link: String? = nil, location: BlockLocation? = nil, title: String, slug: String, attributes: [AsAttributeBlock.Attribute]) -> Block {
            return Block(unsafeResultMap: ["__typename": "AttributeBlock", "id": id, "link": link, "location": location, "title": title, "slug": slug, "attributes": attributes.map { (value: AsAttributeBlock.Attribute) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asProductBlock: AsProductBlock? {
            get {
              if !AsProductBlock.possibleTypes.contains(__typename) { return nil }
              return AsProductBlock(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsProductBlock: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ProductBlock"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                GraphQLField("link", type: .scalar(String.self)),
                GraphQLField("products", type: .nonNull(.list(.nonNull(.object(Product.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String, link: String? = nil, products: [Product]) {
              self.init(unsafeResultMap: ["__typename": "ProductBlock", "id": id, "title": title, "slug": slug, "link": link, "products": products.map { (value: Product) -> ResultMap in value.resultMap }])
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

            public var link: String? {
              get {
                return resultMap["link"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "link")
              }
            }

            public var products: [Product] {
              get {
                return (resultMap["products"] as! [ResultMap]).map { (value: ResultMap) -> Product in Product(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Product) -> ResultMap in value.resultMap }, forKey: "products")
              }
            }

            public struct Product: GraphQLSelectionSet {
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

          public var asTextBlock: AsTextBlock? {
            get {
              if !AsTextBlock.possibleTypes.contains(__typename) { return nil }
              return AsTextBlock(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsTextBlock: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["TextBlock"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("summary", type: .scalar(String.self)),
                GraphQLField("link", type: .scalar(String.self)),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                GraphQLField("image", type: .nonNull(.scalar(String.self))),
                GraphQLField("sections", type: .nonNull(.list(.nonNull(.object(Section.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, summary: String? = nil, link: String? = nil, slug: String, image: String, sections: [Section]) {
              self.init(unsafeResultMap: ["__typename": "TextBlock", "id": id, "title": title, "summary": summary, "link": link, "slug": slug, "image": image, "sections": sections.map { (value: Section) -> ResultMap in value.resultMap }])
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

            public var summary: String? {
              get {
                return resultMap["summary"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "summary")
              }
            }

            public var link: String? {
              get {
                return resultMap["link"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "link")
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

            public var image: String {
              get {
                return resultMap["image"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "image")
              }
            }

            public var sections: [Section] {
              get {
                return (resultMap["sections"] as! [ResultMap]).map { (value: ResultMap) -> Section in Section(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Section) -> ResultMap in value.resultMap }, forKey: "sections")
              }
            }

            public struct Section: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["TextSection"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                  GraphQLField("title", type: .scalar(String.self)),
                  GraphQLField("image", type: .nonNull(.scalar(String.self))),
                  GraphQLField("description", type: .scalar(String.self)),
                  GraphQLField("button", type: .scalar(String.self)),
                  GraphQLField("link", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, slug: String, title: String? = nil, image: String, description: String? = nil, button: String? = nil, link: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "TextSection", "id": id, "slug": slug, "title": title, "image": image, "description": description, "button": button, "link": link])
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

              public var title: String? {
                get {
                  return resultMap["title"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "title")
                }
              }

              public var image: String {
                get {
                  return resultMap["image"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "image")
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

              public var button: String? {
                get {
                  return resultMap["button"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "button")
                }
              }

              public var link: String? {
                get {
                  return resultMap["link"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "link")
                }
              }
            }
          }

          public var asMerchantBlock: AsMerchantBlock? {
            get {
              if !AsMerchantBlock.possibleTypes.contains(__typename) { return nil }
              return AsMerchantBlock(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsMerchantBlock: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MerchantBlock"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                GraphQLField("link", type: .scalar(String.self)),
                GraphQLField("merchants", type: .nonNull(.list(.nonNull(.object(Merchant.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String, link: String? = nil, merchants: [Merchant]) {
              self.init(unsafeResultMap: ["__typename": "MerchantBlock", "id": id, "title": title, "slug": slug, "link": link, "merchants": merchants.map { (value: Merchant) -> ResultMap in value.resultMap }])
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

            public var link: String? {
              get {
                return resultMap["link"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "link")
              }
            }

            public var merchants: [Merchant] {
              get {
                return (resultMap["merchants"] as! [ResultMap]).map { (value: ResultMap) -> Merchant in Merchant(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Merchant) -> ResultMap in value.resultMap }, forKey: "merchants")
              }
            }

            public struct Merchant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Merchant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                  GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("business_name", type: .scalar(String.self)),
                  GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, slug: String, type: MerchantType, name: String, businessName: String? = nil, avatar: Avatar? = nil) {
                self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "slug": slug, "type": type, "name": name, "business_name": businessName, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

              public var type: MerchantType {
                get {
                  return resultMap["type"]! as! MerchantType
                }
                set {
                  resultMap.updateValue(newValue, forKey: "type")
                }
              }

              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              public var businessName: String? {
                get {
                  return resultMap["business_name"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "business_name")
                }
              }

              public var avatar: Avatar? {
                get {
                  return (resultMap["avatar"] as? ResultMap).flatMap { Avatar(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "avatar")
                }
              }

              public struct Avatar: GraphQLSelectionSet {
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
            }
          }

          public var asCategoryBlock: AsCategoryBlock? {
            get {
              if !AsCategoryBlock.possibleTypes.contains(__typename) { return nil }
              return AsCategoryBlock(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsCategoryBlock: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["CategoryBlock"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                GraphQLField("link", type: .scalar(String.self)),
                GraphQLField("categories", type: .nonNull(.list(.nonNull(.object(Category.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String, link: String? = nil, categories: [Category]) {
              self.init(unsafeResultMap: ["__typename": "CategoryBlock", "id": id, "title": title, "slug": slug, "link": link, "categories": categories.map { (value: Category) -> ResultMap in value.resultMap }])
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

            public var link: String? {
              get {
                return resultMap["link"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "link")
              }
            }

            public var categories: [Category] {
              get {
                return (resultMap["categories"] as! [ResultMap]).map { (value: ResultMap) -> Category in Category(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Category) -> ResultMap in value.resultMap }, forKey: "categories")
              }
            }

            public struct Category: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Category"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("title", type: .nonNull(.scalar(String.self))),
                  GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                  GraphQLField("image", alias: "categoryImage", type: .object(CategoryImage.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, title: String, slug: String, categoryImage: CategoryImage? = nil) {
                self.init(unsafeResultMap: ["__typename": "Category", "id": id, "title": title, "slug": slug, "categoryImage": categoryImage.flatMap { (value: CategoryImage) -> ResultMap in value.resultMap }])
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

              public var categoryImage: CategoryImage? {
                get {
                  return (resultMap["categoryImage"] as? ResultMap).flatMap { CategoryImage(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "categoryImage")
                }
              }

              public struct CategoryImage: GraphQLSelectionSet {
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
            }
          }

          public var asAttributeBlock: AsAttributeBlock? {
            get {
              if !AsAttributeBlock.possibleTypes.contains(__typename) { return nil }
              return AsAttributeBlock(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsAttributeBlock: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["AttributeBlock"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("link", type: .scalar(String.self)),
                GraphQLField("location", type: .scalar(BlockLocation.self)),
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                GraphQLField("attributes", type: .nonNull(.list(.nonNull(.object(Attribute.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, link: String? = nil, location: BlockLocation? = nil, title: String, slug: String, attributes: [Attribute]) {
              self.init(unsafeResultMap: ["__typename": "AttributeBlock", "id": id, "link": link, "location": location, "title": title, "slug": slug, "attributes": attributes.map { (value: Attribute) -> ResultMap in value.resultMap }])
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

            public var link: String? {
              get {
                return resultMap["link"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "link")
              }
            }

            public var location: BlockLocation? {
              get {
                return resultMap["location"] as? BlockLocation
              }
              set {
                resultMap.updateValue(newValue, forKey: "location")
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

            public var attributes: [Attribute] {
              get {
                return (resultMap["attributes"] as! [ResultMap]).map { (value: ResultMap) -> Attribute in Attribute(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Attribute) -> ResultMap in value.resultMap }, forKey: "attributes")
              }
            }

            public struct Attribute: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLTypeCase(
                    variants: ["Artist": AsArtist.selections, "Brand": AsBrand.selections, "Color": AsColor.selections, "Designer": AsDesigner.selections, "Material": AsMaterial.selections, "Style": AsStyle.selections],
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

              public static func makeLabel() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Label"])
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

              public static func makeArtist(id: UUID, title: String, slug: String, description: String? = nil, images: [AsArtist.Image]) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: AsArtist.Image) -> ResultMap in value.resultMap }])
              }

              public static func makeBrand(id: UUID, title: String, slug: String, description: String? = nil, images: [AsBrand.Image]) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: AsBrand.Image) -> ResultMap in value.resultMap }])
              }

              public static func makeColor(id: UUID, title: String, slug: String, hex: String, description: String? = nil, images: [AsColor.Image]) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "slug": slug, "hex": hex, "description": description, "images": images.map { (value: AsColor.Image) -> ResultMap in value.resultMap }])
              }

              public static func makeDesigner(id: UUID, title: String, slug: String, description: String? = nil, images: [AsDesigner.Image]) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: AsDesigner.Image) -> ResultMap in value.resultMap }])
              }

              public static func makeMaterial(id: UUID, title: String, slug: String, description: String? = nil, images: [AsMaterial.Image]) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Material", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: AsMaterial.Image) -> ResultMap in value.resultMap }])
              }

              public static func makeStyle(id: UUID, title: String, slug: String, description: String? = nil, images: [AsStyle.Image]) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Style", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: AsStyle.Image) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var asArtist: AsArtist? {
                get {
                  if !AsArtist.possibleTypes.contains(__typename) { return nil }
                  return AsArtist(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsArtist: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Artist"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                    GraphQLField("media", alias: "images", arguments: ["type": "IMAGE"], type: .nonNull(.list(.nonNull(.object(Image.selections))))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, description: String? = nil, images: [Image]) {
                  self.init(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: Image) -> ResultMap in value.resultMap }])
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

                public var images: [Image] {
                  get {
                    return (resultMap["images"] as! [ResultMap]).map { (value: ResultMap) -> Image in Image(unsafeResultMap: value) }
                  }
                  set {
                    resultMap.updateValue(newValue.map { (value: Image) -> ResultMap in value.resultMap }, forKey: "images")
                  }
                }

                public struct Image: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLTypeCase(
                        variants: ["Image": AsImage.selections],
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

                  public static func makeAudio() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Audio"])
                  }

                  public static func makeDocument() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Document"])
                  }

                  public static func makeARObject() -> Image {
                    return Image(unsafeResultMap: ["__typename": "ARObject"])
                  }

                  public static func makeVideo() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Video"])
                  }

                  public static func makeImage(url: String) -> Image {
                    return Image(unsafeResultMap: ["__typename": "Image", "url": url])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var asImage: AsImage? {
                    get {
                      if !AsImage.possibleTypes.contains(__typename) { return nil }
                      return AsImage(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsImage: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Image"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("url", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(url: String) {
                      self.init(unsafeResultMap: ["__typename": "Image", "url": url])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
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
                }
              }

              public var asBrand: AsBrand? {
                get {
                  if !AsBrand.possibleTypes.contains(__typename) { return nil }
                  return AsBrand(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsBrand: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Brand"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                    GraphQLField("media", alias: "images", arguments: ["type": "IMAGE"], type: .nonNull(.list(.nonNull(.object(Image.selections))))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, description: String? = nil, images: [Image]) {
                  self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: Image) -> ResultMap in value.resultMap }])
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

                public var images: [Image] {
                  get {
                    return (resultMap["images"] as! [ResultMap]).map { (value: ResultMap) -> Image in Image(unsafeResultMap: value) }
                  }
                  set {
                    resultMap.updateValue(newValue.map { (value: Image) -> ResultMap in value.resultMap }, forKey: "images")
                  }
                }

                public struct Image: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLTypeCase(
                        variants: ["Image": AsImage.selections],
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

                  public static func makeAudio() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Audio"])
                  }

                  public static func makeDocument() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Document"])
                  }

                  public static func makeARObject() -> Image {
                    return Image(unsafeResultMap: ["__typename": "ARObject"])
                  }

                  public static func makeVideo() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Video"])
                  }

                  public static func makeImage(url: String) -> Image {
                    return Image(unsafeResultMap: ["__typename": "Image", "url": url])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var asImage: AsImage? {
                    get {
                      if !AsImage.possibleTypes.contains(__typename) { return nil }
                      return AsImage(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsImage: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Image"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("url", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(url: String) {
                      self.init(unsafeResultMap: ["__typename": "Image", "url": url])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
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
                }
              }

              public var asColor: AsColor? {
                get {
                  if !AsColor.possibleTypes.contains(__typename) { return nil }
                  return AsColor(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsColor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Color"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("hex", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                    GraphQLField("media", alias: "images", arguments: ["type": "IMAGE"], type: .nonNull(.list(.nonNull(.object(Image.selections))))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, hex: String, description: String? = nil, images: [Image]) {
                  self.init(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "slug": slug, "hex": hex, "description": description, "images": images.map { (value: Image) -> ResultMap in value.resultMap }])
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

                public var hex: String {
                  get {
                    return resultMap["hex"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "hex")
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

                public var images: [Image] {
                  get {
                    return (resultMap["images"] as! [ResultMap]).map { (value: ResultMap) -> Image in Image(unsafeResultMap: value) }
                  }
                  set {
                    resultMap.updateValue(newValue.map { (value: Image) -> ResultMap in value.resultMap }, forKey: "images")
                  }
                }

                public struct Image: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLTypeCase(
                        variants: ["Image": AsImage.selections],
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

                  public static func makeAudio() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Audio"])
                  }

                  public static func makeDocument() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Document"])
                  }

                  public static func makeARObject() -> Image {
                    return Image(unsafeResultMap: ["__typename": "ARObject"])
                  }

                  public static func makeVideo() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Video"])
                  }

                  public static func makeImage(url: String) -> Image {
                    return Image(unsafeResultMap: ["__typename": "Image", "url": url])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var asImage: AsImage? {
                    get {
                      if !AsImage.possibleTypes.contains(__typename) { return nil }
                      return AsImage(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsImage: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Image"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("url", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(url: String) {
                      self.init(unsafeResultMap: ["__typename": "Image", "url": url])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
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
                }
              }

              public var asDesigner: AsDesigner? {
                get {
                  if !AsDesigner.possibleTypes.contains(__typename) { return nil }
                  return AsDesigner(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsDesigner: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Designer"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                    GraphQLField("media", alias: "images", arguments: ["type": "IMAGE"], type: .nonNull(.list(.nonNull(.object(Image.selections))))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, description: String? = nil, images: [Image]) {
                  self.init(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: Image) -> ResultMap in value.resultMap }])
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

                public var images: [Image] {
                  get {
                    return (resultMap["images"] as! [ResultMap]).map { (value: ResultMap) -> Image in Image(unsafeResultMap: value) }
                  }
                  set {
                    resultMap.updateValue(newValue.map { (value: Image) -> ResultMap in value.resultMap }, forKey: "images")
                  }
                }

                public struct Image: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLTypeCase(
                        variants: ["Image": AsImage.selections],
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

                  public static func makeAudio() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Audio"])
                  }

                  public static func makeDocument() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Document"])
                  }

                  public static func makeARObject() -> Image {
                    return Image(unsafeResultMap: ["__typename": "ARObject"])
                  }

                  public static func makeVideo() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Video"])
                  }

                  public static func makeImage(url: String) -> Image {
                    return Image(unsafeResultMap: ["__typename": "Image", "url": url])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var asImage: AsImage? {
                    get {
                      if !AsImage.possibleTypes.contains(__typename) { return nil }
                      return AsImage(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsImage: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Image"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("url", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(url: String) {
                      self.init(unsafeResultMap: ["__typename": "Image", "url": url])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
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
                }
              }

              public var asMaterial: AsMaterial? {
                get {
                  if !AsMaterial.possibleTypes.contains(__typename) { return nil }
                  return AsMaterial(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsMaterial: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Material"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                    GraphQLField("media", alias: "images", arguments: ["type": "IMAGE"], type: .nonNull(.list(.nonNull(.object(Image.selections))))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, description: String? = nil, images: [Image]) {
                  self.init(unsafeResultMap: ["__typename": "Material", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: Image) -> ResultMap in value.resultMap }])
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

                public var images: [Image] {
                  get {
                    return (resultMap["images"] as! [ResultMap]).map { (value: ResultMap) -> Image in Image(unsafeResultMap: value) }
                  }
                  set {
                    resultMap.updateValue(newValue.map { (value: Image) -> ResultMap in value.resultMap }, forKey: "images")
                  }
                }

                public struct Image: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLTypeCase(
                        variants: ["Image": AsImage.selections],
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

                  public static func makeAudio() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Audio"])
                  }

                  public static func makeDocument() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Document"])
                  }

                  public static func makeARObject() -> Image {
                    return Image(unsafeResultMap: ["__typename": "ARObject"])
                  }

                  public static func makeVideo() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Video"])
                  }

                  public static func makeImage(url: String) -> Image {
                    return Image(unsafeResultMap: ["__typename": "Image", "url": url])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var asImage: AsImage? {
                    get {
                      if !AsImage.possibleTypes.contains(__typename) { return nil }
                      return AsImage(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsImage: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Image"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("url", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(url: String) {
                      self.init(unsafeResultMap: ["__typename": "Image", "url": url])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
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
                }
              }

              public var asStyle: AsStyle? {
                get {
                  if !AsStyle.possibleTypes.contains(__typename) { return nil }
                  return AsStyle(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsStyle: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Style"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                    GraphQLField("media", alias: "images", arguments: ["type": "IMAGE"], type: .nonNull(.list(.nonNull(.object(Image.selections))))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, description: String? = nil, images: [Image]) {
                  self.init(unsafeResultMap: ["__typename": "Style", "id": id, "title": title, "slug": slug, "description": description, "images": images.map { (value: Image) -> ResultMap in value.resultMap }])
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

                public var images: [Image] {
                  get {
                    return (resultMap["images"] as! [ResultMap]).map { (value: ResultMap) -> Image in Image(unsafeResultMap: value) }
                  }
                  set {
                    resultMap.updateValue(newValue.map { (value: Image) -> ResultMap in value.resultMap }, forKey: "images")
                  }
                }

                public struct Image: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLTypeCase(
                        variants: ["Image": AsImage.selections],
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

                  public static func makeAudio() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Audio"])
                  }

                  public static func makeDocument() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Document"])
                  }

                  public static func makeARObject() -> Image {
                    return Image(unsafeResultMap: ["__typename": "ARObject"])
                  }

                  public static func makeVideo() -> Image {
                    return Image(unsafeResultMap: ["__typename": "Video"])
                  }

                  public static func makeImage(url: String) -> Image {
                    return Image(unsafeResultMap: ["__typename": "Image", "url": url])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var asImage: AsImage? {
                    get {
                      if !AsImage.possibleTypes.contains(__typename) { return nil }
                      return AsImage(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsImage: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Image"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("url", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(url: String) {
                      self.init(unsafeResultMap: ["__typename": "Image", "url": url])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
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
                }
              }
            }
          }
        }
      }
    }
  }
}
