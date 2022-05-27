// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetBidQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getBid($id: UUID!) {
        bid(id: $id) {
          __typename
          id
          created
          expiry_date
          end_date
          state
          is_counter
          amount {
            __typename
            amount
            currency
          }
          thread {
            __typename
            id
          }
          amount {
            __typename
            currency
            amount
          }
          order {
            __typename
            id
            state
          }
          auction {
            __typename
            id
            bid_count
            state
          }
          buyer {
            __typename
            id
          }
          merchant {
            __typename
            id
          }
        }
      }
      """

    public let operationName: String = "getBid"

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
          GraphQLField("bid", arguments: ["id": GraphQLVariable("id")], type: .object(Bid.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(bid: Bid? = nil) {
        self.init(unsafeResultMap: ["__typename": "Query", "bid": bid.flatMap { (value: Bid) -> ResultMap in value.resultMap }])
      }

      public var bid: Bid? {
        get {
          return (resultMap["bid"] as? ResultMap).flatMap { Bid(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "bid")
        }
      }

      public struct Bid: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Bid"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
            GraphQLField("expiry_date", type: .nonNull(.scalar(DateTime.self))),
            GraphQLField("end_date", type: .scalar(DateTime.self)),
            GraphQLField("state", type: .nonNull(.scalar(BidState.self))),
            GraphQLField("is_counter", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("amount", type: .nonNull(.object(Amount.selections))),
            GraphQLField("thread", type: .object(Thread.selections)),
            GraphQLField("amount", type: .nonNull(.object(Amount.selections))),
            GraphQLField("order", type: .object(Order.selections)),
            GraphQLField("auction", type: .nonNull(.object(Auction.selections))),
            GraphQLField("buyer", type: .nonNull(.object(Buyer.selections))),
            GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, created: DateTime, expiryDate: DateTime, endDate: DateTime? = nil, state: BidState, isCounter: Bool, amount: Amount, thread: Thread? = nil, order: Order? = nil, auction: Auction, buyer: Buyer, merchant: Merchant) {
          self.init(unsafeResultMap: ["__typename": "Bid", "id": id, "created": created, "expiry_date": expiryDate, "end_date": endDate, "state": state, "is_counter": isCounter, "amount": amount.resultMap, "thread": thread.flatMap { (value: Thread) -> ResultMap in value.resultMap }, "order": order.flatMap { (value: Order) -> ResultMap in value.resultMap }, "auction": auction.resultMap, "buyer": buyer.resultMap, "merchant": merchant.resultMap])
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

        public var state: BidState {
          get {
            return resultMap["state"]! as! BidState
          }
          set {
            resultMap.updateValue(newValue, forKey: "state")
          }
        }

        public var isCounter: Bool {
          get {
            return resultMap["is_counter"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "is_counter")
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

        public var thread: Thread? {
          get {
            return (resultMap["thread"] as? ResultMap).flatMap { Thread(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "thread")
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

        public var auction: Auction {
          get {
            return Auction(unsafeResultMap: resultMap["auction"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "auction")
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

        public struct Amount: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Price"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
              GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
              GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
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

        public struct Thread: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Thread"]

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
            self.init(unsafeResultMap: ["__typename": "Thread", "id": id])
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

        public struct Auction: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Auction"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("bid_count", type: .nonNull(.scalar(Int.self))),
              GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, bidCount: Int, state: AuctionState) {
            self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "bid_count": bidCount, "state": state])
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

          public var bidCount: Int {
            get {
              return resultMap["bid_count"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "bid_count")
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
      }
    }
  }
}
