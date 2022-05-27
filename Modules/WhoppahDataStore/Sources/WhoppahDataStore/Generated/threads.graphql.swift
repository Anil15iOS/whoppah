// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetThreadsQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getThreads($filters: [ThreadFilter!], $pagination: Pagination, $messagePagination: Pagination, $sort: ThreadSort, $order: Ordering) {
        threads(filters: $filters, pagination: $pagination, sort: $sort, order: $order) {
          __typename
          pagination {
            __typename
            page
            pages
            limit
            count
          }
          items {
            __typename
            id
            created
            updated
            unread_count
            item {
              __typename
              ... on Product {
                __typename
                id
                merchant {
                  __typename
                  ...ThreadsMerchant
                }
                thumbnails: images {
                  __typename
                  id
                  url(size: SM)
                }
              }
              ... on Merchant {
                __typename
                ...ThreadsMerchant
              }
            }
            subscribers {
              __typename
              id
              role
              merchant {
                __typename
                ...ThreadsMerchant
              }
            }
            messages(pagination: $messagePagination) {
              __typename
              id
              created
              sender {
                __typename
                id
                given_name
                family_name
              }
              merchant {
                __typename
                ...ThreadsMerchant
              }
              subscriber {
                __typename
                id
                role
              }
              item {
                __typename
                ... on Bid {
                  __typename
                  id
                  state
                  amount {
                    __typename
                    currency
                    amount
                  }
                }
              }
              body
            }
          }
        }
      }
      """

    public let operationName: String = "getThreads"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + ThreadsMerchant.fragmentDefinition)
      document.append("\n" + ThreadsMerchantAvatar.fragmentDefinition)
      return document
    }

    public var filters: [ThreadFilter]?
    public var pagination: Pagination?
    public var messagePagination: Pagination?
    public var sort: ThreadSort?
    public var order: Ordering?

    public init(filters: [ThreadFilter]?, pagination: Pagination? = nil, messagePagination: Pagination? = nil, sort: ThreadSort? = nil, order: Ordering? = nil) {
      self.filters = filters
      self.pagination = pagination
      self.messagePagination = messagePagination
      self.sort = sort
      self.order = order
    }

    public var variables: GraphQLMap? {
      return ["filters": filters, "pagination": pagination, "messagePagination": messagePagination, "sort": sort, "order": order]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("threads", arguments: ["filters": GraphQLVariable("filters"), "pagination": GraphQLVariable("pagination"), "sort": GraphQLVariable("sort"), "order": GraphQLVariable("order")], type: .nonNull(.object(Thread.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(threads: Thread) {
        self.init(unsafeResultMap: ["__typename": "Query", "threads": threads.resultMap])
      }

      public var threads: Thread {
        get {
          return Thread(unsafeResultMap: resultMap["threads"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "threads")
        }
      }

      public struct Thread: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ThreadResult"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("pagination", type: .nonNull(.object(Pagination.selections))),
            GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(pagination: Pagination, items: [Item]) {
          self.init(unsafeResultMap: ["__typename": "ThreadResult", "pagination": pagination.resultMap, "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
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
          public static let possibleTypes: [String] = ["Thread"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
              GraphQLField("updated", type: .scalar(DateTime.self)),
              GraphQLField("unread_count", type: .nonNull(.scalar(Int.self))),
              GraphQLField("item", type: .nonNull(.object(Item.selections))),
              GraphQLField("subscribers", type: .nonNull(.list(.nonNull(.object(Subscriber.selections))))),
              GraphQLField("messages", arguments: ["pagination": GraphQLVariable("messagePagination")], type: .nonNull(.list(.nonNull(.object(Message.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, created: DateTime, updated: DateTime? = nil, unreadCount: Int, item: Item, subscribers: [Subscriber], messages: [Message]) {
            self.init(unsafeResultMap: ["__typename": "Thread", "id": id, "created": created, "updated": updated, "unread_count": unreadCount, "item": item.resultMap, "subscribers": subscribers.map { (value: Subscriber) -> ResultMap in value.resultMap }, "messages": messages.map { (value: Message) -> ResultMap in value.resultMap }])
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

          public var updated: DateTime? {
            get {
              return resultMap["updated"] as? DateTime
            }
            set {
              resultMap.updateValue(newValue, forKey: "updated")
            }
          }

          public var unreadCount: Int {
            get {
              return resultMap["unread_count"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "unread_count")
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

          public var subscribers: [Subscriber] {
            get {
              return (resultMap["subscribers"] as! [ResultMap]).map { (value: ResultMap) -> Subscriber in Subscriber(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Subscriber) -> ResultMap in value.resultMap }, forKey: "subscribers")
            }
          }

          public var messages: [Message] {
            get {
              return (resultMap["messages"] as! [ResultMap]).map { (value: ResultMap) -> Message in Message(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Message) -> ResultMap in value.resultMap }, forKey: "messages")
            }
          }

          public struct Item: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Product", "Merchant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLTypeCase(
                  variants: ["Product": AsProduct.selections, "Merchant": AsMerchant.selections],
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

            public static func makeProduct(id: UUID, merchant: AsProduct.Merchant, thumbnails: [AsProduct.Thumbnail]) -> Item {
              return Item(unsafeResultMap: ["__typename": "Product", "id": id, "merchant": merchant.resultMap, "thumbnails": thumbnails.map { (value: AsProduct.Thumbnail) -> ResultMap in value.resultMap }])
            }

            public static func makeMerchant(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: AsMerchant.Avatar? = nil) -> Item {
              return Item(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: AsMerchant.Avatar) -> ResultMap in value.resultMap }])
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
                  GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
                  GraphQLField("images", alias: "thumbnails", type: .nonNull(.list(.nonNull(.object(Thumbnail.selections))))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, merchant: Merchant, thumbnails: [Thumbnail]) {
                self.init(unsafeResultMap: ["__typename": "Product", "id": id, "merchant": merchant.resultMap, "thumbnails": thumbnails.map { (value: Thumbnail) -> ResultMap in value.resultMap }])
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

              public var merchant: Merchant {
                get {
                  return Merchant(unsafeResultMap: resultMap["merchant"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "merchant")
                }
              }

              public var thumbnails: [Thumbnail] {
                get {
                  return (resultMap["thumbnails"] as! [ResultMap]).map { (value: ResultMap) -> Thumbnail in Thumbnail(unsafeResultMap: value) }
                }
                set {
                  resultMap.updateValue(newValue.map { (value: Thumbnail) -> ResultMap in value.resultMap }, forKey: "thumbnails")
                }
              }

              public struct Merchant: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Merchant"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("business_name", type: .scalar(String.self)),
                    GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                    GraphQLField("compliance_level", type: .scalar(Int.self)),
                    GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

                public var name: String {
                  get {
                    return resultMap["name"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "name")
                  }
                }

                public var businessName: String? {
                  get {
                    return resultMap["business_name"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "business_name")
                  }
                }

                public var type: MerchantType {
                  get {
                    return resultMap["type"]! as! MerchantType
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "type")
                  }
                }

                public var complianceLevel: Int? {
                  get {
                    return resultMap["compliance_level"] as? Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "compliance_level")
                  }
                }

                public var avatar: Avatar? {
                  get {
                    return (resultMap["avatar"] as? ResultMap).flatMap { Avatar(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "avatar")
                  }
                }

                public var fragments: Fragments {
                  get {
                    return Fragments(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }

                public struct Fragments {
                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public var threadsMerchant: ThreadsMerchant {
                    get {
                      return ThreadsMerchant(unsafeResultMap: resultMap)
                    }
                    set {
                      resultMap += newValue.resultMap
                    }
                  }
                }

                public struct Avatar: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Image"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                      GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

                  public var fragments: Fragments {
                    get {
                      return Fragments(unsafeResultMap: resultMap)
                    }
                    set {
                      resultMap += newValue.resultMap
                    }
                  }

                  public struct Fragments {
                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public var threadsMerchantAvatar: ThreadsMerchantAvatar {
                      get {
                        return ThreadsMerchantAvatar(unsafeResultMap: resultMap)
                      }
                      set {
                        resultMap += newValue.resultMap
                      }
                    }
                  }
                }
              }

              public struct Thumbnail: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Image"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("url", arguments: ["size": "SM"], type: .nonNull(.scalar(String.self))),
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

            public var asMerchant: AsMerchant? {
              get {
                if !AsMerchant.possibleTypes.contains(__typename) { return nil }
                return AsMerchant(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsMerchant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Merchant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("business_name", type: .scalar(String.self)),
                  GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                  GraphQLField("compliance_level", type: .scalar(Int.self)),
                  GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
                self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              public var businessName: String? {
                get {
                  return resultMap["business_name"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "business_name")
                }
              }

              public var type: MerchantType {
                get {
                  return resultMap["type"]! as! MerchantType
                }
                set {
                  resultMap.updateValue(newValue, forKey: "type")
                }
              }

              public var complianceLevel: Int? {
                get {
                  return resultMap["compliance_level"] as? Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "compliance_level")
                }
              }

              public var avatar: Avatar? {
                get {
                  return (resultMap["avatar"] as? ResultMap).flatMap { Avatar(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "avatar")
                }
              }

              public var fragments: Fragments {
                get {
                  return Fragments(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }

              public struct Fragments {
                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public var threadsMerchant: ThreadsMerchant {
                  get {
                    return ThreadsMerchant(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }
              }

              public struct Avatar: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Image"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

                public var fragments: Fragments {
                  get {
                    return Fragments(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }

                public struct Fragments {
                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public var threadsMerchantAvatar: ThreadsMerchantAvatar {
                    get {
                      return ThreadsMerchantAvatar(unsafeResultMap: resultMap)
                    }
                    set {
                      resultMap += newValue.resultMap
                    }
                  }
                }
              }
            }
          }

          public struct Subscriber: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Subscriber"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("role", type: .nonNull(.scalar(SubscriberRole.self))),
                GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, role: SubscriberRole, merchant: Merchant) {
              self.init(unsafeResultMap: ["__typename": "Subscriber", "id": id, "role": role, "merchant": merchant.resultMap])
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

            public var role: SubscriberRole {
              get {
                return resultMap["role"]! as! SubscriberRole
              }
              set {
                resultMap.updateValue(newValue, forKey: "role")
              }
            }

            public var merchant: Merchant {
              get {
                return Merchant(unsafeResultMap: resultMap["merchant"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "merchant")
              }
            }

            public struct Merchant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Merchant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("business_name", type: .scalar(String.self)),
                  GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                  GraphQLField("compliance_level", type: .scalar(Int.self)),
                  GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
                self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              public var businessName: String? {
                get {
                  return resultMap["business_name"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "business_name")
                }
              }

              public var type: MerchantType {
                get {
                  return resultMap["type"]! as! MerchantType
                }
                set {
                  resultMap.updateValue(newValue, forKey: "type")
                }
              }

              public var complianceLevel: Int? {
                get {
                  return resultMap["compliance_level"] as? Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "compliance_level")
                }
              }

              public var avatar: Avatar? {
                get {
                  return (resultMap["avatar"] as? ResultMap).flatMap { Avatar(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "avatar")
                }
              }

              public var fragments: Fragments {
                get {
                  return Fragments(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }

              public struct Fragments {
                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public var threadsMerchant: ThreadsMerchant {
                  get {
                    return ThreadsMerchant(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }
              }

              public struct Avatar: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Image"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

                public var fragments: Fragments {
                  get {
                    return Fragments(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }

                public struct Fragments {
                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public var threadsMerchantAvatar: ThreadsMerchantAvatar {
                    get {
                      return ThreadsMerchantAvatar(unsafeResultMap: resultMap)
                    }
                    set {
                      resultMap += newValue.resultMap
                    }
                  }
                }
              }
            }
          }

          public struct Message: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Message"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
                GraphQLField("sender", type: .nonNull(.object(Sender.selections))),
                GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
                GraphQLField("subscriber", type: .object(Subscriber.selections)),
                GraphQLField("item", type: .object(Item.selections)),
                GraphQLField("body", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, created: DateTime, sender: Sender, merchant: Merchant, subscriber: Subscriber? = nil, item: Item? = nil, body: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Message", "id": id, "created": created, "sender": sender.resultMap, "merchant": merchant.resultMap, "subscriber": subscriber.flatMap { (value: Subscriber) -> ResultMap in value.resultMap }, "item": item.flatMap { (value: Item) -> ResultMap in value.resultMap }, "body": body])
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

            public var sender: Sender {
              get {
                return Sender(unsafeResultMap: resultMap["sender"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "sender")
              }
            }

            public var merchant: Merchant {
              get {
                return Merchant(unsafeResultMap: resultMap["merchant"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "merchant")
              }
            }

            public var subscriber: Subscriber? {
              get {
                return (resultMap["subscriber"] as? ResultMap).flatMap { Subscriber(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "subscriber")
              }
            }

            public var item: Item? {
              get {
                return (resultMap["item"] as? ResultMap).flatMap { Item(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "item")
              }
            }

            public var body: String? {
              get {
                return resultMap["body"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "body")
              }
            }

            public struct Sender: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Member"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("given_name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("family_name", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, givenName: String, familyName: String) {
                self.init(unsafeResultMap: ["__typename": "Member", "id": id, "given_name": givenName, "family_name": familyName])
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

              public var givenName: String {
                get {
                  return resultMap["given_name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "given_name")
                }
              }

              public var familyName: String {
                get {
                  return resultMap["family_name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "family_name")
                }
              }
            }

            public struct Merchant: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Merchant"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("business_name", type: .scalar(String.self)),
                  GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
                  GraphQLField("compliance_level", type: .scalar(Int.self)),
                  GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
                self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              public var businessName: String? {
                get {
                  return resultMap["business_name"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "business_name")
                }
              }

              public var type: MerchantType {
                get {
                  return resultMap["type"]! as! MerchantType
                }
                set {
                  resultMap.updateValue(newValue, forKey: "type")
                }
              }

              public var complianceLevel: Int? {
                get {
                  return resultMap["compliance_level"] as? Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "compliance_level")
                }
              }

              public var avatar: Avatar? {
                get {
                  return (resultMap["avatar"] as? ResultMap).flatMap { Avatar(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "avatar")
                }
              }

              public var fragments: Fragments {
                get {
                  return Fragments(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }

              public struct Fragments {
                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public var threadsMerchant: ThreadsMerchant {
                  get {
                    return ThreadsMerchant(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }
              }

              public struct Avatar: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Image"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

                public var fragments: Fragments {
                  get {
                    return Fragments(unsafeResultMap: resultMap)
                  }
                  set {
                    resultMap += newValue.resultMap
                  }
                }

                public struct Fragments {
                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public var threadsMerchantAvatar: ThreadsMerchantAvatar {
                    get {
                      return ThreadsMerchantAvatar(unsafeResultMap: resultMap)
                    }
                    set {
                      resultMap += newValue.resultMap
                    }
                  }
                }
              }
            }

            public struct Subscriber: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Subscriber"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                  GraphQLField("role", type: .nonNull(.scalar(SubscriberRole.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: UUID, role: SubscriberRole) {
                self.init(unsafeResultMap: ["__typename": "Subscriber", "id": id, "role": role])
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

              public var role: SubscriberRole {
                get {
                  return resultMap["role"]! as! SubscriberRole
                }
                set {
                  resultMap.updateValue(newValue, forKey: "role")
                }
              }
            }

            public struct Item: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Product", "Order", "Bid", "Shipment", "Image", "Video", "Audio", "Document"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLTypeCase(
                    variants: ["Bid": AsBid.selections],
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

              public static func makeProduct() -> Item {
                return Item(unsafeResultMap: ["__typename": "Product"])
              }

              public static func makeOrder() -> Item {
                return Item(unsafeResultMap: ["__typename": "Order"])
              }

              public static func makeShipment() -> Item {
                return Item(unsafeResultMap: ["__typename": "Shipment"])
              }

              public static func makeImage() -> Item {
                return Item(unsafeResultMap: ["__typename": "Image"])
              }

              public static func makeVideo() -> Item {
                return Item(unsafeResultMap: ["__typename": "Video"])
              }

              public static func makeAudio() -> Item {
                return Item(unsafeResultMap: ["__typename": "Audio"])
              }

              public static func makeDocument() -> Item {
                return Item(unsafeResultMap: ["__typename": "Document"])
              }

              public static func makeBid(id: UUID, state: BidState, amount: AsBid.Amount) -> Item {
                return Item(unsafeResultMap: ["__typename": "Bid", "id": id, "state": state, "amount": amount.resultMap])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var asBid: AsBid? {
                get {
                  if !AsBid.possibleTypes.contains(__typename) { return nil }
                  return AsBid(unsafeResultMap: resultMap)
                }
                set {
                  guard let newValue = newValue else { return }
                  resultMap = newValue.resultMap
                }
              }

              public struct AsBid: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bid"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                    GraphQLField("state", type: .nonNull(.scalar(BidState.self))),
                    GraphQLField("amount", type: .nonNull(.object(Amount.selections))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(id: UUID, state: BidState, amount: Amount) {
                  self.init(unsafeResultMap: ["__typename": "Bid", "id": id, "state": state, "amount": amount.resultMap])
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

                public var state: BidState {
                  get {
                    return resultMap["state"]! as! BidState
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "state")
                  }
                }

                public var amount: Amount {
                  get {
                    return Amount(unsafeResultMap: resultMap["amount"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "amount")
                  }
                }

                public struct Amount: GraphQLSelectionSet {
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
            }
          }
        }
      }
    }
  }

  struct ThreadsMerchantAvatar: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment ThreadsMerchantAvatar on Image {
        __typename
        id
        url(size: MD)
      }
      """

    public static let possibleTypes: [String] = ["Image"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
        GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

  struct ThreadsMerchant: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment ThreadsMerchant on Merchant {
        __typename
        id
        name
        business_name
        type
        compliance_level
        avatar: image(type: AVATAR) {
          __typename
          ...ThreadsMerchantAvatar
        }
      }
      """

    public static let possibleTypes: [String] = ["Merchant"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("business_name", type: .scalar(String.self)),
        GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
        GraphQLField("compliance_level", type: .scalar(Int.self)),
        GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: UUID, name: String, businessName: String? = nil, type: MerchantType, complianceLevel: Int? = nil, avatar: Avatar? = nil) {
      self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "business_name": businessName, "type": type, "compliance_level": complianceLevel, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }])
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

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var businessName: String? {
      get {
        return resultMap["business_name"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "business_name")
      }
    }

    public var type: MerchantType {
      get {
        return resultMap["type"]! as! MerchantType
      }
      set {
        resultMap.updateValue(newValue, forKey: "type")
      }
    }

    public var complianceLevel: Int? {
      get {
        return resultMap["compliance_level"] as? Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "compliance_level")
      }
    }

    public var avatar: Avatar? {
      get {
        return (resultMap["avatar"] as? ResultMap).flatMap { Avatar(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "avatar")
      }
    }

    public struct Avatar: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Image"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
          GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var threadsMerchantAvatar: ThreadsMerchantAvatar {
          get {
            return ThreadsMerchantAvatar(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}
