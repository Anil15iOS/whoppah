// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class QuerrySuggestionsQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query querrySuggestions($query: String) {
        querySuggestions(query: $query)
      }
      """

    public let operationName: String = "querrySuggestions"

    public var query: String?

    public init(query: String? = nil) {
      self.query = query
    }

    public var variables: GraphQLMap? {
      return ["query": query]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("querySuggestions", arguments: ["query": GraphQLVariable("query")], type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(querySuggestions: [String]) {
        self.init(unsafeResultMap: ["__typename": "Query", "querySuggestions": querySuggestions])
      }

      public var querySuggestions: [String] {
        get {
          return resultMap["querySuggestions"]! as! [String]
        }
        set {
          resultMap.updateValue(newValue, forKey: "querySuggestions")
        }
      }
    }
  }
}
