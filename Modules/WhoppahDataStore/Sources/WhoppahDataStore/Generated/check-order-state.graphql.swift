// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CheckOrderPaymentMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation checkOrderPayment($id: UUID!) {
        checkOrderPayment(id: $id) {
          __typename
          id
          state
        }
      }
      """

    public let operationName: String = "checkOrderPayment"

    public var id: UUID

    public init(id: UUID) {
      self.id = id
    }

    public var variables: GraphQLMap? {
      return ["id": id]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("checkOrderPayment", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.object(CheckOrderPayment.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(checkOrderPayment: CheckOrderPayment) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "checkOrderPayment": checkOrderPayment.resultMap])
      }

      public var checkOrderPayment: CheckOrderPayment {
        get {
          return CheckOrderPayment(unsafeResultMap: resultMap["checkOrderPayment"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "checkOrderPayment")
        }
      }

      public struct CheckOrderPayment: GraphQLSelectionSet {
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
}
