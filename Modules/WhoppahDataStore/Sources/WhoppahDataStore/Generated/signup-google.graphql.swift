// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class SignupWithGoogleMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation signupWithGoogle($platform: Platform!, $token: String!, $member: MemberInput!, $merchant: MerchantInput!) {
        signupWithGoogle(
          platform: $platform
          token: $token
          member: $member
          merchant: $merchant
        )
      }
      """

    public let operationName: String = "signupWithGoogle"

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
          GraphQLField("signupWithGoogle", arguments: ["platform": GraphQLVariable("platform"), "token": GraphQLVariable("token"), "member": GraphQLVariable("member"), "merchant": GraphQLVariable("merchant")], type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(signupWithGoogle: String) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "signupWithGoogle": signupWithGoogle])
      }

      public var signupWithGoogle: String {
        get {
          return resultMap["signupWithGoogle"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "signupWithGoogle")
        }
      }
    }
  }
}
