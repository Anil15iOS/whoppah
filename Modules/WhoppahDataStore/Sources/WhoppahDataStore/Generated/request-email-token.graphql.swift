// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class RequestEmailTokenMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation requestEmailToken($email: String!, $redirectUrl: String!) {
        requestEmailToken(email: $email, redirectUrl: $redirectUrl)
      }
      """

    public let operationName: String = "requestEmailToken"

    public var email: String
    public var redirectUrl: String

    public init(email: String, redirectUrl: String) {
      self.email = email
      self.redirectUrl = redirectUrl
    }

    public var variables: GraphQLMap? {
      return ["email": email, "redirectUrl": redirectUrl]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("requestEmailToken", arguments: ["email": GraphQLVariable("email"), "redirectUrl": GraphQLVariable("redirectUrl")], type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(requestEmailToken: String) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "requestEmailToken": requestEmailToken])
      }

      public var requestEmailToken: String {
        get {
          return resultMap["requestEmailToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "requestEmailToken")
        }
      }
    }
  }
}
