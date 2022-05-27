// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CreateSavedSearchMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation createSavedSearch($input: SavedSearchInput!) {
        createSavedSearch(input: $input) {
          __typename
          id
          title
          link
        }
      }
      """

    public let operationName: String = "createSavedSearch"

    public var input: SavedSearchInput

    public init(input: SavedSearchInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createSavedSearch", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreateSavedSearch.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createSavedSearch: CreateSavedSearch) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "createSavedSearch": createSavedSearch.resultMap])
      }

      public var createSavedSearch: CreateSavedSearch {
        get {
          return CreateSavedSearch(unsafeResultMap: resultMap["createSavedSearch"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "createSavedSearch")
        }
      }

      public struct CreateSavedSearch: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SavedSearch"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("link", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, title: String? = nil, link: String) {
          self.init(unsafeResultMap: ["__typename": "SavedSearch", "id": id, "title": title, "link": link])
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

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var link: String {
          get {
            return resultMap["link"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "link")
          }
        }
      }
    }
  }
}
