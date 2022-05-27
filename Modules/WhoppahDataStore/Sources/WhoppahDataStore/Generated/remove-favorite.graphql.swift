// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class RemoveFavoriteMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation removeFavorite($id: UUID!) {
        removeFavorite(id: $id)
      }
      """

    public let operationName: String = "removeFavorite"

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
          GraphQLField("removeFavorite", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(removeFavorite: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "removeFavorite": removeFavorite])
      }

      public var removeFavorite: Bool {
        get {
          return resultMap["removeFavorite"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "removeFavorite")
        }
      }
    }
  }
}
