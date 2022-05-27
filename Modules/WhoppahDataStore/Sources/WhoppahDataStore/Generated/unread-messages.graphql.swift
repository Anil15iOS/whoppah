// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetUnreadMessageCountQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getUnreadMessageCount($id: UUID) {
        getUnreadMessageCount(id: $id)
      }
      """

    public let operationName: String = "getUnreadMessageCount"

    public var id: UUID?

    public init(id: UUID? = nil) {
      self.id = id
    }

    public var variables: GraphQLMap? {
      return ["id": id]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("getUnreadMessageCount", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.scalar(Int.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(getUnreadMessageCount: Int) {
        self.init(unsafeResultMap: ["__typename": "Query", "getUnreadMessageCount": getUnreadMessageCount])
      }

      public var getUnreadMessageCount: Int {
        get {
          return resultMap["getUnreadMessageCount"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "getUnreadMessageCount")
        }
      }
    }
  }
}
