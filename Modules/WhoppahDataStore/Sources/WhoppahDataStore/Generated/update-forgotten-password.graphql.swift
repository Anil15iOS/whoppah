// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class UpdateForgottenPasswordMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation updateForgottenPassword($input: UpdateForgottenPasswordInput!) {
        updateForgottenPassword(input: $input) {
          __typename
          status
          message
        }
      }
      """

    public let operationName: String = "updateForgottenPassword"

    public var input: UpdateForgottenPasswordInput

    public init(input: UpdateForgottenPasswordInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("updateForgottenPassword", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(UpdateForgottenPassword.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(updateForgottenPassword: UpdateForgottenPassword) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "updateForgottenPassword": updateForgottenPassword.resultMap])
      }

      public var updateForgottenPassword: UpdateForgottenPassword {
        get {
          return UpdateForgottenPassword(unsafeResultMap: resultMap["updateForgottenPassword"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "updateForgottenPassword")
        }
      }

      public struct UpdateForgottenPassword: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["UpdateForgottenPasswordResponse"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("status", type: .nonNull(.scalar(UpdateForgottenPasswordResult.self))),
            GraphQLField("message", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(status: UpdateForgottenPasswordResult, message: String) {
          self.init(unsafeResultMap: ["__typename": "UpdateForgottenPasswordResponse", "status": status, "message": message])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var status: UpdateForgottenPasswordResult {
          get {
            return resultMap["status"]! as! UpdateForgottenPasswordResult
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
