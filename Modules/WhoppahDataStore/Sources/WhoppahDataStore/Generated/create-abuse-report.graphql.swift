// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CreateAbuseReportMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation createAbuseReport($input: AbuseReportInput!) {
        createAbuseReport(input: $input)
      }
      """

    public let operationName: String = "createAbuseReport"

    public var input: AbuseReportInput

    public init(input: AbuseReportInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createAbuseReport", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createAbuseReport: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "createAbuseReport": createAbuseReport])
      }

      public var createAbuseReport: Bool {
        get {
          return resultMap["createAbuseReport"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "createAbuseReport")
        }
      }
    }
  }
}
