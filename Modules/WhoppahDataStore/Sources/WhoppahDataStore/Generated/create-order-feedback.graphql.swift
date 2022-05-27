// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CreateFeedbackMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation createFeedback($id: UUID!, $received: Boolean!, $text: String) {
        createFeedback(id: $id, received: $received, text: $text) {
          __typename
          id
          state
          product {
            __typename
            id
            auction {
              __typename
              id
              state
            }
          }
          end_date
          delivery_feedback
        }
      }
      """

    public let operationName: String = "createFeedback"

    public var id: UUID
    public var received: Bool
    public var text: String?

    public init(id: UUID, received: Bool, text: String? = nil) {
      self.id = id
      self.received = received
      self.text = text
    }

    public var variables: GraphQLMap? {
      return ["id": id, "received": received, "text": text]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createFeedback", arguments: ["id": GraphQLVariable("id"), "received": GraphQLVariable("received"), "text": GraphQLVariable("text")], type: .nonNull(.object(CreateFeedback.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createFeedback: CreateFeedback) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "createFeedback": createFeedback.resultMap])
      }

      public var createFeedback: CreateFeedback {
        get {
          return CreateFeedback(unsafeResultMap: resultMap["createFeedback"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "createFeedback")
        }
      }

      public struct CreateFeedback: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Order"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("state", type: .nonNull(.scalar(OrderState.self))),
            GraphQLField("product", type: .nonNull(.object(Product.selections))),
            GraphQLField("end_date", type: .scalar(DateTime.self)),
            GraphQLField("delivery_feedback", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, state: OrderState, product: Product, endDate: DateTime? = nil, deliveryFeedback: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Order", "id": id, "state": state, "product": product.resultMap, "end_date": endDate, "delivery_feedback": deliveryFeedback])
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

        public var product: Product {
          get {
            return Product(unsafeResultMap: resultMap["product"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "product")
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

        public var deliveryFeedback: String? {
          get {
            return resultMap["delivery_feedback"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "delivery_feedback")
          }
        }

        public struct Product: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Product"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("auction", type: .object(Auction.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, auction: Auction? = nil) {
            self.init(unsafeResultMap: ["__typename": "Product", "id": id, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }])
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
