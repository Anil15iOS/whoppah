// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class TranslateQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query translate($strings: [String!]!, $lang: Lang!) {
        translate(strings: $strings, lang: $lang) {
          __typename
          translatedText
          detectedSourceLanguage
        }
      }
      """

    public let operationName: String = "translate"

    public var strings: [String]
    public var lang: Lang

    public init(strings: [String], lang: Lang) {
      self.strings = strings
      self.lang = lang
    }

    public var variables: GraphQLMap? {
      return ["strings": strings, "lang": lang]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("translate", arguments: ["strings": GraphQLVariable("strings"), "lang": GraphQLVariable("lang")], type: .nonNull(.list(.nonNull(.object(Translate.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(translate: [Translate]) {
        self.init(unsafeResultMap: ["__typename": "Query", "translate": translate.map { (value: Translate) -> ResultMap in value.resultMap }])
      }

      public var translate: [Translate] {
        get {
          return (resultMap["translate"] as! [ResultMap]).map { (value: ResultMap) -> Translate in Translate(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Translate) -> ResultMap in value.resultMap }, forKey: "translate")
        }
      }

      public struct Translate: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TranslationResult"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("translatedText", type: .nonNull(.scalar(String.self))),
            GraphQLField("detectedSourceLanguage", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(translatedText: String, detectedSourceLanguage: String) {
          self.init(unsafeResultMap: ["__typename": "TranslationResult", "translatedText": translatedText, "detectedSourceLanguage": detectedSourceLanguage])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var translatedText: String {
          get {
            return resultMap["translatedText"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "translatedText")
          }
        }

        public var detectedSourceLanguage: String {
          get {
            return resultMap["detectedSourceLanguage"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "detectedSourceLanguage")
          }
        }
      }
    }
  }
}
