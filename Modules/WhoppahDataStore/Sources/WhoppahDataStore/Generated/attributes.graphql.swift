// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetAttributesQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getAttributes($key: AttributeFilterKey, $value: String!) {
        attributesByKey(key: $key, value: $value) {
          __typename
          ... on Material {
            __typename
            id
            slug
            description
          }
          ... on Artist {
            __typename
            id
            title
            slug
            description
          }
          ... on Brand {
            __typename
            id
            title
            slug
            description
          }
          ... on Color {
            __typename
            id
            title
            hex
            slug
            description
          }
          ... on Designer {
            __typename
            id
            title
            slug
            description
          }
          ... on Label {
            __typename
            id
            slug
            color
            description
          }
          ... on Style {
            __typename
            id
            slug
            description
          }
        }
      }
      """

    public let operationName: String = "getAttributes"

    public var key: AttributeFilterKey?
    public var value: String

    public init(key: AttributeFilterKey? = nil, value: String) {
      self.key = key
      self.value = value
    }

    public var variables: GraphQLMap? {
      return ["key": key, "value": value]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("attributesByKey", arguments: ["key": GraphQLVariable("key"), "value": GraphQLVariable("value")], type: .nonNull(.list(.nonNull(.object(AttributesByKey.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(attributesByKey: [AttributesByKey]) {
        self.init(unsafeResultMap: ["__typename": "Query", "attributesByKey": attributesByKey.map { (value: AttributesByKey) -> ResultMap in value.resultMap }])
      }

      public var attributesByKey: [AttributesByKey] {
        get {
          return (resultMap["attributesByKey"] as! [ResultMap]).map { (value: ResultMap) -> AttributesByKey in AttributesByKey(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: AttributesByKey) -> ResultMap in value.resultMap }, forKey: "attributesByKey")
        }
      }

      public struct AttributesByKey: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Artist", "Brand", "Color", "Designer", "Label", "Material", "Style", "UsageSign", "AdditionalInfo", "Subject"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLTypeCase(
              variants: ["Material": AsMaterial.selections, "Artist": AsArtist.selections, "Brand": AsBrand.selections, "Color": AsColor.selections, "Designer": AsDesigner.selections, "Label": AsLabel.selections, "Style": AsStyle.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public static func makeUsageSign() -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "UsageSign"])
        }

        public static func makeAdditionalInfo() -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "AdditionalInfo"])
        }

        public static func makeSubject() -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "Subject"])
        }

        public static func makeMaterial(id: UUID, slug: String, description: String? = nil) -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
        }

        public static func makeArtist(id: UUID, title: String, slug: String, description: String? = nil) -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
        }

        public static func makeBrand(id: UUID, title: String, slug: String, description: String? = nil) -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
        }

        public static func makeColor(id: UUID, title: String, hex: String, slug: String, description: String? = nil) -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
        }

        public static func makeDesigner(id: UUID, title: String, slug: String, description: String? = nil) -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
        }

        public static func makeLabel(id: UUID, slug: String, color: String? = nil, description: String? = nil) -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
        }

        public static func makeStyle(id: UUID, slug: String, description: String? = nil) -> AttributesByKey {
          return AttributesByKey(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var asMaterial: AsMaterial? {
          get {
            if !AsMaterial.possibleTypes.contains(__typename) { return nil }
            return AsMaterial(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsMaterial: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Material"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, slug: String, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
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

          public var slug: String {
            get {
              return resultMap["slug"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "slug")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }

        public var asArtist: AsArtist? {
          get {
            if !AsArtist.possibleTypes.contains(__typename) { return nil }
            return AsArtist(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsArtist: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Artist"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, title: String, slug: String, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
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

          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          public var slug: String {
            get {
              return resultMap["slug"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "slug")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }

        public var asBrand: AsBrand? {
          get {
            if !AsBrand.possibleTypes.contains(__typename) { return nil }
            return AsBrand(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsBrand: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Brand"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, title: String, slug: String, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
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

          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          public var slug: String {
            get {
              return resultMap["slug"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "slug")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }

        public var asColor: AsColor? {
          get {
            if !AsColor.possibleTypes.contains(__typename) { return nil }
            return AsColor(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsColor: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Color"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("hex", type: .nonNull(.scalar(String.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, title: String, hex: String, slug: String, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
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

          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          public var hex: String {
            get {
              return resultMap["hex"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "hex")
            }
          }

          public var slug: String {
            get {
              return resultMap["slug"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "slug")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }

        public var asDesigner: AsDesigner? {
          get {
            if !AsDesigner.possibleTypes.contains(__typename) { return nil }
            return AsDesigner(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsDesigner: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Designer"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, title: String, slug: String, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
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

          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          public var slug: String {
            get {
              return resultMap["slug"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "slug")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }

        public var asLabel: AsLabel? {
          get {
            if !AsLabel.possibleTypes.contains(__typename) { return nil }
            return AsLabel(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsLabel: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Label"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("color", type: .scalar(String.self)),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, slug: String, color: String? = nil, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "color": color, "description": description])
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

          public var slug: String {
            get {
              return resultMap["slug"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "slug")
            }
          }

          @available(*, deprecated, message: "No longer supported")
          public var color: String? {
            get {
              return resultMap["color"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "color")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }

        public var asStyle: AsStyle? {
          get {
            if !AsStyle.possibleTypes.contains(__typename) { return nil }
            return AsStyle(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsStyle: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Style"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("slug", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, slug: String, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
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

          public var slug: String {
            get {
              return resultMap["slug"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "slug")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }
      }
    }
  }
}
