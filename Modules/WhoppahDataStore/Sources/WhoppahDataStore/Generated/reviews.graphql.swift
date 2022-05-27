// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetReviewsQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getReviews($filters: [ReviewFilter!]!, $pagination: Pagination, $sort: ReviewSort, $order: Ordering) {
        reviews(filters: $filters, pagination: $pagination, sort: $sort, order: $order) {
          __typename
          items {
            __typename
            id
            review
            reviewer {
              __typename
              name
            }
            anonymous
            score
            created
          }
        }
      }
      """

    public let operationName: String = "getReviews"

    public var filters: [ReviewFilter]
    public var pagination: Pagination?
    public var sort: ReviewSort?
    public var order: Ordering?

    public init(filters: [ReviewFilter], pagination: Pagination? = nil, sort: ReviewSort? = nil, order: Ordering? = nil) {
      self.filters = filters
      self.pagination = pagination
      self.sort = sort
      self.order = order
    }

    public var variables: GraphQLMap? {
      return ["filters": filters, "pagination": pagination, "sort": sort, "order": order]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("reviews", arguments: ["filters": GraphQLVariable("filters"), "pagination": GraphQLVariable("pagination"), "sort": GraphQLVariable("sort"), "order": GraphQLVariable("order")], type: .nonNull(.object(Review.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(reviews: Review) {
        self.init(unsafeResultMap: ["__typename": "Query", "reviews": reviews.resultMap])
      }

      public var reviews: Review {
        get {
          return Review(unsafeResultMap: resultMap["reviews"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "reviews")
        }
      }

      public struct Review: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ReviewResult"]

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
          self.init(unsafeResultMap: ["__typename": "ReviewResult", "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
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
          public static let possibleTypes: [String] = ["Review"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("review", type: .scalar(String.self)),
              GraphQLField("reviewer", type: .object(Reviewer.selections)),
              GraphQLField("anonymous", type: .scalar(Bool.self)),
              GraphQLField("score", type: .scalar(Int.self)),
              GraphQLField("created", type: .scalar(Date.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, review: String? = nil, reviewer: Reviewer? = nil, anonymous: Bool? = nil, score: Int? = nil, created: Date? = nil) {
            self.init(unsafeResultMap: ["__typename": "Review", "id": id, "review": review, "reviewer": reviewer.flatMap { (value: Reviewer) -> ResultMap in value.resultMap }, "anonymous": anonymous, "score": score, "created": created])
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

          public var review: String? {
            get {
              return resultMap["review"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "review")
            }
          }

          public var reviewer: Reviewer? {
            get {
              return (resultMap["reviewer"] as? ResultMap).flatMap { Reviewer(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "reviewer")
            }
          }

          public var anonymous: Bool? {
            get {
              return resultMap["anonymous"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "anonymous")
            }
          }

          public var score: Int? {
            get {
              return resultMap["score"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "score")
            }
          }

          public var created: Date? {
            get {
              return resultMap["created"] as? Date
            }
            set {
              resultMap.updateValue(newValue, forKey: "created")
            }
          }

          public struct Reviewer: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Merchant"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String) {
              self.init(unsafeResultMap: ["__typename": "Merchant", "name": name])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
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
          }
        }
      }
    }
  }
}
