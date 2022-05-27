// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetThreadQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getThread($id: UUID!) {
        thread(id: $id) {
          __typename
          id
          created
          updated
          item {
            __typename
            ... on Product {
              __typename
              id
              title
              merchant {
                __typename
                ...ThreadMerchant
              }
              buy_now_price {
                __typename
                currency
                amount
              }
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
              shipping_cost {
                __typename
                amount
                currency
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
              auction {
                __typename
                id
                state
                allow_bid
                allow_buy_now
                minimum_bid {
                  __typename
                  currency
                  amount
                }
                bids {
                  __typename
                  id
                  state
                  buyer {
                    __typename
                    id
                  }
                  order {
                    __typename
                    state
                  }
                }
              }
              thumbnails: images {
                __typename
                id
                url(size: SM)
              }
            }
            ... on Merchant {
              __typename
              ...ThreadMerchant
            }
          }
          started_by {
            __typename
            ...ThreadMerchant
          }
          subscribers {
            __typename
            id
            role
            merchant {
              __typename
              ...ThreadMerchant
            }
          }
        }
      }
      """

    public let operationName: String = "getThread"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + ThreadMerchant.fragmentDefinition)
      document.append("\n" + ThreadMerchantAvatar.fragmentDefinition)
      return document
    }

    public var id: UUID

    public init(id: UUID) {
      self.id = id
    }

    public var variables: GraphQLMap? {
      return ["id": id]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("thread", arguments: ["id": GraphQLVariable("id")], type: .object(Thread.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(thread: Thread? = nil) {
        self.init(unsafeResultMap: ["__typename": "Query", "thread": thread.flatMap { (value: Thread) -> ResultMap in value.resultMap }])
      }

      public var thread: Thread? {
        get {
          return (resultMap["thread"] as? ResultMap).flatMap { Thread(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "thread")
        }
      }

      public struct Thread: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Thread"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
            GraphQLField("updated", type: .scalar(DateTime.self)),
            GraphQLField("item", type: .nonNull(.object(Item.selections))),
            GraphQLField("started_by", type: .nonNull(.object(StartedBy.selections))),
            GraphQLField("subscribers", type: .nonNull(.list(.nonNull(.object(Subscriber.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, created: DateTime, updated: DateTime? = nil, item: Item, startedBy: StartedBy, subscribers: [Subscriber]) {
          self.init(unsafeResultMap: ["__typename": "Thread", "id": id, "created": created, "updated": updated, "item": item.resultMap, "started_by": startedBy.resultMap, "subscribers": subscribers.map { (value: Subscriber) -> ResultMap in value.resultMap }])
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

        public var updated: DateTime? {
          get {
            return resultMap["updated"] as? DateTime
          }
          set {
            resultMap.updateValue(newValue, forKey: "updated")
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

        public var startedBy: StartedBy {
          get {
            return StartedBy(unsafeResultMap: resultMap["started_by"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "started_by")
          }
        }

        public var subscribers: [Subscriber] {
          get {
            return (resultMap["subscribers"] as! [ResultMap]).map { (value: ResultMap) -> Subscriber in Subscriber(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Subscriber) -> ResultMap in value.resultMap }, forKey: "subscribers")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Product", "Merchant"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLTypeCase(
                variants: ["Product": AsProduct.selections, "Merchant": AsMerchant.selections],
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

          public static func makeProduct(id: UUID, title: String, merchant: AsProduct.Merchant, buyNowPrice: AsProduct.BuyNowPrice? = nil, address: AsProduct.Address? = nil, shippingCost: AsProduct.ShippingCost, deliveryMethod: DeliveryMethod, shippingMethod: AsProduct.ShippingMethod? = nil, auction: AsProduct.Auction? = nil, thumbnails: [AsProduct.Thumbnail]) -> Item {
            return Item(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "merchant": merchant.resultMap, "buy_now_price": buyNowPrice.flatMap { (value: AsProduct.BuyNowPrice) -> ResultMap in value.resultMap }, "address": address.flatMap { (value: AsProduct.Address) -> ResultMap in value.resultMap }, "shipping_cost": shippingCost.resultMap, "delivery_method": deliveryMethod, "shipping_method": shippingMethod.flatMap { (value: AsProduct.ShippingMethod) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: AsProduct.Auction) -> ResultMap in value.resultMap }, "thumbnails": thumbnails.map { (value: AsProduct.Thumbnail) -> ResultMap in value.resultMap }])
          }

          public static func makeMerchant(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: AsMerchant.Avatar? = nil) -> Item {
            return Item(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: AsMerchant.Avatar) -> ResultMap in value.resultMap }])
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
                GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
                GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
                GraphQLField("address", type: .object(Address.selections)),
                GraphQLField("shipping_cost", type: .nonNull(.object(ShippingCost.selections))),
                GraphQLField("delivery_method", type: .nonNull(.scalar(DeliveryMethod.self))),
                GraphQLField("shipping_method", type: .object(ShippingMethod.selections)),
                GraphQLField("auction", type: .object(Auction.selections)),
                GraphQLField("images", alias: "thumbnails", type: .nonNull(.list(.nonNull(.object(Thumbnail.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, merchant: Merchant, buyNowPrice: BuyNowPrice? = nil, address: Address? = nil, shippingCost: ShippingCost, deliveryMethod: DeliveryMethod, shippingMethod: ShippingMethod? = nil, auction: Auction? = nil, thumbnails: [Thumbnail]) {
              self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "merchant": merchant.resultMap, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "address": address.flatMap { (value: Address) -> ResultMap in value.resultMap }, "shipping_cost": shippingCost.resultMap, "delivery_method": deliveryMethod, "shipping_method": shippingMethod.flatMap { (value: ShippingMethod) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }, "thumbnails": thumbnails.map { (value: Thumbnail) -> ResultMap in value.resultMap }])
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

            public var merchant: Merchant {
              get {
                return Merchant(unsafeResultMap: resultMap["merchant"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "merchant")
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

            public var address: Address? {
              get {
                return (resultMap["address"] as? ResultMap).flatMap { Address(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "address")
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

            public var auction: Auction? {
              get {
                return (resultMap["auction"] as? ResultMap).flatMap { Auction(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "auction")
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

            public struct Merchant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Merchant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("business_name", type: .scalar(String.self)),
                  GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                  GraphQLField("compliance_level", type: .scalar(Int.self)),
                  GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
                self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

              public var businessName: String? {
                get {
                  return resultMap["business_name"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "business_name")
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

              public var fragments: Fragments {
                get {
                  return Fragments(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }

              public struct Fragments {
                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public var threadMerchant: ThreadMerchant {
                  get {
                    return ThreadMerchant(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }
              }

              public struct Avatar: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Image"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

                public var fragments: Fragments {
                  get {
                    return Fragments(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }

                public struct Fragments {
                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public var threadMerchantAvatar: ThreadMerchantAvatar {
                    get {
                      return ThreadMerchantAvatar(unsafeResultMap: resultMap)
                    }
                    set {
                      resultMap += newValue.resultMap
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

            public struct Auction: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Auction"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
                  GraphQLField("allow_bid", type: .nonNull(.scalar(Bool.self))),
                  GraphQLField("allow_buy_now", type: .nonNull(.scalar(Bool.self))),
                  GraphQLField("minimum_bid", type: .object(MinimumBid.selections)),
                  GraphQLField("bids", type: .nonNull(.list(.nonNull(.object(Bid.selections))))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, state: AuctionState, allowBid: Bool, allowBuyNow: Bool, minimumBid: MinimumBid? = nil, bids: [Bid]) {
                self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state, "allow_bid": allowBid, "allow_buy_now": allowBuyNow, "minimum_bid": minimumBid.flatMap { (value: MinimumBid) -> ResultMap in value.resultMap }, "bids": bids.map { (value: Bid) -> ResultMap in value.resultMap }])
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

              public var minimumBid: MinimumBid? {
                get {
                  return (resultMap["minimum_bid"] as? ResultMap).flatMap { MinimumBid(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "minimum_bid")
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

              public struct Bid: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bid"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("state", type: .nonNull(.scalar(BidState.self))),
                    GraphQLField("buyer", type: .nonNull(.object(Buyer.selections))),
                    GraphQLField("order", type: .object(Order.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, state: BidState, buyer: Buyer, order: Order? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Bid", "id": id, "state": state, "buyer": buyer.resultMap, "order": order.flatMap { (value: Order) -> ResultMap in value.resultMap }])
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
                      GraphQLField("state", type: .nonNull(.scalar(OrderState.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(state: OrderState) {
                    self.init(unsafeResultMap: ["__typename": "Order", "state": state])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
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
          }

          public var asMerchant: AsMerchant? {
            get {
              if !AsMerchant.possibleTypes.contains(__typename) { return nil }
              return AsMerchant(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsMerchant: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Merchant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("business_name", type: .scalar(String.self)),
                GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                GraphQLField("compliance_level", type: .scalar(Int.self)),
                GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
              self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

            public var businessName: String? {
              get {
                return resultMap["business_name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "business_name")
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

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var threadMerchant: ThreadMerchant {
                get {
                  return ThreadMerchant(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }

            public struct Avatar: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Image"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

              public var fragments: Fragments {
                get {
                  return Fragments(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }

              public struct Fragments {
                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public var threadMerchantAvatar: ThreadMerchantAvatar {
                  get {
                    return ThreadMerchantAvatar(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }
              }
            }
          }
        }

        public struct StartedBy: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Merchant"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("business_name", type: .scalar(String.self)),
              GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
              GraphQLField("compliance_level", type: .scalar(Int.self)),
              GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
            self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

          public var businessName: String? {
            get {
              return resultMap["business_name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "business_name")
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

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var threadMerchant: ThreadMerchant {
              get {
                return ThreadMerchant(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }

          public struct Avatar: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var threadMerchantAvatar: ThreadMerchantAvatar {
                get {
                  return ThreadMerchantAvatar(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }
        }

        public struct Subscriber: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Subscriber"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("role", type: .nonNull(.scalar(SubscriberRole.self))),
              GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, role: SubscriberRole, merchant: Merchant) {
            self.init(unsafeResultMap: ["__typename": "Subscriber", "id": id, "role": role, "merchant": merchant.resultMap])
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

          public var role: SubscriberRole {
            get {
              return resultMap["role"]! as! SubscriberRole
            }
            set {
              resultMap.updateValue(newValue, forKey: "role")
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

          public struct Merchant: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Merchant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("business_name", type: .scalar(String.self)),
                GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                GraphQLField("compliance_level", type: .scalar(Int.self)),
                GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
              self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

            public var businessName: String? {
              get {
                return resultMap["business_name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "business_name")
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

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var threadMerchant: ThreadMerchant {
                get {
                  return ThreadMerchant(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }

            public struct Avatar: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Image"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

              public var fragments: Fragments {
                get {
                  return Fragments(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }

              public struct Fragments {
                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public var threadMerchantAvatar: ThreadMerchantAvatar {
                  get {
                    return ThreadMerchantAvatar(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  struct ThreadMerchantAvatar: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment ThreadMerchantAvatar on Image {
        __typename
        id
        url(size: MD)
      }
      """

    public static let possibleTypes: [String] = ["Image"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
        GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

  struct ThreadMerchant: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment ThreadMerchant on Merchant {
        __typename
        id
        name
        business_name
        type
        compliance_level
        avatar: image(type: AVATAR) {
          __typename
          ...ThreadMerchantAvatar
        }
      }
      """

    public static let possibleTypes: [String] = ["Merchant"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("business_name", type: .scalar(String.self)),
        GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
        GraphQLField("compliance_level", type: .scalar(Int.self)),
        GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
      self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

    public var businessName: String? {
      get {
        return resultMap["business_name"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "business_name")
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
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
          GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var threadMerchantAvatar: ThreadMerchantAvatar {
          get {
            return ThreadMerchantAvatar(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}
