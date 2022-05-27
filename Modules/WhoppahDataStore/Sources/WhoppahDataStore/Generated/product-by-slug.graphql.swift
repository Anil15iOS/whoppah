// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class ProductBySlugQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query productBySlug($key: ProductSlugKey, $value: String!) {
        productBySlug(key: $key, value: $value) {
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
          share_link
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
          is_in_showroom
          shipping_cost {
            __typename
            amount
            currency
          }
          brand {
            __typename
            id
            title
            description
            slug
          }
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
          shipping_method_prices {
            __typename
            price {
              __typename
              amount
              currency
            }
            country
          }
          custom_shipping_cost {
            __typename
            currency
            amount
          }
          merchant_fee {
            __typename
            type
            amount
          }
          merchant {
            __typename
            id
            type
            name
            business_name
            expert_seller
            created
            rating
            compliance_level
            avatar: image(type: AVATAR) {
              __typename
              id
              url(size: SM)
            }
          }
          categories {
            __typename
            id
            title
            slug
            description
            parent {
              __typename
              id
              title
              slug
              description
              parent {
                __typename
                id
                title
                slug
                description
              }
            }
          }
          brand_suggestion
          artist_suggestion
          designer_suggestion
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
            sold_at {
              __typename
              amount
              currency
            }
            allow_bid
            allow_buy_now
            bid_count
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
            bids {
              __typename
              id
              state
              amount {
                __typename
                currency
                amount
              }
              buyer {
                __typename
                id
              }
              order {
                __typename
                id
                state
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
              description
            }
            ... on Brand {
              __typename
              id
              title
              slug
              description
            }
            ... on Color {
              __typename
              id
              title
              hex
              slug
              description
            }
            ... on Designer {
              __typename
              id
              title
              slug
              description
            }
            ... on Label {
              __typename
              id
              slug
              color
              description
            }
            ... on Material {
              __typename
              id
              slug
              description
            }
            ... on Style {
              __typename
              id
              slug
              description
            }
          }
          fullImages: images {
            __typename
            id
            url(size: LG)
          }
          thumbnails: images {
            __typename
            id
            url(size: SM)
          }
          videos(type: DEFAULT) {
            __typename
            id
            url(playlist: HLS)
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

    public let operationName: String = "productBySlug"

    public var key: ProductSlugKey?
    public var value: String

    public init(key: ProductSlugKey? = nil, value: String) {
      self.key = key
      self.value = value
    }

    public var variables: GraphQLMap? {
      return ["key": key, "value": value]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("productBySlug", arguments: ["key": GraphQLVariable("key"), "value": GraphQLVariable("value")], type: .object(ProductBySlug.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(productBySlug: ProductBySlug? = nil) {
        self.init(unsafeResultMap: ["__typename": "Query", "productBySlug": productBySlug.flatMap { (value: ProductBySlug) -> ResultMap in value.resultMap }])
      }

      public var productBySlug: ProductBySlug? {
        get {
          return (resultMap["productBySlug"] as? ResultMap).flatMap { ProductBySlug(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "productBySlug")
        }
      }

      public struct ProductBySlug: GraphQLSelectionSet {
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
            GraphQLField("share_link", type: .nonNull(.scalar(String.self))),
            GraphQLField("address", type: .object(Address.selections)),
            GraphQLField("is_in_showroom", type: .scalar(Bool.self)),
            GraphQLField("shipping_cost", type: .nonNull(.object(ShippingCost.selections))),
            GraphQLField("brand", type: .object(Brand.selections)),
            GraphQLField("delivery_method", type: .nonNull(.scalar(DeliveryMethod.self))),
            GraphQLField("shipping_method", type: .object(ShippingMethod.selections)),
            GraphQLField("shipping_method_prices", type: .nonNull(.list(.nonNull(.object(ShippingMethodPrice.selections))))),
            GraphQLField("custom_shipping_cost", type: .object(CustomShippingCost.selections)),
            GraphQLField("merchant_fee", type: .object(MerchantFee.selections)),
            GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
            GraphQLField("categories", type: .nonNull(.list(.nonNull(.object(Category.selections))))),
            GraphQLField("brand_suggestion", type: .scalar(String.self)),
            GraphQLField("artist_suggestion", type: .scalar(String.self)),
            GraphQLField("designer_suggestion", type: .scalar(String.self)),
            GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
            GraphQLField("original_price", type: .object(OriginalPrice.selections)),
            GraphQLField("auction", type: .object(Auction.selections)),
            GraphQLField("attributes", type: .nonNull(.list(.nonNull(.object(Attribute.selections))))),
            GraphQLField("images", alias: "fullImages", type: .nonNull(.list(.nonNull(.object(FullImage.selections))))),
            GraphQLField("images", alias: "thumbnails", type: .nonNull(.list(.nonNull(.object(Thumbnail.selections))))),
            GraphQLField("videos", arguments: ["type": "DEFAULT"], type: .nonNull(.list(.nonNull(.object(Video.selections))))),
            GraphQLField("arobject", arguments: ["platform": "IOS"], type: .object(Arobject.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, title: String, slug: String, description: String? = nil, state: ProductState, condition: ProductCondition, quality: ProductQuality, width: Int? = nil, height: Int? = nil, depth: Int? = nil, favorite: Favorite? = nil, favoriteCount: Int, viewCount: Int, shareLink: String, address: Address? = nil, isInShowroom: Bool? = nil, shippingCost: ShippingCost, brand: Brand? = nil, deliveryMethod: DeliveryMethod, shippingMethod: ShippingMethod? = nil, shippingMethodPrices: [ShippingMethodPrice], customShippingCost: CustomShippingCost? = nil, merchantFee: MerchantFee? = nil, merchant: Merchant, categories: [Category], brandSuggestion: String? = nil, artistSuggestion: String? = nil, designerSuggestion: String? = nil, buyNowPrice: BuyNowPrice? = nil, originalPrice: OriginalPrice? = nil, auction: Auction? = nil, attributes: [Attribute], fullImages: [FullImage], thumbnails: [Thumbnail], videos: [Video], arobject: Arobject? = nil) {
          self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "slug": slug, "description": description, "state": state, "condition": condition, "quality": quality, "width": width, "height": height, "depth": depth, "favorite": favorite.flatMap { (value: Favorite) -> ResultMap in value.resultMap }, "favorite_count": favoriteCount, "view_count": viewCount, "share_link": shareLink, "address": address.flatMap { (value: Address) -> ResultMap in value.resultMap }, "is_in_showroom": isInShowroom, "shipping_cost": shippingCost.resultMap, "brand": brand.flatMap { (value: Brand) -> ResultMap in value.resultMap }, "delivery_method": deliveryMethod, "shipping_method": shippingMethod.flatMap { (value: ShippingMethod) -> ResultMap in value.resultMap }, "shipping_method_prices": shippingMethodPrices.map { (value: ShippingMethodPrice) -> ResultMap in value.resultMap }, "custom_shipping_cost": customShippingCost.flatMap { (value: CustomShippingCost) -> ResultMap in value.resultMap }, "merchant_fee": merchantFee.flatMap { (value: MerchantFee) -> ResultMap in value.resultMap }, "merchant": merchant.resultMap, "categories": categories.map { (value: Category) -> ResultMap in value.resultMap }, "brand_suggestion": brandSuggestion, "artist_suggestion": artistSuggestion, "designer_suggestion": designerSuggestion, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "original_price": originalPrice.flatMap { (value: OriginalPrice) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }, "attributes": attributes.map { (value: Attribute) -> ResultMap in value.resultMap }, "fullImages": fullImages.map { (value: FullImage) -> ResultMap in value.resultMap }, "thumbnails": thumbnails.map { (value: Thumbnail) -> ResultMap in value.resultMap }, "videos": videos.map { (value: Video) -> ResultMap in value.resultMap }, "arobject": arobject.flatMap { (value: Arobject) -> ResultMap in value.resultMap }])
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

        public var shareLink: String {
          get {
            return resultMap["share_link"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "share_link")
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

        public var isInShowroom: Bool? {
          get {
            return resultMap["is_in_showroom"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "is_in_showroom")
          }
        }

        public var shippingCost: ShippingCost {
          get {
            return ShippingCost(unsafeResultMap: resultMap["shipping_cost"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "shipping_cost")
          }
        }

        public var brand: Brand? {
          get {
            return (resultMap["brand"] as? ResultMap).flatMap { Brand(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "brand")
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

        public var shippingMethodPrices: [ShippingMethodPrice] {
          get {
            return (resultMap["shipping_method_prices"] as! [ResultMap]).map { (value: ResultMap) -> ShippingMethodPrice in ShippingMethodPrice(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: ShippingMethodPrice) -> ResultMap in value.resultMap }, forKey: "shipping_method_prices")
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

        public var merchantFee: MerchantFee? {
          get {
            return (resultMap["merchant_fee"] as? ResultMap).flatMap { MerchantFee(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "merchant_fee")
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

        public var brandSuggestion: String? {
          get {
            return resultMap["brand_suggestion"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "brand_suggestion")
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

        public var designerSuggestion: String? {
          get {
            return resultMap["designer_suggestion"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "designer_suggestion")
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

        public var fullImages: [FullImage] {
          get {
            return (resultMap["fullImages"] as! [ResultMap]).map { (value: ResultMap) -> FullImage in FullImage(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: FullImage) -> ResultMap in value.resultMap }, forKey: "fullImages")
          }
        }

        public var thumbnails: [Thumbnail] {
          get {
            return (resultMap["thumbnails"] as! [ResultMap]).map { (value: ResultMap) -> Thumbnail in Thumbnail(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Thumbnail) -> ResultMap in value.resultMap }, forKey: "thumbnails")
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

        public struct ShippingCost: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Price"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
              GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(amount: Double, currency: Currency) {
            self.init(unsafeResultMap: ["__typename": "Price", "amount": amount, "currency": currency])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
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

          public var currency: Currency {
            get {
              return resultMap["currency"]! as! Currency
            }
            set {
              resultMap.updateValue(newValue, forKey: "currency")
            }
          }
        }

        public struct Brand: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Brand"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, title: String, description: String? = nil, slug: String) {
            self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "description": description, "slug": slug])
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

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
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

        public struct ShippingMethodPrice: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ShippingMethodCountryPrice"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("price", type: .nonNull(.object(Price.selections))),
              GraphQLField("country", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(price: Price, country: String) {
            self.init(unsafeResultMap: ["__typename": "ShippingMethodCountryPrice", "price": price.resultMap, "country": country])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
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

          public var country: String {
            get {
              return resultMap["country"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "country")
            }
          }

          public struct Price: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Price"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(amount: Double, currency: Currency) {
              self.init(unsafeResultMap: ["__typename": "Price", "amount": amount, "currency": currency])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
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

            public var currency: Currency {
              get {
                return resultMap["currency"]! as! Currency
              }
              set {
                resultMap.updateValue(newValue, forKey: "currency")
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

        public struct MerchantFee: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Fee"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(CalculationMethod.self))),
              GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(type: CalculationMethod, amount: Double) {
            self.init(unsafeResultMap: ["__typename": "Fee", "type": type, "amount": amount])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var type: CalculationMethod {
            get {
              return resultMap["type"]! as! CalculationMethod
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
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
              GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("business_name", type: .scalar(String.self)),
              GraphQLField("expert_seller", type: .scalar(Bool.self)),
              GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
              GraphQLField("rating", type: .scalar(Int.self)),
              GraphQLField("compliance_level", type: .scalar(Int.self)),
              GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, type: MerchantType, name: String, businessName: String? = nil, expertSeller: Bool? = nil, created: DateTime, rating: Int? = nil, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
            self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "type": type, "name": name, "business_name": businessName, "expert_seller": expertSeller, "created": created, "rating": rating, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

          public var expertSeller: Bool? {
            get {
              return resultMap["expert_seller"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "expert_seller")
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

          public var rating: Int? {
            get {
              return resultMap["rating"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "rating")
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
                GraphQLField("url", arguments: ["size": "SM"], type: .nonNull(.scalar(String.self))),
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
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("parent", type: .object(Parent.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, title: String, slug: String, description: String? = nil, parent: Parent? = nil) {
            self.init(unsafeResultMap: ["__typename": "Category", "id": id, "title": title, "slug": slug, "description": description, "parent": parent.flatMap { (value: Parent) -> ResultMap in value.resultMap }])
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

          public var parent: Parent? {
            get {
              return (resultMap["parent"] as? ResultMap).flatMap { Parent(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "parent")
            }
          }

          public struct Parent: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Category"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                GraphQLField("description", type: .scalar(String.self)),
                GraphQLField("parent", type: .object(Parent.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String, description: String? = nil, parent: Parent? = nil) {
              self.init(unsafeResultMap: ["__typename": "Category", "id": id, "title": title, "slug": slug, "description": description, "parent": parent.flatMap { (value: Parent) -> ResultMap in value.resultMap }])
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

            public var parent: Parent? {
              get {
                return (resultMap["parent"] as? ResultMap).flatMap { Parent(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "parent")
              }
            }

            public struct Parent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Category"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("title", type: .nonNull(.scalar(String.self))),
                  GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                  GraphQLField("description", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, title: String, slug: String, description: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Category", "id": id, "title": title, "slug": slug, "description": description])
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
              GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
              GraphQLField("minimum_bid", type: .object(MinimumBid.selections)),
              GraphQLField("sold_at", type: .object(SoldAt.selections)),
              GraphQLField("allow_bid", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("allow_buy_now", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("bid_count", type: .nonNull(.scalar(Int.self))),
              GraphQLField("highest_bid", type: .object(HighestBid.selections)),
              GraphQLField("bids", type: .nonNull(.list(.nonNull(.object(Bid.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, state: AuctionState, startDate: DateTime? = nil, expiryDate: DateTime? = nil, endDate: DateTime? = nil, buyNowPrice: BuyNowPrice? = nil, minimumBid: MinimumBid? = nil, soldAt: SoldAt? = nil, allowBid: Bool, allowBuyNow: Bool, bidCount: Int, highestBid: HighestBid? = nil, bids: [Bid]) {
            self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state, "start_date": startDate, "expiry_date": expiryDate, "end_date": endDate, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "minimum_bid": minimumBid.flatMap { (value: MinimumBid) -> ResultMap in value.resultMap }, "sold_at": soldAt.flatMap { (value: SoldAt) -> ResultMap in value.resultMap }, "allow_bid": allowBid, "allow_buy_now": allowBuyNow, "bid_count": bidCount, "highest_bid": highestBid.flatMap { (value: HighestBid) -> ResultMap in value.resultMap }, "bids": bids.map { (value: Bid) -> ResultMap in value.resultMap }])
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

          public var soldAt: SoldAt? {
            get {
              return (resultMap["sold_at"] as? ResultMap).flatMap { SoldAt(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "sold_at")
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

          public var bidCount: Int {
            get {
              return resultMap["bid_count"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "bid_count")
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

          public var bids: [Bid] {
            get {
              return (resultMap["bids"] as! [ResultMap]).map { (value: ResultMap) -> Bid in Bid(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Bid) -> ResultMap in value.resultMap }, forKey: "bids")
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

          public struct SoldAt: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Price"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(amount: Double, currency: Currency) {
              self.init(unsafeResultMap: ["__typename": "Price", "amount": amount, "currency": currency])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
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

            public var currency: Currency {
              get {
                return resultMap["currency"]! as! Currency
              }
              set {
                resultMap.updateValue(newValue, forKey: "currency")
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

          public struct Bid: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Bid"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("state", type: .nonNull(.scalar(BidState.self))),
                GraphQLField("amount", type: .nonNull(.object(Amount.selections))),
                GraphQLField("buyer", type: .nonNull(.object(Buyer.selections))),
                GraphQLField("order", type: .object(Order.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, state: BidState, amount: Amount, buyer: Buyer, order: Order? = nil) {
              self.init(unsafeResultMap: ["__typename": "Bid", "id": id, "state": state, "amount": amount.resultMap, "buyer": buyer.resultMap, "order": order.flatMap { (value: Order) -> ResultMap in value.resultMap }])
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

            public var buyer: Buyer {
              get {
                return Buyer(unsafeResultMap: resultMap["buyer"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "buyer")
              }
            }

            public var order: Order? {
              get {
                return (resultMap["order"] as? ResultMap).flatMap { Order(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "order")
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

            public struct Buyer: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Merchant"]

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
                self.init(unsafeResultMap: ["__typename": "Merchant", "id": id])
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

            public struct Order: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Order"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("state", type: .nonNull(.scalar(OrderState.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, state: OrderState) {
                self.init(unsafeResultMap: ["__typename": "Order", "id": id, "state": state])
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

              public var state: OrderState {
                get {
                  return resultMap["state"]! as! OrderState
                }
                set {
                  resultMap.updateValue(newValue, forKey: "state")
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

          public static func makeArtist(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
          }

          public static func makeBrand(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
          }

          public static func makeColor(id: UUID, title: String, hex: String, slug: String, description: String? = nil) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
          }

          public static func makeDesigner(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
          }

          public static func makeLabel(id: UUID, slug: String, color: String? = nil, description: String? = nil) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
          }

          public static func makeMaterial(id: UUID, slug: String, description: String? = nil) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
          }

          public static func makeStyle(id: UUID, slug: String, description: String? = nil) -> Attribute {
            return Attribute(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
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
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String, description: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
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
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String, description: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
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
                GraphQLField("description", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, hex: String, slug: String, description: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
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

            public var description: String? {
              get {
                return resultMap["description"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "description")
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
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String, description: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
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
                GraphQLField("description", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, slug: String, description: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
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
                GraphQLField("description", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, slug: String, description: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
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
          }
        }

        public struct FullImage: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("url", arguments: ["size": "LG"], type: .nonNull(.scalar(String.self))),
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

        public struct Thumbnail: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("url", arguments: ["size": "SM"], type: .nonNull(.scalar(String.self))),
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
              GraphQLField("url", arguments: ["playlist": "HLS"], type: .nonNull(.scalar(String.self))),
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
