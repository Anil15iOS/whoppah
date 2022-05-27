// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class RemoveSavedSearchMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation removeSavedSearch($id: UUID!) {
        removeSavedSearch(id: $id)
      }
      """

    public let operationName: String = "removeSavedSearch"

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
          GraphQLField("removeSavedSearch", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(removeSavedSearch: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "removeSavedSearch": removeSavedSearch])
      }

      public var removeSavedSearch: Bool {
        get {
          return resultMap["removeSavedSearch"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "removeSavedSearch")
        }
      }
    }
  }
}
