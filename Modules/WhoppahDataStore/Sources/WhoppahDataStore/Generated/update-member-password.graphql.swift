// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class UpdateMemberPasswordMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation updateMemberPassword($input: UpdateMemberPassword!) {
        updateMemberPassword(input: $input) {
          __typename
          id
        }
      }
      """

    public let operationName: String = "updateMemberPassword"

    public var input: UpdateMemberPassword

    public init(input: UpdateMemberPassword) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("updateMemberPassword", arguments: ["input": GraphQLVariable("input")], type: .object(UpdateMemberPassword.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(updateMemberPassword: UpdateMemberPassword? = nil) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "updateMemberPassword": updateMemberPassword.flatMap { (value: UpdateMemberPassword) -> ResultMap in value.resultMap }])
      }

      public var updateMemberPassword: UpdateMemberPassword? {
        get {
          return (resultMap["updateMemberPassword"] as? ResultMap).flatMap { UpdateMemberPassword(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "updateMemberPassword")
        }
      }

      public struct UpdateMemberPassword: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Member"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID) {
          self.init(unsafeResultMap: ["__typename": "Member", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: UUID {
          get {
            return resultMap["id"]! as! UUID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}
