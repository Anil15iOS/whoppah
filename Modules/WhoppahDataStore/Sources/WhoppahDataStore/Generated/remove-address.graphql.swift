// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class RemoveAddressMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation removeAddress($id: UUID!) {
        removeAddress(id: $id)
      }
      """

    public let operationName: String = "removeAddress"

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
          GraphQLField("removeAddress", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(removeAddress: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "removeAddress": removeAddress])
      }

      public var removeAddress: Bool {
        get {
          return resultMap["removeAddress"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "removeAddress")
        }
      }
    }
  }
}
