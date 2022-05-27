// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class LoginWithEmailPasswordMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation loginWithEmailPassword($email: String!, $password: String!) {
        loginWithEmailPassword(email: $email, password: $password)
      }
      """

    public let operationName: String = "loginWithEmailPassword"

    public var email: String
    public var password: String

    public init(email: String, password: String) {
      self.email = email
      self.password = password
    }

    public var variables: GraphQLMap? {
      return ["email": email, "password": password]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("loginWithEmailPassword", arguments: ["email": GraphQLVariable("email"), "password": GraphQLVariable("password")], type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(loginWithEmailPassword: String) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "loginWithEmailPassword": loginWithEmailPassword])
      }

      public var loginWithEmailPassword: String {
        get {
          return resultMap["loginWithEmailPassword"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "loginWithEmailPassword")
        }
      }
    }
  }
}
