// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class SendMessageMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation sendMessage($id: UUID!, $body: String!) {
        sendMessage(id: $id, body: $body) {
          __typename
          id
          created
          updated
          sender {
            __typename
            id
            given_name
            family_name
          }
          merchant {
            __typename
            id
            name
          }
          subscriber {
            __typename
            id
            role
          }
          body
          unread
        }
      }
      """

    public let operationName: String = "sendMessage"

    public var id: UUID
    public var body: String

    public init(id: UUID, body: String) {
      self.id = id
      self.body = body
    }

    public var variables: GraphQLMap? {
      return ["id": id, "body": body]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("sendMessage", arguments: ["id": GraphQLVariable("id"), "body": GraphQLVariable("body")], type: .nonNull(.object(SendMessage.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sendMessage: SendMessage) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "sendMessage": sendMessage.resultMap])
      }

      public var sendMessage: SendMessage {
        get {
          return SendMessage(unsafeResultMap: resultMap["sendMessage"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "sendMessage")
        }
      }

      public struct SendMessage: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Message"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
            GraphQLField("updated", type: .scalar(DateTime.self)),
            GraphQLField("sender", type: .nonNull(.object(Sender.selections))),
            GraphQLField("merchant", type: .nonNull(.object(Merchant.selections))),
            GraphQLField("subscriber", type: .object(Subscriber.selections)),
            GraphQLField("body", type: .scalar(String.self)),
            GraphQLField("unread", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, created: DateTime, updated: DateTime? = nil, sender: Sender, merchant: Merchant, subscriber: Subscriber? = nil, body: String? = nil, unread: Bool) {
          self.init(unsafeResultMap: ["__typename": "Message", "id": id, "created": created, "updated": updated, "sender": sender.resultMap, "merchant": merchant.resultMap, "subscriber": subscriber.flatMap { (value: Subscriber) -> ResultMap in value.resultMap }, "body": body, "unread": unread])
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

        public var body: String? {
          get {
            return resultMap["body"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "body")
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
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, name: String) {
            self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name])
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
      }
    }
  }
}
