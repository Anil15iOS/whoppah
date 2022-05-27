// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CreateAuctionMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation createAuction($input: AuctionInput!) {
        createAuction(input: $input) {
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
          product {
            __typename
            auction {
              __typename
              id
              state
            }
          }
        }
      }
      """

    public let operationName: String = "createAuction"

    public var input: AuctionInput

    public init(input: AuctionInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createAuction", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreateAuction.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createAuction: CreateAuction) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "createAuction": createAuction.resultMap])
      }

      public var createAuction: CreateAuction {
        get {
          return CreateAuction(unsafeResultMap: resultMap["createAuction"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "createAuction")
        }
      }

      public struct CreateAuction: GraphQLSelectionSet {
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
            GraphQLField("product", type: .nonNull(.object(Product.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, state: AuctionState, startDate: DateTime? = nil, expiryDate: DateTime? = nil, endDate: DateTime? = nil, bidCount: Int, buyNowPrice: BuyNowPrice? = nil, minimumBid: MinimumBid? = nil, allowBid: Bool, allowBuyNow: Bool, highestBid: HighestBid? = nil, product: Product) {
          self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state, "start_date": startDate, "expiry_date": expiryDate, "end_date": endDate, "bid_count": bidCount, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "minimum_bid": minimumBid.flatMap { (value: MinimumBid) -> ResultMap in value.resultMap }, "allow_bid": allowBid, "allow_buy_now": allowBuyNow, "highest_bid": highestBid.flatMap { (value: HighestBid) -> ResultMap in value.resultMap }, "product": product.resultMap])
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

        public struct Product: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Product"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("auction", type: .object(Auction.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(auction: Auction? = nil) {
            self.init(unsafeResultMap: ["__typename": "Product", "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
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
