// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class SendAppFeedbackMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation sendAppFeedback($body: String!) {
        sendPlatformFeedback(body: $body)
      }
      """

    public let operationName: String = "sendAppFeedback"

    public var body: String

    public init(body: String) {
      self.body = body
    }

    public var variables: GraphQLMap? {
      return ["body": body]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("sendPlatformFeedback", arguments: ["body": GraphQLVariable("body")], type: .scalar(Bool.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sendPlatformFeedback: Bool? = nil) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "sendPlatformFeedback": sendPlatformFeedback])
      }

      public var sendPlatformFeedback: Bool? {
        get {
          return resultMap["sendPlatformFeedback"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "sendPlatformFeedback")
        }
      }
    }
  }
}
