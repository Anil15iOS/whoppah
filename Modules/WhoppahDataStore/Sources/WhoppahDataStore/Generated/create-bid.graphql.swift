// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CreateBidMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation createBid($input: BidInput!) {
        createBid(input: $input) {
          __typename
          id
          state
          amount {
            __typename
            currency
            amount
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
          thread {
            __typename
            id
          }
        }
      }
      """

    public let operationName: String = "createBid"

    public var input: BidInput

    public init(input: BidInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createBid", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreateBid.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createBid: CreateBid) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "createBid": createBid.resultMap])
      }

      public var createBid: CreateBid {
        get {
          return CreateBid(unsafeResultMap: resultMap["createBid"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "createBid")
        }
      }

      public struct CreateBid: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Bid"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("state", type: .nonNull(.scalar(BidState.self))),
            GraphQLField("amount", type: .nonNull(.object(Amount.selections))),
            GraphQLField("auction", type: .nonNull(.object(Auction.selections))),
            GraphQLField("buyer", type: .nonNull(.object(Buyer.selections))),
            GraphQLField("thread", type: .object(Thread.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, state: BidState, amount: Amount, auction: Auction, buyer: Buyer, thread: Thread? = nil) {
          self.init(unsafeResultMap: ["__typename": "Bid", "id": id, "state": state, "amount": amount.resultMap, "auction": auction.resultMap, "buyer": buyer.resultMap, "thread": thread.flatMap { (value: Thread) -> ResultMap in value.resultMap }])
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

        public var thread: Thread? {
          get {
            return (resultMap["thread"] as? ResultMap).flatMap { Thread(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "thread")
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
      }
    }
  }
}
