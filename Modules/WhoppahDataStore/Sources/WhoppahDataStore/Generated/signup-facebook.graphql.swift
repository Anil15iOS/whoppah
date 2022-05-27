// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class SignupWithFacebookMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation signupWithFacebook($platform: Platform!, $token: String!, $member: MemberInput!, $merchant: MerchantInput!) {
        signupWithFacebook(
          platform: $platform
          token: $token
          member: $member
          merchant: $merchant
        )
      }
      """

    public let operationName: String = "signupWithFacebook"

    public var platform: Platform
    public var token: String
    public var member: MemberInput
    public var merchant: MerchantInput

    public init(platform: Platform, token: String, member: MemberInput, merchant: MerchantInput) {
      self.platform = platform
      self.token = token
      self.member = member
      self.merchant = merchant
    }

    public var variables: GraphQLMap? {
      return ["platform": platform, "token": token, "member": member, "merchant": merchant]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("signupWithFacebook", arguments: ["platform": GraphQLVariable("platform"), "token": GraphQLVariable("token"), "member": GraphQLVariable("member"), "merchant": GraphQLVariable("merchant")], type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(signupWithFacebook: String) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "signupWithFacebook": signupWithFacebook])
      }

      public var signupWithFacebook: String {
        get {
          return resultMap["signupWithFacebook"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "signupWithFacebook")
        }
      }
    }
  }
}
