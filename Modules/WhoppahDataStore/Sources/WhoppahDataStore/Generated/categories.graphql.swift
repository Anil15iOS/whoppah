// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetCategoriesQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getCategories($filters: [CategoryFilter!]) {
        categories(filters: $filters) {
          __typename
          items {
            __typename
            id
            link
            slug
            description
            media {
              __typename
              ... on Image {
                __typename
                id
                url
              }
            }
            detail_image: image(type: DETAIL) {
              __typename
              id
              url
            }
            items {
              __typename
              id
              link
              slug
              description
              media {
                __typename
                ... on Image {
                  __typename
                  id
                  url
                }
              }
              parent {
                __typename
                id
                slug
                description
              }
              items {
                __typename
                id
                link
                slug
                description
                media {
                  __typename
                  ... on Image {
                    __typename
                    id
                    url
                  }
                }
                parent {
                  __typename
                  id
                  slug
                  description
                  parent {
                    __typename
                    id
                    slug
                    description
                  }
                }
              }
            }
          }
        }
      }
      """

    public let operationName: String = "getCategories"

    public var filters: [CategoryFilter]?

    public init(filters: [CategoryFilter]?) {
      self.filters = filters
    }

    public var variables: GraphQLMap? {
      return ["filters": filters]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("categories", arguments: ["filters": GraphQLVariable("filters")], type: .nonNull(.object(Category.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(categories: Category) {
        self.init(unsafeResultMap: ["__typename": "Query", "categories": categories.resultMap])
      }

      public var categories: Category {
        get {
          return Category(unsafeResultMap: resultMap["categories"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "categories")
        }
      }

      public struct Category: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["CategoryResult"]

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
          self.init(unsafeResultMap: ["__typename": "CategoryResult", "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
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
          public static let possibleTypes: [String] = ["Category"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("link", type: .scalar(String.self)),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("media", type: .nonNull(.list(.nonNull(.object(Medium.selections))))),
              GraphQLField("image", alias: "detail_image", arguments: ["type": "DETAIL"], type: .object(DetailImage.selections)),
              GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, link: String? = nil, slug: String, description: String? = nil, media: [Medium], detailImage: DetailImage? = nil, items: [Item]) {
            self.init(unsafeResultMap: ["__typename": "Category", "id": id, "link": link, "slug": slug, "description": description, "media": media.map { (value: Medium) -> ResultMap in value.resultMap }, "detail_image": detailImage.flatMap { (value: DetailImage) -> ResultMap in value.resultMap }, "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
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

          public var link: String? {
            get {
              return resultMap["link"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "link")
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

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }

          public var media: [Medium] {
            get {
              return (resultMap["media"] as! [ResultMap]).map { (value: ResultMap) -> Medium in Medium(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Medium) -> ResultMap in value.resultMap }, forKey: "media")
            }
          }

          public var detailImage: DetailImage? {
            get {
              return (resultMap["detail_image"] as? ResultMap).flatMap { DetailImage(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "detail_image")
            }
          }

          @available(*, deprecated, message: "No longer supported")
          public var items: [Item] {
            get {
              return (resultMap["items"] as! [ResultMap]).map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Item) -> ResultMap in value.resultMap }, forKey: "items")
            }
          }

          public struct Medium: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLTypeCase(
                  variants: ["Image": AsImage.selections],
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

            public static func makeAudio() -> Medium {
              return Medium(unsafeResultMap: ["__typename": "Audio"])
            }

            public static func makeDocument() -> Medium {
              return Medium(unsafeResultMap: ["__typename": "Document"])
            }

            public static func makeARObject() -> Medium {
              return Medium(unsafeResultMap: ["__typename": "ARObject"])
            }

            public static func makeVideo() -> Medium {
              return Medium(unsafeResultMap: ["__typename": "Video"])
            }

            public static func makeImage(id: UUID, url: String) -> Medium {
              return Medium(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var asImage: AsImage? {
              get {
                if !AsImage.possibleTypes.contains(__typename) { return nil }
                return AsImage(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsImage: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Image"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("url", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, url: String) {
                self.init(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
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

          public struct DetailImage: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("url", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, url: String) {
              self.init(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
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

            public var url: String {
              get {
                return resultMap["url"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }
          }

          public struct Item: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Category"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("link", type: .scalar(String.self)),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                GraphQLField("description", type: .scalar(String.self)),
                GraphQLField("media", type: .nonNull(.list(.nonNull(.object(Medium.selections))))),
                GraphQLField("parent", type: .object(Parent.selections)),
                GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, link: String? = nil, slug: String, description: String? = nil, media: [Medium], parent: Parent? = nil, items: [Item]) {
              self.init(unsafeResultMap: ["__typename": "Category", "id": id, "link": link, "slug": slug, "description": description, "media": media.map { (value: Medium) -> ResultMap in value.resultMap }, "parent": parent.flatMap { (value: Parent) -> ResultMap in value.resultMap }, "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
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

            public var link: String? {
              get {
                return resultMap["link"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "link")
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

            public var description: String? {
              get {
                return resultMap["description"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "description")
              }
            }

            public var media: [Medium] {
              get {
                return (resultMap["media"] as! [ResultMap]).map { (value: ResultMap) -> Medium in Medium(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Medium) -> ResultMap in value.resultMap }, forKey: "media")
              }
            }

            public var parent: Parent? {
              get {
                return (resultMap["parent"] as? ResultMap).flatMap { Parent(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "parent")
              }
            }

            @available(*, deprecated, message: "No longer supported")
            public var items: [Item] {
              get {
                return (resultMap["items"] as! [ResultMap]).map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Item) -> ResultMap in value.resultMap }, forKey: "items")
              }
            }

            public struct Medium: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLTypeCase(
                    variants: ["Image": AsImage.selections],
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

              public static func makeAudio() -> Medium {
                return Medium(unsafeResultMap: ["__typename": "Audio"])
              }

              public static func makeDocument() -> Medium {
                return Medium(unsafeResultMap: ["__typename": "Document"])
              }

              public static func makeARObject() -> Medium {
                return Medium(unsafeResultMap: ["__typename": "ARObject"])
              }

              public static func makeVideo() -> Medium {
                return Medium(unsafeResultMap: ["__typename": "Video"])
              }

              public static func makeImage(id: UUID, url: String) -> Medium {
                return Medium(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var asImage: AsImage? {
                get {
                  if !AsImage.possibleTypes.contains(__typename) { return nil }
                  return AsImage(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsImage: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Image"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("url", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, url: String) {
                  self.init(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
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

            public struct Parent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Category"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                  GraphQLField("description", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, slug: String, description: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Category", "id": id, "slug": slug, "description": description])
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

              public var description: String? {
                get {
                  return resultMap["description"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "description")
                }
              }
            }

            public struct Item: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Category"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("link", type: .scalar(String.self)),
                  GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                  GraphQLField("description", type: .scalar(String.self)),
                  GraphQLField("media", type: .nonNull(.list(.nonNull(.object(Medium.selections))))),
                  GraphQLField("parent", type: .object(Parent.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, link: String? = nil, slug: String, description: String? = nil, media: [Medium], parent: Parent? = nil) {
                self.init(unsafeResultMap: ["__typename": "Category", "id": id, "link": link, "slug": slug, "description": description, "media": media.map { (value: Medium) -> ResultMap in value.resultMap }, "parent": parent.flatMap { (value: Parent) -> ResultMap in value.resultMap }])
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

              public var link: String? {
                get {
                  return resultMap["link"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "link")
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

              public var description: String? {
                get {
                  return resultMap["description"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "description")
                }
              }

              public var media: [Medium] {
                get {
                  return (resultMap["media"] as! [ResultMap]).map { (value: ResultMap) -> Medium in Medium(unsafeResultMap: value) }
                }
                set {
                  resultMap.updateValue(newValue.map { (value: Medium) -> ResultMap in value.resultMap }, forKey: "media")
                }
              }

              public var parent: Parent? {
                get {
                  return (resultMap["parent"] as? ResultMap).flatMap { Parent(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "parent")
                }
              }

              public struct Medium: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLTypeCase(
                      variants: ["Image": AsImage.selections],
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

                public static func makeAudio() -> Medium {
                  return Medium(unsafeResultMap: ["__typename": "Audio"])
                }

                public static func makeDocument() -> Medium {
                  return Medium(unsafeResultMap: ["__typename": "Document"])
                }

                public static func makeARObject() -> Medium {
                  return Medium(unsafeResultMap: ["__typename": "ARObject"])
                }

                public static func makeVideo() -> Medium {
                  return Medium(unsafeResultMap: ["__typename": "Video"])
                }

                public static func makeImage(id: UUID, url: String) -> Medium {
                  return Medium(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var asImage: AsImage? {
                  get {
                    if !AsImage.possibleTypes.contains(__typename) { return nil }
                    return AsImage(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsImage: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Image"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("url", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, url: String) {
                    self.init(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
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

              public struct Parent: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Category"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                    GraphQLField("parent", type: .object(Parent.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, slug: String, description: String? = nil, parent: Parent? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Category", "id": id, "slug": slug, "description": description, "parent": parent.flatMap { (value: Parent) -> ResultMap in value.resultMap }])
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

                public var description: String? {
                  get {
                    return resultMap["description"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "description")
                  }
                }

                public var parent: Parent? {
                  get {
                    return (resultMap["parent"] as? ResultMap).flatMap { Parent(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "parent")
                  }
                }

                public struct Parent: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Category"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                      GraphQLField("description", type: .scalar(String.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, slug: String, description: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Category", "id": id, "slug": slug, "description": description])
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

                  public var description: String? {
                    get {
                      return resultMap["description"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "description")
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
