// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class SearchQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query search($type: SearchType, $query: String, $filter: SearchFilterInput, $pagination: Pagination, $sort: SearchSort, $order: Ordering, $playlist: PlaylistType = HLS) {
        search(
          type: $type
          query: $query
          filter: $filter
          pagination: $pagination
          sort: $sort
          order: $order
        ) {
          __typename
          query
          attributes {
            __typename
            title
            slug
            items {
              __typename
              key
              value
              attribute {
                __typename
                ... on Artist {
                  __typename
                  id
                  title
                  slug
                  description
                }
                ... on Brand {
                  __typename
                  id
                  title
                  slug
                  description
                }
                ... on Color {
                  __typename
                  id
                  title
                  hex
                  slug
                  description
                }
                ... on Designer {
                  __typename
                  id
                  title
                  slug
                  description
                }
                ... on Label {
                  __typename
                  id
                  slug
                  color
                  description
                }
                ... on Material {
                  __typename
                  id
                  slug
                  description
                }
                ... on Style {
                  __typename
                  id
                  slug
                  description
                }
              }
              count
              items {
                __typename
                key
                value
                attribute {
                  __typename
                  ... on Artist {
                    __typename
                    id
                    title
                    slug
                    description
                  }
                  ... on Brand {
                    __typename
                    id
                    title
                    slug
                    description
                  }
                  ... on Color {
                    __typename
                    id
                    title
                    hex
                    slug
                    description
                  }
                  ... on Designer {
                    __typename
                    id
                    title
                    slug
                    description
                  }
                  ... on Label {
                    __typename
                    id
                    slug
                    color
                    description
                  }
                  ... on Material {
                    __typename
                    id
                    slug
                    description
                  }
                  ... on Style {
                    __typename
                    id
                    slug
                    description
                  }
                }
                items {
                  __typename
                  ... on AttributeSearchFilterItem {
                    __typename
                    key
                    value
                    attribute {
                      __typename
                      ... on Artist {
                        __typename
                        id
                        title
                        slug
                        description
                      }
                      ... on Brand {
                        __typename
                        id
                        title
                        slug
                        description
                      }
                      ... on Color {
                        __typename
                        id
                        title
                        hex
                        slug
                        description
                      }
                      ... on Designer {
                        __typename
                        id
                        title
                        slug
                        description
                      }
                      ... on Label {
                        __typename
                        id
                        slug
                        color
                        description
                      }
                      ... on Material {
                        __typename
                        id
                        slug
                        description
                      }
                      ... on Style {
                        __typename
                        id
                        slug
                        description
                      }
                    }
                    items {
                      __typename
                      key
                      value
                      attribute {
                        __typename
                        ... on Artist {
                          __typename
                          id
                          title
                          description
                          slug
                        }
                        ... on Brand {
                          __typename
                          id
                          title
                          description
                          slug
                        }
                        ... on Color {
                          __typename
                          id
                          title
                          hex
                          slug
                          description
                        }
                        ... on Designer {
                          __typename
                          id
                          title
                          description
                          slug
                        }
                        ... on Material {
                          __typename
                          id
                          slug
                          description
                        }
                        ... on Label {
                          __typename
                          id
                          slug
                          color
                          description
                        }
                        ... on Style {
                          __typename
                          id
                          description
                          slug
                        }
                      }
                      items {
                        __typename
                        ... on AttributeSearchFilterItem {
                          __typename
                          key
                          value
                          items {
                            __typename
                            key
                            value
                            attribute {
                              __typename
                              ... on Artist {
                                __typename
                                id
                                title
                                description
                                slug
                              }
                              ... on Brand {
                                __typename
                                id
                                title
                                description
                                slug
                              }
                              ... on Color {
                                __typename
                                id
                                title
                                hex
                                slug
                                description
                              }
                              ... on Designer {
                                __typename
                                id
                                title
                                description
                                slug
                              }
                              ... on Material {
                                __typename
                                id
                                slug
                                description
                              }
                              ... on Label {
                                __typename
                                id
                                slug
                                color
                                description
                              }
                              ... on Style {
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
                }
              }
            }
          }
          categories {
            __typename
            items {
              __typename
              id
              title
              slug
              description
              items {
                __typename
                id
                title
                slug
                description
                items {
                  __typename
                  id
                  title
                  slug
                  description
                  items {
                    __typename
                    id
                    title
                    slug
                    description
                  }
                }
              }
            }
          }
          pagination {
            __typename
            page
            pages
            limit
            count
          }
          items {
            __typename
            ... on Product {
              __typename
              id
              title
              slug
              description
              state
              width
              height
              favorite {
                __typename
                id
              }
              auction {
                __typename
                id
                state
                buy_now_price {
                  __typename
                  currency
                  amount
                }
                minimum_bid {
                  __typename
                  currency
                  amount
                }
                allow_bid
                allow_buy_now
              }
              attributes {
                __typename
                ... on Label {
                  __typename
                  id
                  slug
                  color
                  description
                }
              }
              images {
                __typename
                id
                url
              }
              videos {
                __typename
                id
                url(playlist: $playlist)
                thumbnail(size: SM)
              }
              arobjects {
                __typename
                id
                url
                detection
                allows_pan
                allows_rotation
                url
                thumbnail(size: LG)
                type
              }
            }
          }
        }
      }
      """

    public let operationName: String = "search"

    public var type: SearchType?
    public var query: String?
    public var filter: SearchFilterInput?
    public var pagination: Pagination?
    public var sort: SearchSort?
    public var order: Ordering?
    public var playlist: PlaylistType?

    public init(type: SearchType? = nil, query: String? = nil, filter: SearchFilterInput? = nil, pagination: Pagination? = nil, sort: SearchSort? = nil, order: Ordering? = nil, playlist: PlaylistType? = nil) {
      self.type = type
      self.query = query
      self.filter = filter
      self.pagination = pagination
      self.sort = sort
      self.order = order
      self.playlist = playlist
    }

    public var variables: GraphQLMap? {
      return ["type": type, "query": query, "filter": filter, "pagination": pagination, "sort": sort, "order": order, "playlist": playlist]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("search", arguments: ["type": GraphQLVariable("type"), "query": GraphQLVariable("query"), "filter": GraphQLVariable("filter"), "pagination": GraphQLVariable("pagination"), "sort": GraphQLVariable("sort"), "order": GraphQLVariable("order")], type: .nonNull(.object(Search.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(search: Search) {
        self.init(unsafeResultMap: ["__typename": "Query", "search": search.resultMap])
      }

      public var search: Search {
        get {
          return Search(unsafeResultMap: resultMap["search"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "search")
        }
      }

      public struct Search: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SearchResult"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("query", type: .nonNull(.scalar(String.self))),
            GraphQLField("attributes", type: .nonNull(.list(.nonNull(.object(Attribute.selections))))),
            GraphQLField("categories", type: .nonNull(.object(Category.selections))),
            GraphQLField("pagination", type: .nonNull(.object(Pagination.selections))),
            GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(query: String, attributes: [Attribute], categories: Category, pagination: Pagination, items: [Item]) {
          self.init(unsafeResultMap: ["__typename": "SearchResult", "query": query, "attributes": attributes.map { (value: Attribute) -> ResultMap in value.resultMap }, "categories": categories.resultMap, "pagination": pagination.resultMap, "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var query: String {
          get {
            return resultMap["query"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "query")
          }
        }

        public var attributes: [Attribute] {
          get {
            return (resultMap["attributes"] as! [ResultMap]).map { (value: ResultMap) -> Attribute in Attribute(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Attribute) -> ResultMap in value.resultMap }, forKey: "attributes")
          }
        }

        public var categories: Category {
          get {
            return Category(unsafeResultMap: resultMap["categories"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "categories")
          }
        }

        public var pagination: Pagination {
          get {
            return Pagination(unsafeResultMap: resultMap["pagination"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pagination")
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

        public struct Attribute: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["AttributeSearchFilter"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(title: String, slug: String, items: [Item]) {
            self.init(unsafeResultMap: ["__typename": "AttributeSearchFilter", "title": title, "slug": slug, "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
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

          public var items: [Item] {
            get {
              return (resultMap["items"] as! [ResultMap]).map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Item) -> ResultMap in value.resultMap }, forKey: "items")
            }
          }

          public struct Item: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["AttributeSearchFilterItem"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("key", type: .nonNull(.scalar(String.self))),
                GraphQLField("value", type: .nonNull(.scalar(String.self))),
                GraphQLField("attribute", type: .nonNull(.object(Attribute.selections))),
                GraphQLField("count", type: .nonNull(.scalar(Int.self))),
                GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(key: String, value: String, attribute: Attribute, count: Int, items: [Item]? = nil) {
              self.init(unsafeResultMap: ["__typename": "AttributeSearchFilterItem", "key": key, "value": value, "attribute": attribute.resultMap, "count": count, "items": items.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var key: String {
              get {
                return resultMap["key"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "key")
              }
            }

            public var value: String {
              get {
                return resultMap["value"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "value")
              }
            }

            public var attribute: Attribute {
              get {
                return Attribute(unsafeResultMap: resultMap["attribute"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "attribute")
              }
            }

            public var count: Int {
              get {
                return resultMap["count"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "count")
              }
            }

            public var items: [Item]? {
              get {
                return (resultMap["items"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Item] in value.map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }, forKey: "items")
              }
            }

            public struct Attribute: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLTypeCase(
                    variants: ["Artist": AsArtist.selections, "Brand": AsBrand.selections, "Color": AsColor.selections, "Designer": AsDesigner.selections, "Label": AsLabel.selections, "Material": AsMaterial.selections, "Style": AsStyle.selections],
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

              public static func makeUsageSign() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "UsageSign"])
              }

              public static func makeAdditionalInfo() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "AdditionalInfo"])
              }

              public static func makeSubject() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Subject"])
              }

              public static func makeArtist(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
              }

              public static func makeBrand(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
              }

              public static func makeColor(id: UUID, title: String, hex: String, slug: String, description: String? = nil) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
              }

              public static func makeDesigner(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
              }

              public static func makeLabel(id: UUID, slug: String, color: String? = nil, description: String? = nil) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
              }

              public static func makeMaterial(id: UUID, slug: String, description: String? = nil) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
              }

              public static func makeStyle(id: UUID, slug: String, description: String? = nil) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var asArtist: AsArtist? {
                get {
                  if !AsArtist.possibleTypes.contains(__typename) { return nil }
                  return AsArtist(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsArtist: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Artist"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, description: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
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

                public var title: String {
                  get {
                    return resultMap["title"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "title")
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

              public var asBrand: AsBrand? {
                get {
                  if !AsBrand.possibleTypes.contains(__typename) { return nil }
                  return AsBrand(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsBrand: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Brand"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, description: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
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

                public var title: String {
                  get {
                    return resultMap["title"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "title")
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

              public var asColor: AsColor? {
                get {
                  if !AsColor.possibleTypes.contains(__typename) { return nil }
                  return AsColor(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsColor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Color"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("hex", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, hex: String, slug: String, description: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
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

                public var title: String {
                  get {
                    return resultMap["title"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "title")
                  }
                }

                public var hex: String {
                  get {
                    return resultMap["hex"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "hex")
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

              public var asDesigner: AsDesigner? {
                get {
                  if !AsDesigner.possibleTypes.contains(__typename) { return nil }
                  return AsDesigner(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsDesigner: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Designer"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, description: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
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

                public var title: String {
                  get {
                    return resultMap["title"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "title")
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

              public var asLabel: AsLabel? {
                get {
                  if !AsLabel.possibleTypes.contains(__typename) { return nil }
                  return AsLabel(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsLabel: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Label"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("color", type: .scalar(String.self)),
                    GraphQLField("description", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, slug: String, color: String? = nil, description: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
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

                @available(*, deprecated, message: "No longer supported")
                public var color: String? {
                  get {
                    return resultMap["color"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "color")
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

              public var asMaterial: AsMaterial? {
                get {
                  if !AsMaterial.possibleTypes.contains(__typename) { return nil }
                  return AsMaterial(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsMaterial: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Material"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
                  self.init(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
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

              public var asStyle: AsStyle? {
                get {
                  if !AsStyle.possibleTypes.contains(__typename) { return nil }
                  return AsStyle(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsStyle: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Style"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
                  self.init(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
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

            public struct Item: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["AttributeSearchFilterItem"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("key", type: .nonNull(.scalar(String.self))),
                  GraphQLField("value", type: .nonNull(.scalar(String.self))),
                  GraphQLField("attribute", type: .nonNull(.object(Attribute.selections))),
                  GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(key: String, value: String, attribute: Attribute, items: [Item]? = nil) {
                self.init(unsafeResultMap: ["__typename": "AttributeSearchFilterItem", "key": key, "value": value, "attribute": attribute.resultMap, "items": items.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var key: String {
                get {
                  return resultMap["key"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "key")
                }
              }

              public var value: String {
                get {
                  return resultMap["value"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "value")
                }
              }

              public var attribute: Attribute {
                get {
                  return Attribute(unsafeResultMap: resultMap["attribute"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "attribute")
                }
              }

              public var items: [Item]? {
                get {
                  return (resultMap["items"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Item] in value.map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) } }
                }
                set {
                  resultMap.updateValue(newValue.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }, forKey: "items")
                }
              }

              public struct Attribute: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLTypeCase(
                      variants: ["Artist": AsArtist.selections, "Brand": AsBrand.selections, "Color": AsColor.selections, "Designer": AsDesigner.selections, "Label": AsLabel.selections, "Material": AsMaterial.selections, "Style": AsStyle.selections],
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

                public static func makeUsageSign() -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "UsageSign"])
                }

                public static func makeAdditionalInfo() -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "AdditionalInfo"])
                }

                public static func makeSubject() -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "Subject"])
                }

                public static func makeArtist(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
                }

                public static func makeBrand(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
                }

                public static func makeColor(id: UUID, title: String, hex: String, slug: String, description: String? = nil) -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
                }

                public static func makeDesigner(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
                }

                public static func makeLabel(id: UUID, slug: String, color: String? = nil, description: String? = nil) -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
                }

                public static func makeMaterial(id: UUID, slug: String, description: String? = nil) -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
                }

                public static func makeStyle(id: UUID, slug: String, description: String? = nil) -> Attribute {
                  return Attribute(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var asArtist: AsArtist? {
                  get {
                    if !AsArtist.possibleTypes.contains(__typename) { return nil }
                    return AsArtist(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsArtist: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Artist"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("title", type: .nonNull(.scalar(String.self))),
                      GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                      GraphQLField("description", type: .scalar(String.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, title: String, slug: String, description: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
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

                  public var title: String {
                    get {
                      return resultMap["title"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "title")
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

                public var asBrand: AsBrand? {
                  get {
                    if !AsBrand.possibleTypes.contains(__typename) { return nil }
                    return AsBrand(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsBrand: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Brand"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("title", type: .nonNull(.scalar(String.self))),
                      GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                      GraphQLField("description", type: .scalar(String.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, title: String, slug: String, description: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
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

                  public var title: String {
                    get {
                      return resultMap["title"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "title")
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

                public var asColor: AsColor? {
                  get {
                    if !AsColor.possibleTypes.contains(__typename) { return nil }
                    return AsColor(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsColor: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Color"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("title", type: .nonNull(.scalar(String.self))),
                      GraphQLField("hex", type: .nonNull(.scalar(String.self))),
                      GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                      GraphQLField("description", type: .scalar(String.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, title: String, hex: String, slug: String, description: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
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

                  public var title: String {
                    get {
                      return resultMap["title"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "title")
                    }
                  }

                  public var hex: String {
                    get {
                      return resultMap["hex"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "hex")
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

                public var asDesigner: AsDesigner? {
                  get {
                    if !AsDesigner.possibleTypes.contains(__typename) { return nil }
                    return AsDesigner(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsDesigner: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Designer"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("title", type: .nonNull(.scalar(String.self))),
                      GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                      GraphQLField("description", type: .scalar(String.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, title: String, slug: String, description: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
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

                  public var title: String {
                    get {
                      return resultMap["title"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "title")
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

                public var asLabel: AsLabel? {
                  get {
                    if !AsLabel.possibleTypes.contains(__typename) { return nil }
                    return AsLabel(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsLabel: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Label"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                      GraphQLField("color", type: .scalar(String.self)),
                      GraphQLField("description", type: .scalar(String.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, slug: String, color: String? = nil, description: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
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

                  @available(*, deprecated, message: "No longer supported")
                  public var color: String? {
                    get {
                      return resultMap["color"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "color")
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

                public var asMaterial: AsMaterial? {
                  get {
                    if !AsMaterial.possibleTypes.contains(__typename) { return nil }
                    return AsMaterial(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsMaterial: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Material"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
                    self.init(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
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

                public var asStyle: AsStyle? {
                  get {
                    if !AsStyle.possibleTypes.contains(__typename) { return nil }
                    return AsStyle(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsStyle: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Style"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
                    self.init(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
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

              public struct Item: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["AttributeSearchFilterItem"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("key", type: .nonNull(.scalar(String.self))),
                    GraphQLField("value", type: .nonNull(.scalar(String.self))),
                    GraphQLField("attribute", type: .nonNull(.object(Attribute.selections))),
                    GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(key: String, value: String, attribute: Attribute, items: [Item]? = nil) {
                  self.init(unsafeResultMap: ["__typename": "AttributeSearchFilterItem", "key": key, "value": value, "attribute": attribute.resultMap, "items": items.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var key: String {
                  get {
                    return resultMap["key"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "key")
                  }
                }

                public var value: String {
                  get {
                    return resultMap["value"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "value")
                  }
                }

                public var attribute: Attribute {
                  get {
                    return Attribute(unsafeResultMap: resultMap["attribute"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "attribute")
                  }
                }

                public var items: [Item]? {
                  get {
                    return (resultMap["items"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Item] in value.map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) } }
                  }
                  set {
                    resultMap.updateValue(newValue.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }, forKey: "items")
                  }
                }

                public struct Attribute: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLTypeCase(
                        variants: ["Artist": AsArtist.selections, "Brand": AsBrand.selections, "Color": AsColor.selections, "Designer": AsDesigner.selections, "Label": AsLabel.selections, "Material": AsMaterial.selections, "Style": AsStyle.selections],
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

                  public static func makeUsageSign() -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "UsageSign"])
                  }

                  public static func makeAdditionalInfo() -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "AdditionalInfo"])
                  }

                  public static func makeSubject() -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "Subject"])
                  }

                  public static func makeArtist(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
                  }

                  public static func makeBrand(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
                  }

                  public static func makeColor(id: UUID, title: String, hex: String, slug: String, description: String? = nil) -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
                  }

                  public static func makeDesigner(id: UUID, title: String, slug: String, description: String? = nil) -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
                  }

                  public static func makeLabel(id: UUID, slug: String, color: String? = nil, description: String? = nil) -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
                  }

                  public static func makeMaterial(id: UUID, slug: String, description: String? = nil) -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
                  }

                  public static func makeStyle(id: UUID, slug: String, description: String? = nil) -> Attribute {
                    return Attribute(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var asArtist: AsArtist? {
                    get {
                      if !AsArtist.possibleTypes.contains(__typename) { return nil }
                      return AsArtist(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsArtist: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Artist"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                        GraphQLField("title", type: .nonNull(.scalar(String.self))),
                        GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                        GraphQLField("description", type: .scalar(String.self)),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(id: UUID, title: String, slug: String, description: String? = nil) {
                      self.init(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
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

                    public var title: String {
                      get {
                        return resultMap["title"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "title")
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

                  public var asBrand: AsBrand? {
                    get {
                      if !AsBrand.possibleTypes.contains(__typename) { return nil }
                      return AsBrand(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsBrand: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Brand"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                        GraphQLField("title", type: .nonNull(.scalar(String.self))),
                        GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                        GraphQLField("description", type: .scalar(String.self)),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(id: UUID, title: String, slug: String, description: String? = nil) {
                      self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
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

                    public var title: String {
                      get {
                        return resultMap["title"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "title")
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

                  public var asColor: AsColor? {
                    get {
                      if !AsColor.possibleTypes.contains(__typename) { return nil }
                      return AsColor(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsColor: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Color"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                        GraphQLField("title", type: .nonNull(.scalar(String.self))),
                        GraphQLField("hex", type: .nonNull(.scalar(String.self))),
                        GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                        GraphQLField("description", type: .scalar(String.self)),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(id: UUID, title: String, hex: String, slug: String, description: String? = nil) {
                      self.init(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
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

                    public var title: String {
                      get {
                        return resultMap["title"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "title")
                      }
                    }

                    public var hex: String {
                      get {
                        return resultMap["hex"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "hex")
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

                  public var asDesigner: AsDesigner? {
                    get {
                      if !AsDesigner.possibleTypes.contains(__typename) { return nil }
                      return AsDesigner(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsDesigner: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Designer"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                        GraphQLField("title", type: .nonNull(.scalar(String.self))),
                        GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                        GraphQLField("description", type: .scalar(String.self)),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(id: UUID, title: String, slug: String, description: String? = nil) {
                      self.init(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
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

                    public var title: String {
                      get {
                        return resultMap["title"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "title")
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

                  public var asLabel: AsLabel? {
                    get {
                      if !AsLabel.possibleTypes.contains(__typename) { return nil }
                      return AsLabel(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsLabel: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Label"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                        GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                        GraphQLField("color", type: .scalar(String.self)),
                        GraphQLField("description", type: .scalar(String.self)),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(id: UUID, slug: String, color: String? = nil, description: String? = nil) {
                      self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
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

                    @available(*, deprecated, message: "No longer supported")
                    public var color: String? {
                      get {
                        return resultMap["color"] as? String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "color")
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

                  public var asMaterial: AsMaterial? {
                    get {
                      if !AsMaterial.possibleTypes.contains(__typename) { return nil }
                      return AsMaterial(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsMaterial: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Material"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
                      self.init(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
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

                  public var asStyle: AsStyle? {
                    get {
                      if !AsStyle.possibleTypes.contains(__typename) { return nil }
                      return AsStyle(unsafeResultMap: resultMap)
                    }
                    set {
                      guard let newValue = newValue else { return }
                      resultMap = newValue.resultMap
                    }
                  }

                  public struct AsStyle: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Style"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
                      self.init(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
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

                public struct Item: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["AttributeSearchFilterItem"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("key", type: .nonNull(.scalar(String.self))),
                      GraphQLField("value", type: .nonNull(.scalar(String.self))),
                      GraphQLField("attribute", type: .nonNull(.object(Attribute.selections))),
                      GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(key: String, value: String, attribute: Attribute, items: [Item]? = nil) {
                    self.init(unsafeResultMap: ["__typename": "AttributeSearchFilterItem", "key": key, "value": value, "attribute": attribute.resultMap, "items": items.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var key: String {
                    get {
                      return resultMap["key"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "key")
                    }
                  }

                  public var value: String {
                    get {
                      return resultMap["value"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "value")
                    }
                  }

                  public var attribute: Attribute {
                    get {
                      return Attribute(unsafeResultMap: resultMap["attribute"]! as! ResultMap)
                    }
                    set {
                      resultMap.updateValue(newValue.resultMap, forKey: "attribute")
                    }
                  }

                  public var items: [Item]? {
                    get {
                      return (resultMap["items"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Item] in value.map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) } }
                    }
                    set {
                      resultMap.updateValue(newValue.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }, forKey: "items")
                    }
                  }

                  public struct Attribute: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLTypeCase(
                          variants: ["Artist": AsArtist.selections, "Brand": AsBrand.selections, "Color": AsColor.selections, "Designer": AsDesigner.selections, "Material": AsMaterial.selections, "Label": AsLabel.selections, "Style": AsStyle.selections],
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

                    public static func makeUsageSign() -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "UsageSign"])
                    }

                    public static func makeAdditionalInfo() -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "AdditionalInfo"])
                    }

                    public static func makeSubject() -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "Subject"])
                    }

                    public static func makeArtist(id: UUID, title: String, description: String? = nil, slug: String) -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "description": description, "slug": slug])
                    }

                    public static func makeBrand(id: UUID, title: String, description: String? = nil, slug: String) -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "description": description, "slug": slug])
                    }

                    public static func makeColor(id: UUID, title: String, hex: String, slug: String, description: String? = nil) -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
                    }

                    public static func makeDesigner(id: UUID, title: String, description: String? = nil, slug: String) -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "description": description, "slug": slug])
                    }

                    public static func makeMaterial(id: UUID, slug: String, description: String? = nil) -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
                    }

                    public static func makeLabel(id: UUID, slug: String, color: String? = nil, description: String? = nil) -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
                    }

                    public static func makeStyle(id: UUID, description: String? = nil, slug: String) -> Attribute {
                      return Attribute(unsafeResultMap: ["__typename": "Style", "id": id, "description": description, "slug": slug])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var asArtist: AsArtist? {
                      get {
                        if !AsArtist.possibleTypes.contains(__typename) { return nil }
                        return AsArtist(unsafeResultMap: resultMap)
                      }
                      set {
                        guard let newValue = newValue else { return }
                        resultMap = newValue.resultMap
                      }
                    }

                    public struct AsArtist: GraphQLSelectionSet {
                      public static let possibleTypes: [String] = ["Artist"]

                      public static var selections: [GraphQLSelection] {
                        return [
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                          GraphQLField("title", type: .nonNull(.scalar(String.self))),
                          GraphQLField("description", type: .scalar(String.self)),
                          GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                        ]
                      }

                      public private(set) var resultMap: ResultMap

                      public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                      }

                      public init(id: UUID, title: String, description: String? = nil, slug: String) {
                        self.init(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "description": description, "slug": slug])
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

                      public var title: String {
                        get {
                          return resultMap["title"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "title")
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

                      public var slug: String {
                        get {
                          return resultMap["slug"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "slug")
                        }
                      }
                    }

                    public var asBrand: AsBrand? {
                      get {
                        if !AsBrand.possibleTypes.contains(__typename) { return nil }
                        return AsBrand(unsafeResultMap: resultMap)
                      }
                      set {
                        guard let newValue = newValue else { return }
                        resultMap = newValue.resultMap
                      }
                    }

                    public struct AsBrand: GraphQLSelectionSet {
                      public static let possibleTypes: [String] = ["Brand"]

                      public static var selections: [GraphQLSelection] {
                        return [
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                          GraphQLField("title", type: .nonNull(.scalar(String.self))),
                          GraphQLField("description", type: .scalar(String.self)),
                          GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                        ]
                      }

                      public private(set) var resultMap: ResultMap

                      public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                      }

                      public init(id: UUID, title: String, description: String? = nil, slug: String) {
                        self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "description": description, "slug": slug])
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

                      public var title: String {
                        get {
                          return resultMap["title"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "title")
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

                      public var slug: String {
                        get {
                          return resultMap["slug"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "slug")
                        }
                      }
                    }

                    public var asColor: AsColor? {
                      get {
                        if !AsColor.possibleTypes.contains(__typename) { return nil }
                        return AsColor(unsafeResultMap: resultMap)
                      }
                      set {
                        guard let newValue = newValue else { return }
                        resultMap = newValue.resultMap
                      }
                    }

                    public struct AsColor: GraphQLSelectionSet {
                      public static let possibleTypes: [String] = ["Color"]

                      public static var selections: [GraphQLSelection] {
                        return [
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                          GraphQLField("title", type: .nonNull(.scalar(String.self))),
                          GraphQLField("hex", type: .nonNull(.scalar(String.self))),
                          GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                          GraphQLField("description", type: .scalar(String.self)),
                        ]
                      }

                      public private(set) var resultMap: ResultMap

                      public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                      }

                      public init(id: UUID, title: String, hex: String, slug: String, description: String? = nil) {
                        self.init(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
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

                      public var title: String {
                        get {
                          return resultMap["title"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "title")
                        }
                      }

                      public var hex: String {
                        get {
                          return resultMap["hex"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "hex")
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

                    public var asDesigner: AsDesigner? {
                      get {
                        if !AsDesigner.possibleTypes.contains(__typename) { return nil }
                        return AsDesigner(unsafeResultMap: resultMap)
                      }
                      set {
                        guard let newValue = newValue else { return }
                        resultMap = newValue.resultMap
                      }
                    }

                    public struct AsDesigner: GraphQLSelectionSet {
                      public static let possibleTypes: [String] = ["Designer"]

                      public static var selections: [GraphQLSelection] {
                        return [
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                          GraphQLField("title", type: .nonNull(.scalar(String.self))),
                          GraphQLField("description", type: .scalar(String.self)),
                          GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                        ]
                      }

                      public private(set) var resultMap: ResultMap

                      public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                      }

                      public init(id: UUID, title: String, description: String? = nil, slug: String) {
                        self.init(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "description": description, "slug": slug])
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

                      public var title: String {
                        get {
                          return resultMap["title"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "title")
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

                      public var slug: String {
                        get {
                          return resultMap["slug"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "slug")
                        }
                      }
                    }

                    public var asMaterial: AsMaterial? {
                      get {
                        if !AsMaterial.possibleTypes.contains(__typename) { return nil }
                        return AsMaterial(unsafeResultMap: resultMap)
                      }
                      set {
                        guard let newValue = newValue else { return }
                        resultMap = newValue.resultMap
                      }
                    }

                    public struct AsMaterial: GraphQLSelectionSet {
                      public static let possibleTypes: [String] = ["Material"]

                      public static var selections: [GraphQLSelection] {
                        return [
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
                        self.init(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
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

                    public var asLabel: AsLabel? {
                      get {
                        if !AsLabel.possibleTypes.contains(__typename) { return nil }
                        return AsLabel(unsafeResultMap: resultMap)
                      }
                      set {
                        guard let newValue = newValue else { return }
                        resultMap = newValue.resultMap
                      }
                    }

                    public struct AsLabel: GraphQLSelectionSet {
                      public static let possibleTypes: [String] = ["Label"]

                      public static var selections: [GraphQLSelection] {
                        return [
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                          GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                          GraphQLField("color", type: .scalar(String.self)),
                          GraphQLField("description", type: .scalar(String.self)),
                        ]
                      }

                      public private(set) var resultMap: ResultMap

                      public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                      }

                      public init(id: UUID, slug: String, color: String? = nil, description: String? = nil) {
                        self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
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

                      @available(*, deprecated, message: "No longer supported")
                      public var color: String? {
                        get {
                          return resultMap["color"] as? String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "color")
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

                    public var asStyle: AsStyle? {
                      get {
                        if !AsStyle.possibleTypes.contains(__typename) { return nil }
                        return AsStyle(unsafeResultMap: resultMap)
                      }
                      set {
                        guard let newValue = newValue else { return }
                        resultMap = newValue.resultMap
                      }
                    }

                    public struct AsStyle: GraphQLSelectionSet {
                      public static let possibleTypes: [String] = ["Style"]

                      public static var selections: [GraphQLSelection] {
                        return [
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                          GraphQLField("description", type: .scalar(String.self)),
                          GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                        ]
                      }

                      public private(set) var resultMap: ResultMap

                      public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                      }

                      public init(id: UUID, description: String? = nil, slug: String) {
                        self.init(unsafeResultMap: ["__typename": "Style", "id": id, "description": description, "slug": slug])
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

                      public var description: String? {
                        get {
                          return resultMap["description"] as? String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "description")
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
                    }
                  }

                  public struct Item: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["AttributeSearchFilterItem"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("key", type: .nonNull(.scalar(String.self))),
                        GraphQLField("value", type: .nonNull(.scalar(String.self))),
                        GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(key: String, value: String, items: [Item]? = nil) {
                      self.init(unsafeResultMap: ["__typename": "AttributeSearchFilterItem", "key": key, "value": value, "items": items.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var key: String {
                      get {
                        return resultMap["key"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "key")
                      }
                    }

                    public var value: String {
                      get {
                        return resultMap["value"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "value")
                      }
                    }

                    public var items: [Item]? {
                      get {
                        return (resultMap["items"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Item] in value.map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) } }
                      }
                      set {
                        resultMap.updateValue(newValue.flatMap { (value: [Item]) -> [ResultMap] in value.map { (value: Item) -> ResultMap in value.resultMap } }, forKey: "items")
                      }
                    }

                    public struct Item: GraphQLSelectionSet {
                      public static let possibleTypes: [String] = ["AttributeSearchFilterItem"]

                      public static var selections: [GraphQLSelection] {
                        return [
                          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                          GraphQLField("key", type: .nonNull(.scalar(String.self))),
                          GraphQLField("value", type: .nonNull(.scalar(String.self))),
                          GraphQLField("attribute", type: .nonNull(.object(Attribute.selections))),
                        ]
                      }

                      public private(set) var resultMap: ResultMap

                      public init(unsafeResultMap: ResultMap) {
                        self.resultMap = unsafeResultMap
                      }

                      public init(key: String, value: String, attribute: Attribute) {
                        self.init(unsafeResultMap: ["__typename": "AttributeSearchFilterItem", "key": key, "value": value, "attribute": attribute.resultMap])
                      }

                      public var __typename: String {
                        get {
                          return resultMap["__typename"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "__typename")
                        }
                      }

                      public var key: String {
                        get {
                          return resultMap["key"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "key")
                        }
                      }

                      public var value: String {
                        get {
                          return resultMap["value"]! as! String
                        }
                        set {
                          resultMap.updateValue(newValue, forKey: "value")
                        }
                      }

                      public var attribute: Attribute {
                        get {
                          return Attribute(unsafeResultMap: resultMap["attribute"]! as! ResultMap)
                        }
                        set {
                          resultMap.updateValue(newValue.resultMap, forKey: "attribute")
                        }
                      }

                      public struct Attribute: GraphQLSelectionSet {
                        public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

                        public static var selections: [GraphQLSelection] {
                          return [
                            GraphQLTypeCase(
                              variants: ["Artist": AsArtist.selections, "Brand": AsBrand.selections, "Color": AsColor.selections, "Designer": AsDesigner.selections, "Material": AsMaterial.selections, "Label": AsLabel.selections, "Style": AsStyle.selections],
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

                        public static func makeUsageSign() -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "UsageSign"])
                        }

                        public static func makeAdditionalInfo() -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "AdditionalInfo"])
                        }

                        public static func makeSubject() -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "Subject"])
                        }

                        public static func makeArtist(id: UUID, title: String, description: String? = nil, slug: String) -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "description": description, "slug": slug])
                        }

                        public static func makeBrand(id: UUID, title: String, description: String? = nil, slug: String) -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "description": description, "slug": slug])
                        }

                        public static func makeColor(id: UUID, title: String, hex: String, slug: String, description: String? = nil) -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
                        }

                        public static func makeDesigner(id: UUID, title: String, description: String? = nil, slug: String) -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "description": description, "slug": slug])
                        }

                        public static func makeMaterial(id: UUID, slug: String, description: String? = nil) -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
                        }

                        public static func makeLabel(id: UUID, slug: String, color: String? = nil, description: String? = nil) -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
                        }

                        public static func makeStyle(id: UUID, slug: String, description: String? = nil) -> Attribute {
                          return Attribute(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
                        }

                        public var __typename: String {
                          get {
                            return resultMap["__typename"]! as! String
                          }
                          set {
                            resultMap.updateValue(newValue, forKey: "__typename")
                          }
                        }

                        public var asArtist: AsArtist? {
                          get {
                            if !AsArtist.possibleTypes.contains(__typename) { return nil }
                            return AsArtist(unsafeResultMap: resultMap)
                          }
                          set {
                            guard let newValue = newValue else { return }
                            resultMap = newValue.resultMap
                          }
                        }

                        public struct AsArtist: GraphQLSelectionSet {
                          public static let possibleTypes: [String] = ["Artist"]

                          public static var selections: [GraphQLSelection] {
                            return [
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                              GraphQLField("title", type: .nonNull(.scalar(String.self))),
                              GraphQLField("description", type: .scalar(String.self)),
                              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                            ]
                          }

                          public private(set) var resultMap: ResultMap

                          public init(unsafeResultMap: ResultMap) {
                            self.resultMap = unsafeResultMap
                          }

                          public init(id: UUID, title: String, description: String? = nil, slug: String) {
                            self.init(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "description": description, "slug": slug])
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

                          public var title: String {
                            get {
                              return resultMap["title"]! as! String
                            }
                            set {
                              resultMap.updateValue(newValue, forKey: "title")
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

                          public var slug: String {
                            get {
                              return resultMap["slug"]! as! String
                            }
                            set {
                              resultMap.updateValue(newValue, forKey: "slug")
                            }
                          }
                        }

                        public var asBrand: AsBrand? {
                          get {
                            if !AsBrand.possibleTypes.contains(__typename) { return nil }
                            return AsBrand(unsafeResultMap: resultMap)
                          }
                          set {
                            guard let newValue = newValue else { return }
                            resultMap = newValue.resultMap
                          }
                        }

                        public struct AsBrand: GraphQLSelectionSet {
                          public static let possibleTypes: [String] = ["Brand"]

                          public static var selections: [GraphQLSelection] {
                            return [
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                              GraphQLField("title", type: .nonNull(.scalar(String.self))),
                              GraphQLField("description", type: .scalar(String.self)),
                              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                            ]
                          }

                          public private(set) var resultMap: ResultMap

                          public init(unsafeResultMap: ResultMap) {
                            self.resultMap = unsafeResultMap
                          }

                          public init(id: UUID, title: String, description: String? = nil, slug: String) {
                            self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "description": description, "slug": slug])
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

                          public var title: String {
                            get {
                              return resultMap["title"]! as! String
                            }
                            set {
                              resultMap.updateValue(newValue, forKey: "title")
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

                          public var slug: String {
                            get {
                              return resultMap["slug"]! as! String
                            }
                            set {
                              resultMap.updateValue(newValue, forKey: "slug")
                            }
                          }
                        }

                        public var asColor: AsColor? {
                          get {
                            if !AsColor.possibleTypes.contains(__typename) { return nil }
                            return AsColor(unsafeResultMap: resultMap)
                          }
                          set {
                            guard let newValue = newValue else { return }
                            resultMap = newValue.resultMap
                          }
                        }

                        public struct AsColor: GraphQLSelectionSet {
                          public static let possibleTypes: [String] = ["Color"]

                          public static var selections: [GraphQLSelection] {
                            return [
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                              GraphQLField("title", type: .nonNull(.scalar(String.self))),
                              GraphQLField("hex", type: .nonNull(.scalar(String.self))),
                              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                              GraphQLField("description", type: .scalar(String.self)),
                            ]
                          }

                          public private(set) var resultMap: ResultMap

                          public init(unsafeResultMap: ResultMap) {
                            self.resultMap = unsafeResultMap
                          }

                          public init(id: UUID, title: String, hex: String, slug: String, description: String? = nil) {
                            self.init(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
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

                          public var title: String {
                            get {
                              return resultMap["title"]! as! String
                            }
                            set {
                              resultMap.updateValue(newValue, forKey: "title")
                            }
                          }

                          public var hex: String {
                            get {
                              return resultMap["hex"]! as! String
                            }
                            set {
                              resultMap.updateValue(newValue, forKey: "hex")
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

                        public var asDesigner: AsDesigner? {
                          get {
                            if !AsDesigner.possibleTypes.contains(__typename) { return nil }
                            return AsDesigner(unsafeResultMap: resultMap)
                          }
                          set {
                            guard let newValue = newValue else { return }
                            resultMap = newValue.resultMap
                          }
                        }

                        public struct AsDesigner: GraphQLSelectionSet {
                          public static let possibleTypes: [String] = ["Designer"]

                          public static var selections: [GraphQLSelection] {
                            return [
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                              GraphQLField("title", type: .nonNull(.scalar(String.self))),
                              GraphQLField("description", type: .scalar(String.self)),
                              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                            ]
                          }

                          public private(set) var resultMap: ResultMap

                          public init(unsafeResultMap: ResultMap) {
                            self.resultMap = unsafeResultMap
                          }

                          public init(id: UUID, title: String, description: String? = nil, slug: String) {
                            self.init(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "description": description, "slug": slug])
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

                          public var title: String {
                            get {
                              return resultMap["title"]! as! String
                            }
                            set {
                              resultMap.updateValue(newValue, forKey: "title")
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

                          public var slug: String {
                            get {
                              return resultMap["slug"]! as! String
                            }
                            set {
                              resultMap.updateValue(newValue, forKey: "slug")
                            }
                          }
                        }

                        public var asMaterial: AsMaterial? {
                          get {
                            if !AsMaterial.possibleTypes.contains(__typename) { return nil }
                            return AsMaterial(unsafeResultMap: resultMap)
                          }
                          set {
                            guard let newValue = newValue else { return }
                            resultMap = newValue.resultMap
                          }
                        }

                        public struct AsMaterial: GraphQLSelectionSet {
                          public static let possibleTypes: [String] = ["Material"]

                          public static var selections: [GraphQLSelection] {
                            return [
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
                            self.init(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
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

                        public var asLabel: AsLabel? {
                          get {
                            if !AsLabel.possibleTypes.contains(__typename) { return nil }
                            return AsLabel(unsafeResultMap: resultMap)
                          }
                          set {
                            guard let newValue = newValue else { return }
                            resultMap = newValue.resultMap
                          }
                        }

                        public struct AsLabel: GraphQLSelectionSet {
                          public static let possibleTypes: [String] = ["Label"]

                          public static var selections: [GraphQLSelection] {
                            return [
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                              GraphQLField("color", type: .scalar(String.self)),
                              GraphQLField("description", type: .scalar(String.self)),
                            ]
                          }

                          public private(set) var resultMap: ResultMap

                          public init(unsafeResultMap: ResultMap) {
                            self.resultMap = unsafeResultMap
                          }

                          public init(id: UUID, slug: String, color: String? = nil, description: String? = nil) {
                            self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
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

                          @available(*, deprecated, message: "No longer supported")
                          public var color: String? {
                            get {
                              return resultMap["color"] as? String
                            }
                            set {
                              resultMap.updateValue(newValue, forKey: "color")
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

                        public var asStyle: AsStyle? {
                          get {
                            if !AsStyle.possibleTypes.contains(__typename) { return nil }
                            return AsStyle(unsafeResultMap: resultMap)
                          }
                          set {
                            guard let newValue = newValue else { return }
                            resultMap = newValue.resultMap
                          }
                        }

                        public struct AsStyle: GraphQLSelectionSet {
                          public static let possibleTypes: [String] = ["Style"]

                          public static var selections: [GraphQLSelection] {
                            return [
                              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
                            self.init(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
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

        public struct Category: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["CategorySearchFilter"]

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
            self.init(unsafeResultMap: ["__typename": "CategorySearchFilter", "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
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
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                GraphQLField("description", type: .scalar(String.self)),
                GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String, description: String? = nil, items: [Item]) {
              self.init(unsafeResultMap: ["__typename": "Category", "id": id, "title": title, "slug": slug, "description": description, "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
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

            public var title: String {
              get {
                return resultMap["title"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "title")
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

            @available(*, deprecated, message: "No longer supported")
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
                  GraphQLField("title", type: .nonNull(.scalar(String.self))),
                  GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                  GraphQLField("description", type: .scalar(String.self)),
                  GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, title: String, slug: String, description: String? = nil, items: [Item]) {
                self.init(unsafeResultMap: ["__typename": "Category", "id": id, "title": title, "slug": slug, "description": description, "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
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

              public var title: String {
                get {
                  return resultMap["title"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "title")
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

              @available(*, deprecated, message: "No longer supported")
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
                    GraphQLField("title", type: .nonNull(.scalar(String.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("description", type: .scalar(String.self)),
                    GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, title: String, slug: String, description: String? = nil, items: [Item]) {
                  self.init(unsafeResultMap: ["__typename": "Category", "id": id, "title": title, "slug": slug, "description": description, "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
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

                public var title: String {
                  get {
                    return resultMap["title"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "title")
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

                @available(*, deprecated, message: "No longer supported")
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
                      GraphQLField("title", type: .nonNull(.scalar(String.self))),
                      GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                      GraphQLField("description", type: .scalar(String.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: UUID, title: String, slug: String, description: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Category", "id": id, "title": title, "slug": slug, "description": description])
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

                  public var title: String {
                    get {
                      return resultMap["title"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "title")
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

        public struct Pagination: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PaginationResult"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("page", type: .nonNull(.scalar(Int.self))),
              GraphQLField("pages", type: .nonNull(.scalar(Int.self))),
              GraphQLField("limit", type: .nonNull(.scalar(Int.self))),
              GraphQLField("count", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(page: Int, pages: Int, limit: Int, count: Int) {
            self.init(unsafeResultMap: ["__typename": "PaginationResult", "page": page, "pages": pages, "limit": limit, "count": count])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var page: Int {
            get {
              return resultMap["page"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "page")
            }
          }

          public var pages: Int {
            get {
              return resultMap["pages"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "pages")
            }
          }

          public var limit: Int {
            get {
              return resultMap["limit"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "limit")
            }
          }

          public var count: Int {
            get {
              return resultMap["count"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "count")
            }
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Product", "Category", "Page"]

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

          public static func makeCategory() -> Item {
            return Item(unsafeResultMap: ["__typename": "Category"])
          }

          public static func makePage() -> Item {
            return Item(unsafeResultMap: ["__typename": "Page"])
          }

          public static func makeProduct(id: UUID, title: String, slug: String, description: String? = nil, state: ProductState, width: Int? = nil, height: Int? = nil, favorite: AsProduct.Favorite? = nil, auction: AsProduct.Auction? = nil, attributes: [AsProduct.Attribute], images: [AsProduct.Image], videos: [AsProduct.Video], arobjects: [AsProduct.Arobject]) -> Item {
            return Item(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "slug": slug, "description": description, "state": state, "width": width, "height": height, "favorite": favorite.flatMap { (value: AsProduct.Favorite) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: AsProduct.Auction) -> ResultMap in value.resultMap }, "attributes": attributes.map { (value: AsProduct.Attribute) -> ResultMap in value.resultMap }, "images": images.map { (value: AsProduct.Image) -> ResultMap in value.resultMap }, "videos": videos.map { (value: AsProduct.Video) -> ResultMap in value.resultMap }, "arobjects": arobjects.map { (value: AsProduct.Arobject) -> ResultMap in value.resultMap }])
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
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                GraphQLField("description", type: .scalar(String.self)),
                GraphQLField("state", type: .nonNull(.scalar(ProductState.self))),
                GraphQLField("width", type: .scalar(Int.self)),
                GraphQLField("height", type: .scalar(Int.self)),
                GraphQLField("favorite", type: .object(Favorite.selections)),
                GraphQLField("auction", type: .object(Auction.selections)),
                GraphQLField("attributes", type: .nonNull(.list(.nonNull(.object(Attribute.selections))))),
                GraphQLField("images", type: .nonNull(.list(.nonNull(.object(Image.selections))))),
                GraphQLField("videos", type: .nonNull(.list(.nonNull(.object(Video.selections))))),
                GraphQLField("arobjects", type: .nonNull(.list(.nonNull(.object(Arobject.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, title: String, slug: String, description: String? = nil, state: ProductState, width: Int? = nil, height: Int? = nil, favorite: Favorite? = nil, auction: Auction? = nil, attributes: [Attribute], images: [Image], videos: [Video], arobjects: [Arobject]) {
              self.init(unsafeResultMap: ["__typename": "Product", "id": id, "title": title, "slug": slug, "description": description, "state": state, "width": width, "height": height, "favorite": favorite.flatMap { (value: Favorite) -> ResultMap in value.resultMap }, "auction": auction.flatMap { (value: Auction) -> ResultMap in value.resultMap }, "attributes": attributes.map { (value: Attribute) -> ResultMap in value.resultMap }, "images": images.map { (value: Image) -> ResultMap in value.resultMap }, "videos": videos.map { (value: Video) -> ResultMap in value.resultMap }, "arobjects": arobjects.map { (value: Arobject) -> ResultMap in value.resultMap }])
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

            public var title: String {
              get {
                return resultMap["title"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "title")
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

            public var state: ProductState {
              get {
                return resultMap["state"]! as! ProductState
              }
              set {
                resultMap.updateValue(newValue, forKey: "state")
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

            public var favorite: Favorite? {
              get {
                return (resultMap["favorite"] as? ResultMap).flatMap { Favorite(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "favorite")
              }
            }

            public var auction: Auction? {
              get {
                return (resultMap["auction"] as? ResultMap).flatMap { Auction(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "auction")
              }
            }

            public var attributes: [Attribute] {
              get {
                return (resultMap["attributes"] as! [ResultMap]).map { (value: ResultMap) -> Attribute in Attribute(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Attribute) -> ResultMap in value.resultMap }, forKey: "attributes")
              }
            }

            public var images: [Image] {
              get {
                return (resultMap["images"] as! [ResultMap]).map { (value: ResultMap) -> Image in Image(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Image) -> ResultMap in value.resultMap }, forKey: "images")
              }
            }

            public var videos: [Video] {
              get {
                return (resultMap["videos"] as! [ResultMap]).map { (value: ResultMap) -> Video in Video(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Video) -> ResultMap in value.resultMap }, forKey: "videos")
              }
            }

            public var arobjects: [Arobject] {
              get {
                return (resultMap["arobjects"] as! [ResultMap]).map { (value: ResultMap) -> Arobject in Arobject(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Arobject) -> ResultMap in value.resultMap }, forKey: "arobjects")
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

            public struct Auction: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Auction"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("state", type: .nonNull(.scalar(AuctionState.self))),
                  GraphQLField("buy_now_price", type: .object(BuyNowPrice.selections)),
                  GraphQLField("minimum_bid", type: .object(MinimumBid.selections)),
                  GraphQLField("allow_bid", type: .nonNull(.scalar(Bool.self))),
                  GraphQLField("allow_buy_now", type: .nonNull(.scalar(Bool.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, state: AuctionState, buyNowPrice: BuyNowPrice? = nil, minimumBid: MinimumBid? = nil, allowBid: Bool, allowBuyNow: Bool) {
                self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "state": state, "buy_now_price": buyNowPrice.flatMap { (value: BuyNowPrice) -> ResultMap in value.resultMap }, "minimum_bid": minimumBid.flatMap { (value: MinimumBid) -> ResultMap in value.resultMap }, "allow_bid": allowBid, "allow_buy_now": allowBuyNow])
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

              public var state: AuctionState {
                get {
                  return resultMap["state"]! as! AuctionState
                }
                set {
                  resultMap.updateValue(newValue, forKey: "state")
                }
              }

              public var buyNowPrice: BuyNowPrice? {
                get {
                  return (resultMap["buy_now_price"] as? ResultMap).flatMap { BuyNowPrice(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "buy_now_price")
                }
              }

              public var minimumBid: MinimumBid? {
                get {
                  return (resultMap["minimum_bid"] as? ResultMap).flatMap { MinimumBid(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "minimum_bid")
                }
              }

              public var allowBid: Bool {
                get {
                  return resultMap["allow_bid"]! as! Bool
                }
                set {
                  resultMap.updateValue(newValue, forKey: "allow_bid")
                }
              }

              public var allowBuyNow: Bool {
                get {
                  return resultMap["allow_buy_now"]! as! Bool
                }
                set {
                  resultMap.updateValue(newValue, forKey: "allow_buy_now")
                }
              }

              public struct BuyNowPrice: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Price"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
                    GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(currency: Currency, amount: Double) {
                  self.init(unsafeResultMap: ["__typename": "Price", "currency": currency, "amount": amount])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var currency: Currency {
                  get {
                    return resultMap["currency"]! as! Currency
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "currency")
                  }
                }

                public var amount: Double {
                  get {
                    return resultMap["amount"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "amount")
                  }
                }
              }

              public struct MinimumBid: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Price"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
                    GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(currency: Currency, amount: Double) {
                  self.init(unsafeResultMap: ["__typename": "Price", "currency": currency, "amount": amount])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var currency: Currency {
                  get {
                    return resultMap["currency"]! as! Currency
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "currency")
                  }
                }

                public var amount: Double {
                  get {
                    return resultMap["amount"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "amount")
                  }
                }
              }
            }

            public struct Attribute: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLTypeCase(
                    variants: ["Label": AsLabel.selections],
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

              public static func makeArtist() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Artist"])
              }

              public static func makeBrand() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Brand"])
              }

              public static func makeColor() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Color"])
              }

              public static func makeDesigner() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Designer"])
              }

              public static func makeMaterial() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Material"])
              }

              public static func makeStyle() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Style"])
              }

              public static func makeUsageSign() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "UsageSign"])
              }

              public static func makeAdditionalInfo() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "AdditionalInfo"])
              }

              public static func makeSubject() -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Subject"])
              }

              public static func makeLabel(id: UUID, slug: String, color: String? = nil, description: String? = nil) -> Attribute {
                return Attribute(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var asLabel: AsLabel? {
                get {
                  if !AsLabel.possibleTypes.contains(__typename) { return nil }
                  return AsLabel(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsLabel: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Label"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("slug", type: .nonNull(.scalar(String.self))),
                    GraphQLField("color", type: .scalar(String.self)),
                    GraphQLField("description", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, slug: String, color: String? = nil, description: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
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

                @available(*, deprecated, message: "No longer supported")
                public var color: String? {
                  get {
                    return resultMap["color"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "color")
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

            public struct Image: GraphQLSelectionSet {
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

            public struct Video: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Video"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("url", arguments: ["playlist": GraphQLVariable("playlist")], type: .nonNull(.scalar(String.self))),
                  GraphQLField("thumbnail", arguments: ["size": "SM"], type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, url: String, thumbnail: String) {
                self.init(unsafeResultMap: ["__typename": "Video", "id": id, "url": url, "thumbnail": thumbnail])
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

              public var thumbnail: String {
                get {
                  return resultMap["thumbnail"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "thumbnail")
                }
              }
            }

            public struct Arobject: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ARObject"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("url", type: .nonNull(.scalar(String.self))),
                  GraphQLField("detection", type: .scalar(ARDetection.self)),
                  GraphQLField("allows_pan", type: .scalar(Bool.self)),
                  GraphQLField("allows_rotation", type: .scalar(Bool.self)),
                  GraphQLField("url", type: .nonNull(.scalar(String.self))),
                  GraphQLField("thumbnail", arguments: ["size": "LG"], type: .scalar(String.self)),
                  GraphQLField("type", type: .scalar(ARObjectType.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, url: String, detection: ARDetection? = nil, allowsPan: Bool? = nil, allowsRotation: Bool? = nil, thumbnail: String? = nil, type: ARObjectType? = nil) {
                self.init(unsafeResultMap: ["__typename": "ARObject", "id": id, "url": url, "detection": detection, "allows_pan": allowsPan, "allows_rotation": allowsRotation, "thumbnail": thumbnail, "type": type])
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

              @available(*, deprecated, message: "Not required")
              public var detection: ARDetection? {
                get {
                  return resultMap["detection"] as? ARDetection
                }
                set {
                  resultMap.updateValue(newValue, forKey: "detection")
                }
              }

              @available(*, deprecated, message: "Not required")
              public var allowsPan: Bool? {
                get {
                  return resultMap["allows_pan"] as? Bool
                }
                set {
                  resultMap.updateValue(newValue, forKey: "allows_pan")
                }
              }

              @available(*, deprecated, message: "Not required")
              public var allowsRotation: Bool? {
                get {
                  return resultMap["allows_rotation"] as? Bool
                }
                set {
                  resultMap.updateValue(newValue, forKey: "allows_rotation")
                }
              }

              @available(*, deprecated, message: "Not required")
              public var thumbnail: String? {
                get {
                  return resultMap["thumbnail"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "thumbnail")
                }
              }

              @available(*, deprecated, message: "Not required")
              public var type: ARObjectType? {
                get {
                  return resultMap["type"] as? ARObjectType
                }
                set {
                  resultMap.updateValue(newValue, forKey: "type")
                }
              }
            }
          }
        }
      }
    }
  }
}
