// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class UpdateProductMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation updateProduct($id: UUID!, $input: ProductInput!, $playlist: PlaylistType = HLS) {
        updateProduct(id: $id, input: $input) {
          __typename
          id
          title
          slug
          description
          state
          condition
          quality
          width
          height
          depth
          favorite {
            __typename
            id
          }
          favorite_count
          view_count
          address {
            __typename
            id
            line1
            line2
            postal_code
            city
            state
            country
            location {
              __typename
              latitude
              longitude
            }
          }
          brand_suggestion
          designer_suggestion
          artist_suggestion
          delivery_method
          shipping_method {
            __typename
            id
            title
            slug
            price {
              __typename
              currency
              amount
            }
          }
          custom_shipping_cost {
            __typename
            currency
            amount
          }
          merchant {
            __typename
            id
            name
            created
            compliance_level
            avatar: image(type: AVATAR) {
              __typename
              id
              url
            }
          }
          categories {
            __typename
            id
            title
            slug
          }
          buy_now_price {
            __typename
            currency
            amount
          }
          original_price {
            __typename
            currency
            amount
          }
          auction {
            __typename
            id
            state
            start_date
            expiry_date
            end_date
            bid_count
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
            highest_bid {
              __typename
              id
              state
              amount {
                __typename
                currency
                amount
              }
            }
          }
          attributes {
            __typename
            ... on Artist {
              __typename
              id
              title
              slug
            }
            ... on Brand {
              __typename
              id
              title
              slug
            }
            ... on Color {
              __typename
              id
              title
              hex
              slug
            }
            ... on Designer {
              __typename
              id
              title
              slug
            }
            ... on Label {
              __typename
              id
              slug
              color
            }
            ... on Material {
              __typename
              id
              slug
            }
            ... on Style {
              __typename
              id
              slug
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
      """

    public let operationName: String = "updateProduct"

    public var id: UUID
    public var input: ProductInput
    public var playlist: PlaylistType?

    public init(id: UUID, input: ProductInput, playlist: PlaylistType? = nil) {
      self.id = id
      self.input = input
      self.playlist = playlist
    }

    public var variables: GraphQLMap? {
      return ["id": id, "input": input, "playlist": playlist]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("updateProduct", arguments: ["id": GraphQLVariable("id"), "input": GraphQLVariable("input")], type: .nonNull(.object(UpdateProduct.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(updateProduct: UpdateProduct) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "updateProduct": updateProduct.resultMap])
      }

      public var updateProduct: UpdateProduct {
        get {
          return UpdateProduct(unsafeResultMap: resultMap["updateProduct"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "updateProduct")
        }
      }

      public struct UpdateProduct: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Product"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
            GraphQLField("slug", type: .nonNull(.scalar(String.self))),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("state", type: .nonNull(.scalar(ProductState.self))),
            GraphQLField("condition", type: .nonNull(.scalar(ProductCondition.self))),
            GraphQLField("quality", type: .nonNull(.scalar(ProductQuality.self))),
            GraphQLField("width", type: .scalar(Int.self)),
            GraphQLField("height", type: .scalar(Int.self)),
            GraphQLField("depth", type: .scalar(Int.self)),
            GraphQLField("favorite", type: .object(Favorite.selections)),
            GraphQLField("favorite_count", type: .nonNull(.scalar(Int.self))),
            GraphQLField("view_count", type: .nonNull(.scalar(Int.self))),
            GraphQLField("address", type: .object(Address.selections)),
            GraphQLField("brand_suggestion", type: .scalar(String.self)),
            GraphQLField("designer_suggestion", type: .scalar(String.self)),
            GraphQLField("artist_suggestion", type: .scalar(String.self)),
            GraphQLField("delivery_method", type: .nonNull(.scalar(DeliveryMethod.self))),
            GraphQLField("shipping_method", type: .object(ShippingMethod.selections)),
            GraphQLField("custom_shipping_cost", type: .object(CustomShippingCost.selections)),
            GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
            GraphQLField("categories", type: .nonNull(.list(.nonNull(.object(Category.selections))))),
            GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
            GraphQLField("original_price", type: .object(OriginalPrice.selections)),
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

        public init(id: UUID, title: String, slug: String, description: String? = nil, state: ProductState, condition: ProductCondition, quality: ProductQuality, width: Int? = nil, height: Int? = nil, depth: Int? = nil, favorite: Favorite? = nil, favoriteCount: Int, viewCount: Int, address: Address? = nil, brandSuggestion: String? = nil, designerSuggestion: String? = nil, artistSuggestion: String? = nil, deliveryMethod: DeliveryMethod, shippingMethod: ShippingMethod? = nil, customShippingCost: CustomShippingCost? = nil, merchant: Merchant, categories: [Category], buyNowPrice: BuyNowPrice? = nil, originalPrice: OriginalPrice? = nil, auction: Auction? = nil, attributes: [Attribute], images: [Image], videos: [Video], arobjects: [Arobject]) {
          self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "slug": slug, "description": description, "state": state, "condition": condition, "quality": quality, "width": width, "height": height, "depth": depth, "favorite": favorite.flatMap { (value: Favorite) -> ResultMap in value.resultMap }, "favorite_count": favoriteCount, "view_count": viewCount, "address": address.flatMap { (value: Address) -> ResultMap in value.resultMap }, "brand_suggestion": brandSuggestion, "designer_suggestion": designerSuggestion, "artist_suggestion": artistSuggestion, "delivery_method": deliveryMethod, "shipping_method": shippingMethod.flatMap { (value: ShippingMethod) -> ResultMap in value.resultMap }, "custom_shipping_cost": customShippingCost.flatMap { (value: CustomShippingCost) -> ResultMap in value.resultMap }, "merchant": merchant.resultMap, "categories": categories.map { (value: Category) -> ResultMap in value.resultMap }, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "original_price": originalPrice.flatMap { (value: OriginalPrice) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }, "attributes": attributes.map { (value: Attribute) -> ResultMap in value.resultMap }, "images": images.map { (value: Image) -> ResultMap in value.resultMap }, "videos": videos.map { (value: Video) -> ResultMap in value.resultMap }, "arobjects": arobjects.map { (value: Arobject) -> ResultMap in value.resultMap }])
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

        public var condition: ProductCondition {
          get {
            return resultMap["condition"]! as! ProductCondition
          }
          set {
            resultMap.updateValue(newValue, forKey: "condition")
          }
        }

        public var quality: ProductQuality {
          get {
            return resultMap["quality"]! as! ProductQuality
          }
          set {
            resultMap.updateValue(newValue, forKey: "quality")
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

        public var depth: Int? {
          get {
            return resultMap["depth"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "depth")
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

        public var favoriteCount: Int {
          get {
            return resultMap["favorite_count"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "favorite_count")
          }
        }

        public var viewCount: Int {
          get {
            return resultMap["view_count"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "view_count")
          }
        }

        public var address: Address? {
          get {
            return (resultMap["address"] as? ResultMap).flatMap { Address(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "address")
          }
        }

        public var brandSuggestion: String? {
          get {
            return resultMap["brand_suggestion"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "brand_suggestion")
          }
        }

        public var designerSuggestion: String? {
          get {
            return resultMap["designer_suggestion"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "designer_suggestion")
          }
        }

        public var artistSuggestion: String? {
          get {
            return resultMap["artist_suggestion"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "artist_suggestion")
          }
        }

        public var deliveryMethod: DeliveryMethod {
          get {
            return resultMap["delivery_method"]! as! DeliveryMethod
          }
          set {
            resultMap.updateValue(newValue, forKey: "delivery_method")
          }
        }

        public var shippingMethod: ShippingMethod? {
          get {
            return (resultMap["shipping_method"] as? ResultMap).flatMap { ShippingMethod(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "shipping_method")
          }
        }

        public var customShippingCost: CustomShippingCost? {
          get {
            return (resultMap["custom_shipping_cost"] as? ResultMap).flatMap { CustomShippingCost(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "custom_shipping_cost")
          }
        }

        public var merchant: Merchant {
          get {
            return Merchant(unsafeResultMap: resultMap["merchant"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "merchant")
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

        @available(*, deprecated, message: "Use product.auction.buy_now_price")
        public var buyNowPrice: BuyNowPrice? {
          get {
            return (resultMap["buy_now_price"] as? ResultMap).flatMap { BuyNowPrice(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "buy_now_price")
          }
        }

        @available(*, deprecated, message: "No longer used")
        public var originalPrice: OriginalPrice? {
          get {
            return (resultMap["original_price"] as? ResultMap).flatMap { OriginalPrice(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "original_price")
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

        public struct Address: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Address"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("line1", type: .nonNull(.scalar(String.self))),
              GraphQLField("line2", type: .scalar(String.self)),
              GraphQLField("postal_code", type: .nonNull(.scalar(String.self))),
              GraphQLField("city", type: .nonNull(.scalar(String.self))),
              GraphQLField("state", type: .scalar(String.self)),
              GraphQLField("country", type: .nonNull(.scalar(String.self))),
              GraphQLField("location", type: .object(Location.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, line1: String, line2: String? = nil, postalCode: String, city: String, state: String? = nil, country: String, location: Location? = nil) {
            self.init(unsafeResultMap: ["__typename": "Address", "id": id, "line1": line1, "line2": line2, "postal_code": postalCode, "city": city, "state": state, "country": country, "location": location.flatMap { (value: Location) -> ResultMap in value.resultMap }])
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

          public var line1: String {
            get {
              return resultMap["line1"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "line1")
            }
          }

          public var line2: String? {
            get {
              return resultMap["line2"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "line2")
            }
          }

          public var postalCode: String {
            get {
              return resultMap["postal_code"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "postal_code")
            }
          }

          public var city: String {
            get {
              return resultMap["city"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "city")
            }
          }

          public var state: String? {
            get {
              return resultMap["state"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
            }
          }

          public var country: String {
            get {
              return resultMap["country"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "country")
            }
          }

          public var location: Location? {
            get {
              return (resultMap["location"] as? ResultMap).flatMap { Location(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "location")
            }
          }

          public struct Location: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Location"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
                GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(latitude: Double, longitude: Double) {
              self.init(unsafeResultMap: ["__typename": "Location", "latitude": latitude, "longitude": longitude])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var latitude: Double {
              get {
                return resultMap["latitude"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "latitude")
              }
            }

            public var longitude: Double {
              get {
                return resultMap["longitude"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "longitude")
              }
            }
          }
        }

        public struct ShippingMethod: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ShippingMethod"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("price", type: .nonNull(.object(Price.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, title: String, slug: String, price: Price) {
            self.init(unsafeResultMap: ["__typename": "ShippingMethod", "id": id, "title": title, "slug": slug, "price": price.resultMap])
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

          public var price: Price {
            get {
              return Price(unsafeResultMap: resultMap["price"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "price")
            }
          }

          public struct Price: GraphQLSelectionSet {
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

        public struct CustomShippingCost: GraphQLSelectionSet {
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

        public struct Merchant: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Merchant"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
              GraphQLField("compliance_level", type: .scalar(Int.self)),
              GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, name: String, created: DateTime, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
            self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "created": created, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

          public var name: String {
            get {
              return resultMap["name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
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

          public var complianceLevel: Int? {
            get {
              return resultMap["compliance_level"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "compliance_level")
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

        public struct Category: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Category"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, title: String, slug: String) {
            self.init(unsafeResultMap: ["__typename": "Category", "id": id, "title": title, "slug": slug])
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

        public struct OriginalPrice: GraphQLSelectionSet {
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

        public struct Auction: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Auction"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
              GraphQLField("start_date", type: .scalar(DateTime.self)),
              GraphQLField("expiry_date", type: .scalar(DateTime.self)),
              GraphQLField("end_date", type: .scalar(DateTime.self)),
              GraphQLField("bid_count", type: .nonNull(.scalar(Int.self))),
              GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
              GraphQLField("minimum_bid", type: .object(MinimumBid.selections)),
              GraphQLField("allow_bid", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("allow_buy_now", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("highest_bid", type: .object(HighestBid.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, state: AuctionState, startDate: DateTime? = nil, expiryDate: DateTime? = nil, endDate: DateTime? = nil, bidCount: Int, buyNowPrice: BuyNowPrice? = nil, minimumBid: MinimumBid? = nil, allowBid: Bool, allowBuyNow: Bool, highestBid: HighestBid? = nil) {
            self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state, "start_date": startDate, "expiry_date": expiryDate, "end_date": endDate, "bid_count": bidCount, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "minimum_bid": minimumBid.flatMap { (value: MinimumBid) -> ResultMap in value.resultMap }, "allow_bid": allowBid, "allow_buy_now": allowBuyNow, "highest_bid": highestBid.flatMap { (value: HighestBid) -> ResultMap in value.resultMap }])
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

          public var startDate: DateTime? {
            get {
              return resultMap["start_date"] as? DateTime
            }
            set {
              resultMap.updateValue(newValue, forKey: "start_date")
            }
          }

          public var expiryDate: DateTime? {
            get {
              return resultMap["expiry_date"] as? DateTime
            }
            set {
              resultMap.updateValue(newValue, forKey: "expiry_date")
            }
          }

          public var endDate: DateTime? {
            get {
              return resultMap["end_date"] as? DateTime
            }
            set {
              resultMap.updateValue(newValue, forKey: "end_date")
            }
          }

          public var bidCount: Int {
            get {
              return resultMap["bid_count"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "bid_count")
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

          public var highestBid: HighestBid? {
            get {
              return (resultMap["highest_bid"] as? ResultMap).flatMap { HighestBid(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "highest_bid")
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

          public struct HighestBid: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Bid"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("state", type: .nonNull(.scalar(BidState.self))),
                GraphQLField("amount", type: .nonNull(.object(Amount.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, state: BidState, amount: Amount) {
              self.init(unsafeResultMap: ["__typename": "Bid", "id": id, "state": state, "amount": amount.resultMap])
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

            public var state: BidState {
              get {
                return resultMap["state"]! as! BidState
              }
              set {
                resultMap.updateValue(newValue, forKey: "state")
              }
            }

            public var amount: Amount {
              get {
                return Amount(unsafeResultMap: resultMap["amount"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "amount")
              }
            }

            public struct Amount: GraphQLSelectionSet {
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
        }

        public struct Attribute: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLTypeCase(
                variants: ["Artist": AsArtist.selections, "Brand": AsBrand.selections, "Color": AsColor.selections, "Designer": AsDesigner.selections, "Label": AsLabel.selections, "Material": AsMaterial.selections, "Style": AsStyle.selections],
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

          public static func makeUsageSign() -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "UsageSign"])
          }

          public static func makeAdditionalInfo() -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "AdditionalInfo"])
          }

          public static func makeSubject() -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Subject"])
          }

          public static func makeArtist(id: UUID, title: String, slug: String) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug])
          }

          public static func makeBrand(id: UUID, title: String, slug: String) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug])
          }

          public static func makeColor(id: UUID, title: String, hex: String, slug: String) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug])
          }

          public static func makeDesigner(id: UUID, title: String, slug: String) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug])
          }

          public static func makeLabel(id: UUID, slug: String, color: String? = nil) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color])
          }

          public static func makeMaterial(id: UUID, slug: String) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug])
          }

          public static func makeStyle(id: UUID, slug: String) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug])
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
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String) {
              self.init(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug])
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
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String) {
              self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug])
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
                GraphQLField("hex", type: .nonNull(.scalar(String.self))),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, hex: String, slug: String) {
              self.init(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug])
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

            public var hex: String {
              get {
                return resultMap["hex"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "hex")
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
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String) {
              self.init(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug])
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
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, slug: String, color: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color])
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
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, slug: String) {
              self.init(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug])
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
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, slug: String) {
              self.init(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug])
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
