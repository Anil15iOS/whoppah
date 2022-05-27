// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class RemoveMediaMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation removeMedia($id: UUID!) {
        removeMedia(id: $id)
      }
      """

    public let operationName: String = "removeMedia"

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
          GraphQLField("removeMedia", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(removeMedia: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "removeMedia": removeMedia])
      }

      public var removeMedia: Bool {
        get {
          return resultMap["removeMedia"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "removeMedia")
        }
      }
    }
  }
}
