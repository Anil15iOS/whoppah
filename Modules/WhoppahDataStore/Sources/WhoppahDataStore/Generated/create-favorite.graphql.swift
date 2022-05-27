// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CreateFavoriteMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation createFavorite($input: FavoriteInput!) {
        createFavorite(input: $input) {
          __typename
          id
          item {
            __typename
            ... on Product {
              __typename
              id
              favorite {
                __typename
                id
              }
            }
          }
        }
      }
      """

    public let operationName: String = "createFavorite"

    public var input: FavoriteInput

    public init(input: FavoriteInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createFavorite", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreateFavorite.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createFavorite: CreateFavorite) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "createFavorite": createFavorite.resultMap])
      }

      public var createFavorite: CreateFavorite {
        get {
          return CreateFavorite(unsafeResultMap: resultMap["createFavorite"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "createFavorite")
        }
      }

      public struct CreateFavorite: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Favorite"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("item", type: .nonNull(.object(Item.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, item: Item) {
          self.init(unsafeResultMap: ["__typename": "Favorite", "id": id, "item": item.resultMap])
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

          public static func makeProduct(id: UUID, favorite: AsProduct.Favorite? = nil) -> Item {
            return Item(unsafeResultMap: ["__typename": "Product", "id": id, "favorite": favorite.flatMap { (value: AsProduct.Favorite) -> ResultMap in value.resultMap }])
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
                GraphQLField("favorite", type: .object(Favorite.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, favorite: Favorite? = nil) {
              self.init(unsafeResultMap: ["__typename": "Product", "id": id, "favorite": favorite.flatMap { (value: Favorite) -> ResultMap in value.resultMap }])
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

            public var favorite: Favorite? {
              get {
                return (resultMap["favorite"] as? ResultMap).flatMap { Favorite(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "favorite")
              }
            }

            public struct Favorite: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Favorite"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID) {
                self.init(unsafeResultMap: ["__typename": "Favorite", "id": id])
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
