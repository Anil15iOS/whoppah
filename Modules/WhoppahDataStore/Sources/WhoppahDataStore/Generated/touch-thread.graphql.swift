// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class TouchThreadMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation touchThread($id: UUID!, $pagination: Pagination!) {
        touch(id: $id) {
          __typename
          messages(pagination: $pagination) {
            __typename
            id
            unread
          }
        }
      }
      """

    public let operationName: String = "touchThread"

    public var id: UUID
    public var pagination: Pagination

    public init(id: UUID, pagination: Pagination) {
      self.id = id
      self.pagination = pagination
    }

    public var variables: GraphQLMap? {
      return ["id": id, "pagination": pagination]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("touch", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.object(Touch.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(touch: Touch) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "touch": touch.resultMap])
      }

      public var touch: Touch {
        get {
          return Touch(unsafeResultMap: resultMap["touch"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "touch")
        }
      }

      public struct Touch: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Thread"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("messages", arguments: ["pagination": GraphQLVariable("pagination")], type: .nonNull(.list(.nonNull(.object(Message.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(messages: [Message]) {
          self.init(unsafeResultMap: ["__typename": "Thread", "messages": messages.map { (value: Message) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
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

        public struct Message: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Message"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("unread", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, unread: Bool) {
            self.init(unsafeResultMap: ["__typename": "Message", "id": id, "unread": unread])
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

          public var unread: Bool {
            get {
              return resultMap["unread"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "unread")
            }
          }
        }
      }
    }
  }
}
