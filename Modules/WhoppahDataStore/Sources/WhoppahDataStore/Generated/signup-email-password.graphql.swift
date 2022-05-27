// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class SignupWithEmailPasswordMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation signupWithEmailPassword($input: SignupWithEmailPasswordInput!) {
        signupWithEmailPassword(input: $input)
      }
      """

    public let operationName: String = "signupWithEmailPassword"

    public var input: SignupWithEmailPasswordInput

    public init(input: SignupWithEmailPasswordInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("signupWithEmailPassword", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(signupWithEmailPassword: String) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "signupWithEmailPassword": signupWithEmailPassword])
      }

      public var signupWithEmailPassword: String {
        get {
          return resultMap["signupWithEmailPassword"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "signupWithEmailPassword")
        }
      }
    }
  }
}
