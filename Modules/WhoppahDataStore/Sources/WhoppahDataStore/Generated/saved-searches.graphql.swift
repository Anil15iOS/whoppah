// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class SavedSearchesQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query savedSearches {
        savedSearches {
          __typename
          items {
            __typename
            id
            title
            link
          }
        }
      }
      """

    public let operationName: String = "savedSearches"

    public init() {
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("savedSearches", type: .nonNull(.object(SavedSearch.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(savedSearches: SavedSearch) {
        self.init(unsafeResultMap: ["__typename": "Query", "savedSearches": savedSearches.resultMap])
      }

      public var savedSearches: SavedSearch {
        get {
          return SavedSearch(unsafeResultMap: resultMap["savedSearches"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "savedSearches")
        }
      }

      public struct SavedSearch: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SavedSearchResult"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(items: [Item]) {
          self.init(unsafeResultMap: ["__typename": "SavedSearchResult", "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item] {
          get {
            return (resultMap["items"] as! [ResultMap]).map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Item) -> ResultMap in value.resultMap }, forKey: "items")
          }
        }

        public struct Item: GraphQLSelectionSet {
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
}
