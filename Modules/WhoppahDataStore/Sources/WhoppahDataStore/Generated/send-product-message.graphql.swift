// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class AskProductQuestionMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation askProductQuestion($id: UUID!, $body: String!) {
        askProductQuestion(id: $id, body: $body) {
          __typename
          id
        }
      }
      """

    public let operationName: String = "askProductQuestion"

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
          GraphQLField("askProductQuestion", arguments: ["id": GraphQLVariable("id"), "body": GraphQLVariable("body")], type: .nonNull(.object(AskProductQuestion.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(askProductQuestion: AskProductQuestion) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "askProductQuestion": askProductQuestion.resultMap])
      }

      public var askProductQuestion: AskProductQuestion {
        get {
          return AskProductQuestion(unsafeResultMap: resultMap["askProductQuestion"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "askProductQuestion")
        }
      }

      public struct AskProductQuestion: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Thread"]

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
          self.init(unsafeResultMap: ["__typename": "Thread", "id": id])
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
