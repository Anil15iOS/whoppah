// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CheckEmailExistsMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation checkEmailExists($email: String!) {
        checkEmailExists(email: $email) {
          __typename
          status
        }
      }
      """

    public let operationName: String = "checkEmailExists"

    public var email: String

    public init(email: String) {
      self.email = email
    }

    public var variables: GraphQLMap? {
      return ["email": email]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("checkEmailExists", arguments: ["email": GraphQLVariable("email")], type: .nonNull(.object(CheckEmailExist.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(checkEmailExists: CheckEmailExist) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "checkEmailExists": checkEmailExists.resultMap])
      }

      public var checkEmailExists: CheckEmailExist {
        get {
          return CheckEmailExist(unsafeResultMap: resultMap["checkEmailExists"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "checkEmailExists")
        }
      }

      public struct CheckEmailExist: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["CheckEmailExistsResponse"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("status", type: .scalar(CheckEmailExistsStatus.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(status: CheckEmailExistsStatus? = nil) {
          self.init(unsafeResultMap: ["__typename": "CheckEmailExistsResponse", "status": status])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var status: CheckEmailExistsStatus? {
          get {
            return resultMap["status"] as? CheckEmailExistsStatus
          }
          set {
            resultMap.updateValue(newValue, forKey: "status")
          }
        }
      }
    }
  }
}
