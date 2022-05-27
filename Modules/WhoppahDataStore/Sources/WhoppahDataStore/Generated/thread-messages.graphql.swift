// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetMessagesQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getMessages($filters: [MessageFilter!], $pagination: Pagination, $sort: MessageSort, $order: Ordering) {
        messages(filters: $filters, pagination: $pagination, sort: $sort, order: $order) {
          __typename
          pagination {
            __typename
            page
            pages
            limit
            count
          }
          items {
            __typename
            id
            created
            updated
            sender {
              __typename
              id
              given_name
              family_name
            }
            merchant {
              __typename
              id
              name
              business_name
              type
              avatar: image(type: AVATAR) {
                __typename
                ...MessageMerchantAvatar
              }
            }
            subscriber {
              __typename
              id
              role
            }
            item {
              __typename
              ... on Bid {
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
                bidAuction: auction {
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
                  product {
                    __typename
                    id
                    title
                    auction {
                      __typename
                      state
                    }
                  }
                }
                merchant {
                  __typename
                  id
                }
              }
              ... on Image {
                __typename
                id
                url
              }
              ... on Video {
                __typename
                id
                url(playlist: HLS)
              }
              ... on Product {
                __typename
                id
                merchant {
                  __typename
                  ...MessageMerchant
                }
                buy_now_price {
                  __typename
                  currency
                  amount
                }
                auction {
                  __typename
                  id
                  state
                }
                thumbnails: images {
                  __typename
                  id
                  url(size: SM)
                }
              }
              ... on Order {
                __typename
                id
                orderState: state
                merchant {
                  __typename
                  id
                  fee {
                    __typename
                    type
                    amount
                  }
                }
                buyer {
                  __typename
                  id
                  name
                  business_name
                  type
                }
                bid {
                  __typename
                  id
                  state
                  amount {
                    __typename
                    currency
                    amount
                  }
                }
                address {
                  __typename
                  line1
                  line2
                  postal_code
                  city
                  state
                  country
                }
                product {
                  __typename
                  id
                  orderAuction: auction {
                    __typename
                    id
                    state
                    buy_now_price {
                      __typename
                      currency
                      amount
                    }
                  }
                }
                currency
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
                shipment {
                  __typename
                  id
                  tracking_code
                  return_code
                }
                expiry_date
                end_date
                currency
                subtotal_incl_vat
                subtotal_excl_vat
                shipping_incl_vat
                shipping_excl_vat
                discount_incl_vat
                discount_incl_vat
                payment_incl_vat
                payment_excl_vat
                total_incl_vat
                total_excl_vat
                fee_incl_vat
                fee_excl_vat
                payout
                delivery_feedback
              }
              ... on Shipment {
                __typename
                id
                tracking_code
                return_code
                shipmentOrder: order {
                  __typename
                  id
                  state
                  delivery_feedback
                  delivery_method
                  buyer {
                    __typename
                    id
                  }
                  merchant {
                    __typename
                    id
                  }
                  shipping_method {
                    __typename
                    id
                    slug
                  }
                }
              }
            }
            body
            unread
          }
        }
      }
      """

    public let operationName: String = "getMessages"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + MessageMerchantAvatar.fragmentDefinition)
      document.append("\n" + MessageMerchant.fragmentDefinition)
      return document
    }

    public var filters: [MessageFilter]?
    public var pagination: Pagination?
    public var sort: MessageSort?
    public var order: Ordering?

    public init(filters: [MessageFilter]?, pagination: Pagination? = nil, sort: MessageSort? = nil, order: Ordering? = nil) {
      self.filters = filters
      self.pagination = pagination
      self.sort = sort
      self.order = order
    }

    public var variables: GraphQLMap? {
      return ["filters": filters, "pagination": pagination, "sort": sort, "order": order]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("messages", arguments: ["filters": GraphQLVariable("filters"), "pagination": GraphQLVariable("pagination"), "sort": GraphQLVariable("sort"), "order": GraphQLVariable("order")], type: .nonNull(.object(Message.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(messages: Message) {
        self.init(unsafeResultMap: ["__typename": "Query", "messages": messages.resultMap])
      }

      public var messages: Message {
        get {
          return Message(unsafeResultMap: resultMap["messages"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "messages")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MessageResult"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("pagination", type: .nonNull(.object(Pagination.selections))),
            GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(pagination: Pagination, items: [Item]) {
          self.init(unsafeResultMap: ["__typename": "MessageResult", "pagination": pagination.resultMap, "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var pagination: Pagination {
          get {
            return Pagination(unsafeResultMap: resultMap["pagination"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pagination")
          }
        }

        public var items: [Item] {
          get {
            return (resultMap["items"] as! [ResultMap]).map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Item) -> ResultMap in value.resultMap }, forKey: "items")
          }
        }

        public struct Pagination: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PaginationResult"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("page", type: .nonNull(.scalar(Int.self))),
              GraphQLField("pages", type: .nonNull(.scalar(Int.self))),
              GraphQLField("limit", type: .nonNull(.scalar(Int.self))),
              GraphQLField("count", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(page: Int, pages: Int, limit: Int, count: Int) {
            self.init(unsafeResultMap: ["__typename": "PaginationResult", "page": page, "pages": pages, "limit": limit, "count": count])
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

          public var limit: Int {
            get {
              return resultMap["limit"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "limit")
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

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Message"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
              GraphQLField("updated", type: .scalar(DateTime.self)),
              GraphQLField("sender", type: .nonNull(.object(Sender.selections))),
              GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
              GraphQLField("subscriber", type: .object(Subscriber.selections)),
              GraphQLField("item", type: .object(Item.selections)),
              GraphQLField("body", type: .scalar(String.self)),
              GraphQLField("unread", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, created: DateTime, updated: DateTime? = nil, sender: Sender, merchant: Merchant, subscriber: Subscriber? = nil, item: Item? = nil, body: String? = nil, unread: Bool) {
            self.init(unsafeResultMap: ["__typename": "Message", "id": id, "created": created, "updated": updated, "sender": sender.resultMap, "merchant": merchant.resultMap, "subscriber": subscriber.flatMap { (value: Subscriber) -> ResultMap in value.resultMap }, "item": item.flatMap { (value: Item) -> ResultMap in value.resultMap }, "body": body, "unread": unread])
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

          public var sender: Sender {
            get {
              return Sender(unsafeResultMap: resultMap["sender"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "sender")
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

          public var subscriber: Subscriber? {
            get {
              return (resultMap["subscriber"] as? ResultMap).flatMap { Subscriber(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "subscriber")
            }
          }

          public var item: Item? {
            get {
              return (resultMap["item"] as? ResultMap).flatMap { Item(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "item")
            }
          }

          public var body: String? {
            get {
              return resultMap["body"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "body")
            }
          }

          public var unread: Bool {
            get {
              return resultMap["unread"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "unread")
            }
          }

          public struct Sender: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Member"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("given_name", type: .nonNull(.scalar(String.self))),
                GraphQLField("family_name", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, givenName: String, familyName: String) {
              self.init(unsafeResultMap: ["__typename": "Member", "id": id, "given_name": givenName, "family_name": familyName])
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

            public var givenName: String {
              get {
                return resultMap["given_name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "given_name")
              }
            }

            public var familyName: String {
              get {
                return resultMap["family_name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "family_name")
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
                GraphQLField("business_name", type: .scalar(String.self)),
                GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, avatar: Avatar? = nil) {
              self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

                public var messageMerchantAvatar: MessageMerchantAvatar {
                  get {
                    return MessageMerchantAvatar(unsafeResultMap: resultMap)
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
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, role: SubscriberRole) {
              self.init(unsafeResultMap: ["__typename": "Subscriber", "id": id, "role": role])
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
          }

          public struct Item: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Product", "Order", "Bid", "Shipment", "Image", "Video", "Audio", "Document"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLTypeCase(
                  variants: ["Bid": AsBid.selections, "Image": AsImage.selections, "Video": AsVideo.selections, "Product": AsProduct.selections, "Order": AsOrder.selections, "Shipment": AsShipment.selections],
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

            public static func makeAudio() -> Item {
              return Item(unsafeResultMap: ["__typename": "Audio"])
            }

            public static func makeDocument() -> Item {
              return Item(unsafeResultMap: ["__typename": "Document"])
            }

            public static func makeBid(id: UUID, state: BidState, amount: AsBid.Amount, buyer: AsBid.Buyer, order: AsBid.Order? = nil, bidAuction: AsBid.BidAuction, merchant: AsBid.Merchant) -> Item {
              return Item(unsafeResultMap: ["__typename": "Bid", "id": id, "state": state, "amount": amount.resultMap, "buyer": buyer.resultMap, "order": order.flatMap { (value: AsBid.Order) -> ResultMap in value.resultMap }, "bidAuction": bidAuction.resultMap, "merchant": merchant.resultMap])
            }

            public static func makeImage(id: UUID, url: String) -> Item {
              return Item(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
            }

            public static func makeVideo(id: UUID, url: String) -> Item {
              return Item(unsafeResultMap: ["__typename": "Video", "id": id, "url": url])
            }

            public static func makeProduct(id: UUID, merchant: AsProduct.Merchant, buyNowPrice: AsProduct.BuyNowPrice? = nil, auction: AsProduct.Auction? = nil, thumbnails: [AsProduct.Thumbnail]) -> Item {
              return Item(unsafeResultMap: ["__typename": "Product", "id": id, "merchant": merchant.resultMap, "buy_now_price": buyNowPrice.flatMap { (value: AsProduct.BuyNowPrice) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: AsProduct.Auction) -> ResultMap in value.resultMap }, "thumbnails": thumbnails.map { (value: AsProduct.Thumbnail) -> ResultMap in value.resultMap }])
            }

            public static func makeOrder(id: UUID, orderState: OrderState, merchant: AsOrder.Merchant, buyer: AsOrder.Buyer, bid: AsOrder.Bid? = nil, address: AsOrder.Address? = nil, product: AsOrder.Product, currency: Currency, deliveryMethod: DeliveryMethod, shippingMethod: AsOrder.ShippingMethod? = nil, shipment: AsOrder.Shipment? = nil, expiryDate: DateTime, endDate: DateTime? = nil, subtotalInclVat: Double, subtotalExclVat: Double, shippingInclVat: Double, shippingExclVat: Double, discountInclVat: Double, paymentInclVat: Double, paymentExclVat: Double, totalInclVat: Double, totalExclVat: Double, feeInclVat: Double, feeExclVat: Double, payout: Double, deliveryFeedback: String? = nil) -> Item {
              return Item(unsafeResultMap: ["__typename": "Order", "id": id, "orderState": orderState, "merchant": merchant.resultMap, "buyer": buyer.resultMap, "bid": bid.flatMap { (value: AsOrder.Bid) -> ResultMap in value.resultMap }, "address": address.flatMap { (value: AsOrder.Address) -> ResultMap in value.resultMap }, "product": product.resultMap, "currency": currency, "delivery_method": deliveryMethod, "shipping_method": shippingMethod.flatMap { (value: AsOrder.ShippingMethod) -> ResultMap in value.resultMap }, "shipment": shipment.flatMap { (value: AsOrder.Shipment) -> ResultMap in value.resultMap }, "expiry_date": expiryDate, "end_date": endDate, "subtotal_incl_vat": subtotalInclVat, "subtotal_excl_vat": subtotalExclVat, "shipping_incl_vat": shippingInclVat, "shipping_excl_vat": shippingExclVat, "discount_incl_vat": discountInclVat, "payment_incl_vat": paymentInclVat, "payment_excl_vat": paymentExclVat, "total_incl_vat": totalInclVat, "total_excl_vat": totalExclVat, "fee_incl_vat": feeInclVat, "fee_excl_vat": feeExclVat, "payout": payout, "delivery_feedback": deliveryFeedback])
            }

            public static func makeShipment(id: UUID, trackingCode: String? = nil, returnCode: String? = nil, shipmentOrder: AsShipment.ShipmentOrder) -> Item {
              return Item(unsafeResultMap: ["__typename": "Shipment", "id": id, "tracking_code": trackingCode, "return_code": returnCode, "shipmentOrder": shipmentOrder.resultMap])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var asBid: AsBid? {
              get {
                if !AsBid.possibleTypes.contains(__typename) { return nil }
                return AsBid(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsBid: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Bid"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("state", type: .nonNull(.scalar(BidState.self))),
                  GraphQLField("amount", type: .nonNull(.object(Amount.selections))),
                  GraphQLField("buyer", type: .nonNull(.object(Buyer.selections))),
                  GraphQLField("order", type: .object(Order.selections)),
                  GraphQLField("auction", alias: "bidAuction", type: .nonNull(.object(BidAuction.selections))),
                  GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, state: BidState, amount: Amount, buyer: Buyer, order: Order? = nil, bidAuction: BidAuction, merchant: Merchant) {
                self.init(unsafeResultMap: ["__typename": "Bid", "id": id, "state": state, "amount": amount.resultMap, "buyer": buyer.resultMap, "order": order.flatMap { (value: Order) -> ResultMap in value.resultMap }, "bidAuction": bidAuction.resultMap, "merchant": merchant.resultMap])
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

              public var bidAuction: BidAuction {
                get {
                  return BidAuction(unsafeResultMap: resultMap["bidAuction"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "bidAuction")
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

              public struct BidAuction: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Auction"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
                    GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
                    GraphQLField("minimum_bid", type: .object(MinimumBid.selections)),
                    GraphQLField("product", type: .nonNull(.object(Product.selections))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, state: AuctionState, buyNowPrice: BuyNowPrice? = nil, minimumBid: MinimumBid? = nil, product: Product) {
                  self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "minimum_bid": minimumBid.flatMap { (value: MinimumBid) -> ResultMap in value.resultMap }, "product": product.resultMap])
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

                public var product: Product {
                  get {
                    return Product(unsafeResultMap: resultMap["product"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "product")
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

                public struct Product: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Product"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("title", type: .nonNull(.scalar(String.self))),
                      GraphQLField("auction", type: .object(Auction.selections)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, title: String, auction: Auction? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }])
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

                  public var auction: Auction? {
                    get {
                      return (resultMap["auction"] as? ResultMap).flatMap { Auction(unsafeResultMap: $0) }
                    }
                    set {
                      resultMap.updateValue(newValue?.resultMap, forKey: "auction")
                    }
                  }

                  public struct Auction: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Auction"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(state: AuctionState) {
                      self.init(unsafeResultMap: ["__typename": "Auction", "state": state])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
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
                  }
                }
              }

              public struct Merchant: GraphQLSelectionSet {
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

            public var asVideo: AsVideo? {
              get {
                if !AsVideo.possibleTypes.contains(__typename) { return nil }
                return AsVideo(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsVideo: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Video"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("url", arguments: ["playlist": "HLS"], type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, url: String) {
                self.init(unsafeResultMap: ["__typename": "Video", "id": id, "url": url])
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
                  GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
                  GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
                  GraphQLField("auction", type: .object(Auction.selections)),
                  GraphQLField("images", alias: "thumbnails", type: .nonNull(.list(.nonNull(.object(Thumbnail.selections))))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, merchant: Merchant, buyNowPrice: BuyNowPrice? = nil, auction: Auction? = nil, thumbnails: [Thumbnail]) {
                self.init(unsafeResultMap: ["__typename": "Product", "id": id, "merchant": merchant.resultMap, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }, "thumbnails": thumbnails.map { (value: Thumbnail) -> ResultMap in value.resultMap }])
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
                    GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                    GraphQLField("business_name", type: .scalar(String.self)),
                    GraphQLField("compliance_level", type: .scalar(Int.self)),
                    GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, name: String, type: MerchantType, businessName: String? = nil, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "type": type, "business_name": businessName, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

                public var type: MerchantType {
                  get {
                    return resultMap["type"]! as! MerchantType
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "type")
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

                  public var messageMerchant: MessageMerchant {
                    get {
                      return MessageMerchant(unsafeResultMap: resultMap)
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

                    public var messageMerchantAvatar: MessageMerchantAvatar {
                      get {
                        return MessageMerchantAvatar(unsafeResultMap: resultMap)
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

              public struct Auction: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Auction"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, state: AuctionState) {
                  self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state])
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

            public var asOrder: AsOrder? {
              get {
                if !AsOrder.possibleTypes.contains(__typename) { return nil }
                return AsOrder(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsOrder: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Order"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("state", alias: "orderState", type: .nonNull(.scalar(OrderState.self))),
                  GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
                  GraphQLField("buyer", type: .nonNull(.object(Buyer.selections))),
                  GraphQLField("bid", type: .object(Bid.selections)),
                  GraphQLField("address", type: .object(Address.selections)),
                  GraphQLField("product", type: .nonNull(.object(Product.selections))),
                  GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
                  GraphQLField("delivery_method", type: .nonNull(.scalar(DeliveryMethod.self))),
                  GraphQLField("shipping_method", type: .object(ShippingMethod.selections)),
                  GraphQLField("shipment", type: .object(Shipment.selections)),
                  GraphQLField("expiry_date", type: .nonNull(.scalar(DateTime.self))),
                  GraphQLField("end_date", type: .scalar(DateTime.self)),
                  GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
                  GraphQLField("subtotal_incl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("subtotal_excl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("shipping_incl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("shipping_excl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("discount_incl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("discount_incl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("payment_incl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("payment_excl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("total_incl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("total_excl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("fee_incl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("fee_excl_vat", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("payout", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("delivery_feedback", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, orderState: OrderState, merchant: Merchant, buyer: Buyer, bid: Bid? = nil, address: Address? = nil, product: Product, currency: Currency, deliveryMethod: DeliveryMethod, shippingMethod: ShippingMethod? = nil, shipment: Shipment? = nil, expiryDate: DateTime, endDate: DateTime? = nil, subtotalInclVat: Double, subtotalExclVat: Double, shippingInclVat: Double, shippingExclVat: Double, discountInclVat: Double, paymentInclVat: Double, paymentExclVat: Double, totalInclVat: Double, totalExclVat: Double, feeInclVat: Double, feeExclVat: Double, payout: Double, deliveryFeedback: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Order", "id": id, "orderState": orderState, "merchant": merchant.resultMap, "buyer": buyer.resultMap, "bid": bid.flatMap { (value: Bid) -> ResultMap in value.resultMap }, "address": address.flatMap { (value: Address) -> ResultMap in value.resultMap }, "product": product.resultMap, "currency": currency, "delivery_method": deliveryMethod, "shipping_method": shippingMethod.flatMap { (value: ShippingMethod) -> ResultMap in value.resultMap }, "shipment": shipment.flatMap { (value: Shipment) -> ResultMap in value.resultMap }, "expiry_date": expiryDate, "end_date": endDate, "subtotal_incl_vat": subtotalInclVat, "subtotal_excl_vat": subtotalExclVat, "shipping_incl_vat": shippingInclVat, "shipping_excl_vat": shippingExclVat, "discount_incl_vat": discountInclVat, "payment_incl_vat": paymentInclVat, "payment_excl_vat": paymentExclVat, "total_incl_vat": totalInclVat, "total_excl_vat": totalExclVat, "fee_incl_vat": feeInclVat, "fee_excl_vat": feeExclVat, "payout": payout, "delivery_feedback": deliveryFeedback])
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

              public var orderState: OrderState {
                get {
                  return resultMap["orderState"]! as! OrderState
                }
                set {
                  resultMap.updateValue(newValue, forKey: "orderState")
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

              public var buyer: Buyer {
                get {
                  return Buyer(unsafeResultMap: resultMap["buyer"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "buyer")
                }
              }

              public var bid: Bid? {
                get {
                  return (resultMap["bid"] as? ResultMap).flatMap { Bid(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "bid")
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

              public var product: Product {
                get {
                  return Product(unsafeResultMap: resultMap["product"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "product")
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

              public var shipment: Shipment? {
                get {
                  return (resultMap["shipment"] as? ResultMap).flatMap { Shipment(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "shipment")
                }
              }

              public var expiryDate: DateTime {
                get {
                  return resultMap["expiry_date"]! as! DateTime
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

              public var subtotalInclVat: Double {
                get {
                  return resultMap["subtotal_incl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "subtotal_incl_vat")
                }
              }

              public var subtotalExclVat: Double {
                get {
                  return resultMap["subtotal_excl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "subtotal_excl_vat")
                }
              }

              public var shippingInclVat: Double {
                get {
                  return resultMap["shipping_incl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "shipping_incl_vat")
                }
              }

              public var shippingExclVat: Double {
                get {
                  return resultMap["shipping_excl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "shipping_excl_vat")
                }
              }

              public var discountInclVat: Double {
                get {
                  return resultMap["discount_incl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "discount_incl_vat")
                }
              }

              @available(*, deprecated, message: "No longer supported")
              public var paymentInclVat: Double {
                get {
                  return resultMap["payment_incl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "payment_incl_vat")
                }
              }

              @available(*, deprecated, message: "No longer supported")
              public var paymentExclVat: Double {
                get {
                  return resultMap["payment_excl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "payment_excl_vat")
                }
              }

              public var totalInclVat: Double {
                get {
                  return resultMap["total_incl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "total_incl_vat")
                }
              }

              public var totalExclVat: Double {
                get {
                  return resultMap["total_excl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "total_excl_vat")
                }
              }

              public var feeInclVat: Double {
                get {
                  return resultMap["fee_incl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "fee_incl_vat")
                }
              }

              public var feeExclVat: Double {
                get {
                  return resultMap["fee_excl_vat"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "fee_excl_vat")
                }
              }

              public var payout: Double {
                get {
                  return resultMap["payout"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "payout")
                }
              }

              public var deliveryFeedback: String? {
                get {
                  return resultMap["delivery_feedback"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "delivery_feedback")
                }
              }

              public struct Merchant: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Merchant"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("fee", type: .object(Fee.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, fee: Fee? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "fee": fee.flatMap { (value: Fee) -> ResultMap in value.resultMap }])
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

                public var fee: Fee? {
                  get {
                    return (resultMap["fee"] as? ResultMap).flatMap { Fee(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "fee")
                  }
                }

                public struct Fee: GraphQLSelectionSet {
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
              }

              public struct Buyer: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Merchant"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("business_name", type: .scalar(String.self)),
                    GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType) {
                  self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type])
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
              }

              public struct Bid: GraphQLSelectionSet {
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

              public struct Address: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["OrderAddress"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("line1", type: .nonNull(.scalar(String.self))),
                    GraphQLField("line2", type: .scalar(String.self)),
                    GraphQLField("postal_code", type: .nonNull(.scalar(String.self))),
                    GraphQLField("city", type: .nonNull(.scalar(String.self))),
                    GraphQLField("state", type: .scalar(String.self)),
                    GraphQLField("country", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(line1: String, line2: String? = nil, postalCode: String, city: String, state: String? = nil, country: String) {
                  self.init(unsafeResultMap: ["__typename": "OrderAddress", "line1": line1, "line2": line2, "postal_code": postalCode, "city": city, "state": state, "country": country])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
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
              }

              public struct Product: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Product"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("auction", alias: "orderAuction", type: .object(OrderAuction.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, orderAuction: OrderAuction? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Product", "id": id, "orderAuction": orderAuction.flatMap { (value: OrderAuction) -> ResultMap in value.resultMap }])
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

                public var orderAuction: OrderAuction? {
                  get {
                    return (resultMap["orderAuction"] as? ResultMap).flatMap { OrderAuction(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "orderAuction")
                  }
                }

                public struct OrderAuction: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Auction"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
                      GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, state: AuctionState, buyNowPrice: BuyNowPrice? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }])
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

              public struct Shipment: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Shipment"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("tracking_code", type: .scalar(String.self)),
                    GraphQLField("return_code", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, trackingCode: String? = nil, returnCode: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Shipment", "id": id, "tracking_code": trackingCode, "return_code": returnCode])
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

                public var trackingCode: String? {
                  get {
                    return resultMap["tracking_code"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "tracking_code")
                  }
                }

                public var returnCode: String? {
                  get {
                    return resultMap["return_code"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "return_code")
                  }
                }
              }
            }

            public var asShipment: AsShipment? {
              get {
                if !AsShipment.possibleTypes.contains(__typename) { return nil }
                return AsShipment(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsShipment: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Shipment"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("tracking_code", type: .scalar(String.self)),
                  GraphQLField("return_code", type: .scalar(String.self)),
                  GraphQLField("order", alias: "shipmentOrder", type: .nonNull(.object(ShipmentOrder.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, trackingCode: String? = nil, returnCode: String? = nil, shipmentOrder: ShipmentOrder) {
                self.init(unsafeResultMap: ["__typename": "Shipment", "id": id, "tracking_code": trackingCode, "return_code": returnCode, "shipmentOrder": shipmentOrder.resultMap])
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

              public var trackingCode: String? {
                get {
                  return resultMap["tracking_code"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "tracking_code")
                }
              }

              public var returnCode: String? {
                get {
                  return resultMap["return_code"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "return_code")
                }
              }

              public var shipmentOrder: ShipmentOrder {
                get {
                  return ShipmentOrder(unsafeResultMap: resultMap["shipmentOrder"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "shipmentOrder")
                }
              }

              public struct ShipmentOrder: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Order"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("state", type: .nonNull(.scalar(OrderState.self))),
                    GraphQLField("delivery_feedback", type: .scalar(String.self)),
                    GraphQLField("delivery_method", type: .nonNull(.scalar(DeliveryMethod.self))),
                    GraphQLField("buyer", type: .nonNull(.object(Buyer.selections))),
                    GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
                    GraphQLField("shipping_method", type: .object(ShippingMethod.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, state: OrderState, deliveryFeedback: String? = nil, deliveryMethod: DeliveryMethod, buyer: Buyer, merchant: Merchant, shippingMethod: ShippingMethod? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Order", "id": id, "state": state, "delivery_feedback": deliveryFeedback, "delivery_method": deliveryMethod, "buyer": buyer.resultMap, "merchant": merchant.resultMap, "shipping_method": shippingMethod.flatMap { (value: ShippingMethod) -> ResultMap in value.resultMap }])
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

                public var deliveryFeedback: String? {
                  get {
                    return resultMap["delivery_feedback"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "delivery_feedback")
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

                public var buyer: Buyer {
                  get {
                    return Buyer(unsafeResultMap: resultMap["buyer"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "buyer")
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

                public var shippingMethod: ShippingMethod? {
                  get {
                    return (resultMap["shipping_method"] as? ResultMap).flatMap { ShippingMethod(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "shipping_method")
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

                public struct Merchant: GraphQLSelectionSet {
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

                public struct ShippingMethod: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["ShippingMethod"]

                  public static var selections: [GraphQLSelection] {
                    return [
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
                    self.init(unsafeResultMap: ["__typename": "ShippingMethod", "id": id, "slug": slug])
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
            }
          }
        }
      }
    }
  }

  struct MessageMerchantAvatar: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment MessageMerchantAvatar on Image {
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

  struct MessageMerchant: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment MessageMerchant on Merchant {
        __typename
        id
        name
        type
        business_name
        compliance_level
        avatar: image(type: AVATAR) {
          __typename
          ...MessageMerchantAvatar
        }
      }
      """

    public static let possibleTypes: [String] = ["Merchant"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
        GraphQLField("business_name", type: .scalar(String.self)),
        GraphQLField("compliance_level", type: .scalar(Int.self)),
        GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: UUID, name: String, type: MerchantType, businessName: String? = nil, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
      self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "type": type, "business_name": businessName, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

    public var type: MerchantType {
      get {
        return resultMap["type"]! as! MerchantType
      }
      set {
        resultMap.updateValue(newValue, forKey: "type")
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

        public var messageMerchantAvatar: MessageMerchantAvatar {
          get {
            return MessageMerchantAvatar(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}
