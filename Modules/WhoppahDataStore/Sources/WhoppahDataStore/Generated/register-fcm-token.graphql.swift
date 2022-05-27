// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class RegisterFcmTokenMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation registerFCMToken($token: String!, $name: String!) {
        registerFCMToken(token: $token, name: $name)
      }
      """

    public let operationName: String = "registerFCMToken"

    public var token: String
    public var name: String

    public init(token: String, name: String) {
      self.token = token
      self.name = name
    }

    public var variables: GraphQLMap? {
      return ["token": token, "name": name]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("registerFCMToken", arguments: ["token": GraphQLVariable("token"), "name": GraphQLVariable("name")], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(registerFcmToken: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "registerFCMToken": registerFcmToken])
      }

      public var registerFcmToken: Bool {
        get {
          return resultMap["registerFCMToken"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "registerFCMToken")
        }
      }
    }
  }
}
