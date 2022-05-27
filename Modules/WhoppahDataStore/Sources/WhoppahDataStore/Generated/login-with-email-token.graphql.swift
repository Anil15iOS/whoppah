// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class LoginWithEmailTokenMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation loginWithEmailToken($email: String!, $token: String!, $cookie: String!) {
        loginWithEmailToken(email: $email, token: $token, cookie: $cookie) {
          __typename
          token
          redirectUrl
        }
      }
      """

    public let operationName: String = "loginWithEmailToken"

    public var email: String
    public var token: String
    public var cookie: String

    public init(email: String, token: String, cookie: String) {
      self.email = email
      self.token = token
      self.cookie = cookie
    }

    public var variables: GraphQLMap? {
      return ["email": email, "token": token, "cookie": cookie]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("loginWithEmailToken", arguments: ["email": GraphQLVariable("email"), "token": GraphQLVariable("token"), "cookie": GraphQLVariable("cookie")], type: .nonNull(.object(LoginWithEmailToken.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(loginWithEmailToken: LoginWithEmailToken) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "loginWithEmailToken": loginWithEmailToken.resultMap])
      }

      public var loginWithEmailToken: LoginWithEmailToken {
        get {
          return LoginWithEmailToken(unsafeResultMap: resultMap["loginWithEmailToken"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "loginWithEmailToken")
        }
      }

      public struct LoginWithEmailToken: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EmailTokenLoginResponse"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("token", type: .nonNull(.scalar(String.self))),
            GraphQLField("redirectUrl", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(token: String, redirectUrl: String) {
          self.init(unsafeResultMap: ["__typename": "EmailTokenLoginResponse", "token": token, "redirectUrl": redirectUrl])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var token: String {
          get {
            return resultMap["token"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "token")
          }
        }

        public var redirectUrl: String {
          get {
            return resultMap["redirectUrl"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "redirectUrl")
          }
        }
      }
    }
  }
}
