// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class ForgotPasswordMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation forgotPassword($input: ForgotPasswordInput!) {
        forgotPassword(input: $input) {
          __typename
          status
          message
        }
      }
      """

    public let operationName: String = "forgotPassword"

    public var input: ForgotPasswordInput

    public init(input: ForgotPasswordInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("forgotPassword", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(ForgotPassword.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(forgotPassword: ForgotPassword) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "forgotPassword": forgotPassword.resultMap])
      }

      public var forgotPassword: ForgotPassword {
        get {
          return ForgotPassword(unsafeResultMap: resultMap["forgotPassword"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "forgotPassword")
        }
      }

      public struct ForgotPassword: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ForgotPasswordResponse"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("status", type: .nonNull(.scalar(ForgotPasswordResult.self))),
            GraphQLField("message", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(status: ForgotPasswordResult, message: String) {
          self.init(unsafeResultMap: ["__typename": "ForgotPasswordResponse", "status": status, "message": message])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var status: ForgotPasswordResult {
          get {
            return resultMap["status"]! as! ForgotPasswordResult
          }
          set {
            resultMap.updateValue(newValue, forKey: "status")
          }
        }

        public var message: String {
          get {
            return resultMap["message"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "message")
          }
        }
      }
    }
  }
}
