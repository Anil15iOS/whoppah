// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class LoginWithGoogleMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation loginWithGoogle($platform: Platform!, $token: String!) {
        loginWithGoogle(platform: $platform, token: $token)
      }
      """

    public let operationName: String = "loginWithGoogle"

    public var platform: Platform
    public var token: String

    public init(platform: Platform, token: String) {
      self.platform = platform
      self.token = token
    }

    public var variables: GraphQLMap? {
      return ["platform": platform, "token": token]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("loginWithGoogle", arguments: ["platform": GraphQLVariable("platform"), "token": GraphQLVariable("token")], type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(loginWithGoogle: String) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "loginWithGoogle": loginWithGoogle])
      }

      public var loginWithGoogle: String {
        get {
          return resultMap["loginWithGoogle"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "loginWithGoogle")
        }
      }
    }
  }
}
