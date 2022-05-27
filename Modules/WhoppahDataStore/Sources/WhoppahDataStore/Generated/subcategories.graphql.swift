// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetSubcategoriesQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getSubcategories($category: String, $style: String, $brand: String) {
        subcategories(input: {category: $category, style: $style, brand: $brand}) {
          __typename
          id
          slug
          route
          avatarImage: image(type: AVATAR) {
            __typename
            id
            width
            height
            url
          }
        }
      }
      """

    public let operationName: String = "getSubcategories"

    public var category: String?
    public var style: String?
    public var brand: String?

    public init(category: String? = nil, style: String? = nil, brand: String? = nil) {
      self.category = category
      self.style = style
      self.brand = brand
    }

    public var variables: GraphQLMap? {
      return ["category": category, "style": style, "brand": brand]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("subcategories", arguments: ["input": ["category": GraphQLVariable("category"), "style": GraphQLVariable("style"), "brand": GraphQLVariable("brand")]], type: .nonNull(.list(.nonNull(.object(Subcategory.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(subcategories: [Subcategory]) {
        self.init(unsafeResultMap: ["__typename": "Query", "subcategories": subcategories.map { (value: Subcategory) -> ResultMap in value.resultMap }])
      }

      public var subcategories: [Subcategory] {
        get {
          return (resultMap["subcategories"] as! [ResultMap]).map { (value: ResultMap) -> Subcategory in Subcategory(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Subcategory) -> ResultMap in value.resultMap }, forKey: "subcategories")
        }
      }

      public struct Subcategory: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Category"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("slug", type: .nonNull(.scalar(String.self))),
            GraphQLField("route", type: .scalar(String.self)),
            GraphQLField("image", alias: "avatarImage", arguments: ["type": "AVATAR"], type: .object(AvatarImage.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, slug: String, route: String? = nil, avatarImage: AvatarImage? = nil) {
          self.init(unsafeResultMap: ["__typename": "Category", "id": id, "slug": slug, "route": route, "avatarImage": avatarImage.flatMap { (value: AvatarImage) -> ResultMap in value.resultMap }])
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

        public var slug: String {
          get {
            return resultMap["slug"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "slug")
          }
        }

        public var route: String? {
          get {
            return resultMap["route"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "route")
          }
        }

        public var avatarImage: AvatarImage? {
          get {
            return (resultMap["avatarImage"] as? ResultMap).flatMap { AvatarImage(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "avatarImage")
          }
        }

        public struct AvatarImage: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("width", type: .scalar(Int.self)),
              GraphQLField("height", type: .scalar(Int.self)),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, width: Int? = nil, height: Int? = nil, url: String) {
            self.init(unsafeResultMap: ["__typename": "Image", "id": id, "width": width, "height": height, "url": url])
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

          public var width: Int? {
            get {
              return resultMap["width"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "width")
            }
          }

          public var height: Int? {
            get {
              return resultMap["height"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "height")
            }
          }

          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }
        }
      }
    }
  }
}
