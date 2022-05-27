// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class UpdateMemberMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation updateMember($id: UUID!, $input: MemberInput!) {
        updateMember(id: $id, input: $input) {
          __typename
          id
          given_name
          family_name
          email
          date_joined
          dob
          locale
        }
      }
      """

    public let operationName: String = "updateMember"

    public var id: UUID
    public var input: MemberInput

    public init(id: UUID, input: MemberInput) {
      self.id = id
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["id": id, "input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("updateMember", arguments: ["id": GraphQLVariable("id"), "input": GraphQLVariable("input")], type: .nonNull(.object(UpdateMember.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(updateMember: UpdateMember) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "updateMember": updateMember.resultMap])
      }

      public var updateMember: UpdateMember {
        get {
          return UpdateMember(unsafeResultMap: resultMap["updateMember"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "updateMember")
        }
      }

      public struct UpdateMember: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Member"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("given_name", type: .nonNull(.scalar(String.self))),
            GraphQLField("family_name", type: .nonNull(.scalar(String.self))),
            GraphQLField("email", type: .nonNull(.scalar(String.self))),
            GraphQLField("date_joined", type: .nonNull(.scalar(DateTime.self))),
            GraphQLField("dob", type: .scalar(Date.self)),
            GraphQLField("locale", type: .nonNull(.scalar(Locale.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, givenName: String, familyName: String, email: String, dateJoined: DateTime, dob: Date? = nil, locale: Locale) {
          self.init(unsafeResultMap: ["__typename": "Member", "id": id, "given_name": givenName, "family_name": familyName, "email": email, "date_joined": dateJoined, "dob": dob, "locale": locale])
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

        public var givenName: String {
          get {
            return resultMap["given_name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "given_name")
          }
        }

        public var familyName: String {
          get {
            return resultMap["family_name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "family_name")
          }
        }

        public var email: String {
          get {
            return resultMap["email"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var dateJoined: DateTime {
          get {
            return resultMap["date_joined"]! as! DateTime
          }
          set {
            resultMap.updateValue(newValue, forKey: "date_joined")
          }
        }

        public var dob: Date? {
          get {
            return resultMap["dob"] as? Date
          }
          set {
            resultMap.updateValue(newValue, forKey: "dob")
          }
        }

        public var locale: Locale {
          get {
            return resultMap["locale"]! as! Locale
          }
          set {
            resultMap.updateValue(newValue, forKey: "locale")
          }
        }
      }
    }
  }
}
