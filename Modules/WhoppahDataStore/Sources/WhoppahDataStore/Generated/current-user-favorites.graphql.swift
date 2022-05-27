// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetCurrentUserFavoritesQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getCurrentUserFavorites($pagination: Pagination) {
        favorites(pagination: $pagination) {
          __typename
          items {
            __typename
            id
            created
            item {
              __typename
              ... on Product {
                __typename
                id
              }
            }
          }
        }
      }
      """

    public let operationName: String = "getCurrentUserFavorites"

    public var pagination: Pagination?

    public init(pagination: Pagination? = nil) {
      self.pagination = pagination
    }

    public var variables: GraphQLMap? {
      return ["pagination": pagination]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("favorites", arguments: ["pagination": GraphQLVariable("pagination")], type: .nonNull(.object(Favorite.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(favorites: Favorite) {
        self.init(unsafeResultMap: ["__typename": "Query", "favorites": favorites.resultMap])
      }

      public var favorites: Favorite {
        get {
          return Favorite(unsafeResultMap: resultMap["favorites"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "favorites")
        }
      }

      public struct Favorite: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["FavoriteResult"]

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
          self.init(unsafeResultMap: ["__typename": "FavoriteResult", "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
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
          public static let possibleTypes: [String] = ["Favorite"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
              GraphQLField("item", type: .nonNull(.object(Item.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, created: DateTime, item: Item) {
            self.init(unsafeResultMap: ["__typename": "Favorite", "id": id, "created": created, "item": item.resultMap])
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

          public var created: DateTime {
            get {
              return resultMap["created"]! as! DateTime
            }
            set {
              resultMap.updateValue(newValue, forKey: "created")
            }
          }

          public var item: Item {
            get {
              return Item(unsafeResultMap: resultMap["item"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "item")
            }
          }

          public struct Item: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Product", "Merchant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLTypeCase(
                  variants: ["Product": AsProduct.selections],
                  default: [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  ]
                )
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public static func makeMerchant() -> Item {
              return Item(unsafeResultMap: ["__typename": "Merchant"])
            }

            public static func makeProduct(id: UUID) -> Item {
              return Item(unsafeResultMap: ["__typename": "Product", "id": id])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var asProduct: AsProduct? {
              get {
                if !AsProduct.possibleTypes.contains(__typename) { return nil }
                return AsProduct(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsProduct: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Product"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID) {
                self.init(unsafeResultMap: ["__typename": "Product", "id": id])
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
            }
          }
        }
      }
    }
  }
}
