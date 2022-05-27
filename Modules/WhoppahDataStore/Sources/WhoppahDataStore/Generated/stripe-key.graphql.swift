// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetStripeEphemeralKeyQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getStripeEphemeralKey($version: String!) {
        getStripeEphemeralKey(version: $version)
      }
      """

    public let operationName: String = "getStripeEphemeralKey"

    public var version: String

    public init(version: String) {
      self.version = version
    }

    public var variables: GraphQLMap? {
      return ["version": version]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("getStripeEphemeralKey", arguments: ["version": GraphQLVariable("version")], type: .nonNull(.scalar(JSON.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(getStripeEphemeralKey: JSON) {
        self.init(unsafeResultMap: ["__typename": "Query", "getStripeEphemeralKey": getStripeEphemeralKey])
      }

      public var getStripeEphemeralKey: JSON {
        get {
          return resultMap["getStripeEphemeralKey"]! as! JSON
        }
        set {
          resultMap.updateValue(newValue, forKey: "getStripeEphemeralKey")
        }
      }
    }
  }
}
