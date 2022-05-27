// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class PublishProductMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation publishProduct($id: UUID!) {
        publishProduct(id: $id) {
          __typename
          id
          state
        }
      }
      """

    public let operationName: String = "publishProduct"

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
          GraphQLField("publishProduct", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.object(PublishProduct.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(publishProduct: PublishProduct) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "publishProduct": publishProduct.resultMap])
      }

      public var publishProduct: PublishProduct {
        get {
          return PublishProduct(unsafeResultMap: resultMap["publishProduct"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "publishProduct")
        }
      }

      public struct PublishProduct: GraphQLSelectionSet {
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
