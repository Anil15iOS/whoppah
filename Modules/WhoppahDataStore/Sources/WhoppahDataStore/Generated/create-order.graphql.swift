// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CreateOrderMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation createOrder($input: OrderInput!) {
        createOrder(input: $input) {
          __typename
          id
          bid {
            __typename
            id
            state
            amount {
              __typename
              amount
              currency
            }
          }
          state
          expiry_date
          end_date
          purchase_type
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
          currency
          subtotal_incl_vat
          subtotal_excl_vat
          shipping_incl_vat
          shipping_excl_vat
          payment_incl_vat
          payment_excl_vat
          discount_incl_vat
          discount_excl_vat
          total_incl_vat
          total_excl_vat
          fee_incl_vat
          fee_excl_vat
          payout
          stripePayment: payment {
            __typename
            payment_method
            payment_intent_id
            payment_method_id
            client_secret_id
            payment_source_id
          }
          payout
          product {
            __typename
            id
            state
            merchant {
              __typename
              id
              name
            }
            auction {
              __typename
              id
              state
            }
          }
        }
      }
      """

    public let operationName: String = "createOrder"

    public var input: OrderInput

    public init(input: OrderInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createOrder", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreateOrder.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createOrder: CreateOrder) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "createOrder": createOrder.resultMap])
      }

      public var createOrder: CreateOrder {
        get {
          return CreateOrder(unsafeResultMap: resultMap["createOrder"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "createOrder")
        }
      }

      public struct CreateOrder: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Order"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("bid", type: .object(Bid.selections)),
            GraphQLField("state", type: .nonNull(.scalar(OrderState.self))),
            GraphQLField("expiry_date", type: .nonNull(.scalar(DateTime.self))),
            GraphQLField("end_date", type: .scalar(DateTime.self)),
            GraphQLField("purchase_type", type: .nonNull(.scalar(PurchaseType.self))),
            GraphQLField("delivery_method", type: .nonNull(.scalar(DeliveryMethod.self))),
            GraphQLField("shipping_method", type: .object(ShippingMethod.selections)),
            GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
            GraphQLField("subtotal_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("subtotal_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("shipping_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("shipping_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("payment_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("payment_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("discount_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("discount_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("total_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("total_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("fee_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("fee_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("payout", type: .nonNull(.scalar(Double.self))),
            GraphQLField("payment", alias: "stripePayment", type: .object(StripePayment.selections)),
            GraphQLField("payout", type: .nonNull(.scalar(Double.self))),
            GraphQLField("product", type: .nonNull(.object(Product.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, bid: Bid? = nil, state: OrderState, expiryDate: DateTime, endDate: DateTime? = nil, purchaseType: PurchaseType, deliveryMethod: DeliveryMethod, shippingMethod: ShippingMethod? = nil, currency: Currency, subtotalInclVat: Double, subtotalExclVat: Double, shippingInclVat: Double, shippingExclVat: Double, paymentInclVat: Double, paymentExclVat: Double, discountInclVat: Double, discountExclVat: Double, totalInclVat: Double, totalExclVat: Double, feeInclVat: Double, feeExclVat: Double, payout: Double, stripePayment: StripePayment? = nil, product: Product) {
          self.init(unsafeResultMap: ["__typename": "Order", "id": id, "bid": bid.flatMap { (value: Bid) -> ResultMap in value.resultMap }, "state": state, "expiry_date": expiryDate, "end_date": endDate, "purchase_type": purchaseType, "delivery_method": deliveryMethod, "shipping_method": shippingMethod.flatMap { (value: ShippingMethod) -> ResultMap in value.resultMap }, "currency": currency, "subtotal_incl_vat": subtotalInclVat, "subtotal_excl_vat": subtotalExclVat, "shipping_incl_vat": shippingInclVat, "shipping_excl_vat": shippingExclVat, "payment_incl_vat": paymentInclVat, "payment_excl_vat": paymentExclVat, "discount_incl_vat": discountInclVat, "discount_excl_vat": discountExclVat, "total_incl_vat": totalInclVat, "total_excl_vat": totalExclVat, "fee_incl_vat": feeInclVat, "fee_excl_vat": feeExclVat, "payout": payout, "stripePayment": stripePayment.flatMap { (value: StripePayment) -> ResultMap in value.resultMap }, "product": product.resultMap])
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

        public var bid: Bid? {
          get {
            return (resultMap["bid"] as? ResultMap).flatMap { Bid(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "bid")
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

        public var purchaseType: PurchaseType {
          get {
            return resultMap["purchase_type"]! as! PurchaseType
          }
          set {
            resultMap.updateValue(newValue, forKey: "purchase_type")
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

        public var currency: Currency {
          get {
            return resultMap["currency"]! as! Currency
          }
          set {
            resultMap.updateValue(newValue, forKey: "currency")
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

        public var discountInclVat: Double {
          get {
            return resultMap["discount_incl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "discount_incl_vat")
          }
        }

        public var discountExclVat: Double {
          get {
            return resultMap["discount_excl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "discount_excl_vat")
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

        public var stripePayment: StripePayment? {
          get {
            return (resultMap["stripePayment"] as? ResultMap).flatMap { StripePayment(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "stripePayment")
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

        public struct StripePayment: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["StripePayment"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("payment_method", type: .nonNull(.scalar(String.self))),
              GraphQLField("payment_intent_id", type: .scalar(String.self)),
              GraphQLField("payment_method_id", type: .scalar(String.self)),
              GraphQLField("client_secret_id", type: .nonNull(.scalar(String.self))),
              GraphQLField("payment_source_id", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(paymentMethod: String, paymentIntentId: String? = nil, paymentMethodId: String? = nil, clientSecretId: String, paymentSourceId: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "StripePayment", "payment_method": paymentMethod, "payment_intent_id": paymentIntentId, "payment_method_id": paymentMethodId, "client_secret_id": clientSecretId, "payment_source_id": paymentSourceId])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var paymentMethod: String {
            get {
              return resultMap["payment_method"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "payment_method")
            }
          }

          public var paymentIntentId: String? {
            get {
              return resultMap["payment_intent_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "payment_intent_id")
            }
          }

          public var paymentMethodId: String? {
            get {
              return resultMap["payment_method_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "payment_method_id")
            }
          }

          public var clientSecretId: String {
            get {
              return resultMap["client_secret_id"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "client_secret_id")
            }
          }

          public var paymentSourceId: String? {
            get {
              return resultMap["payment_source_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "payment_source_id")
            }
          }
        }

        public struct Product: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Product"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("state", type: .nonNull(.scalar(ProductState.self))),
              GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
              GraphQLField("auction", type: .object(Auction.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, state: ProductState, merchant: Merchant, auction: Auction? = nil) {
            self.init(unsafeResultMap: ["__typename": "Product", "id": id, "state": state, "merchant": merchant.resultMap, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }])
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

          public var state: ProductState {
            get {
              return resultMap["state"]! as! ProductState
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
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

          public var auction: Auction? {
            get {
              return (resultMap["auction"] as? ResultMap).flatMap { Auction(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "auction")
            }
          }

          public struct Merchant: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Merchant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, name: String) {
              self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name])
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
        }
      }
    }
  }
}
