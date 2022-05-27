// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class WithdrawProductMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation withdrawProduct($id: UUID!, $reason: ProductWithdrawReason) {
        withdrawProduct(id: $id, reason: $reason) {
          __typename
          id
          state
        }
      }
      """

    public let operationName: String = "withdrawProduct"

    public var id: UUID
    public var reason: ProductWithdrawReason?

    public init(id: UUID, reason: ProductWithdrawReason? = nil) {
      self.id = id
      self.reason = reason
    }

    public var variables: GraphQLMap? {
      return ["id": id, "reason": reason]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("withdrawProduct", arguments: ["id": GraphQLVariable("id"), "reason": GraphQLVariable("reason")], type: .nonNull(.object(WithdrawProduct.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(withdrawProduct: WithdrawProduct) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "withdrawProduct": withdrawProduct.resultMap])
      }

      public var withdrawProduct: WithdrawProduct {
        get {
          return WithdrawProduct(unsafeResultMap: resultMap["withdrawProduct"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "withdrawProduct")
        }
      }

      public struct WithdrawProduct: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Product"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("state", type: .nonNull(.scalar(ProductState.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, state: ProductState) {
          self.init(unsafeResultMap: ["__typename": "Product", "id": id, "state": state])
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
      }
    }
  }
}
