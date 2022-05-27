// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetAttributeQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getAttribute($key: AttributeFilterKey, $value: String!) {
        attributeByKey(key: $key, value: $value) {
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
            description
            color
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

    public let operationName: String = "getAttribute"

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
          GraphQLField("attributeByKey", arguments: ["key": GraphQLVariable("key"), "value": GraphQLVariable("value")], type: .object(AttributeByKey.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(attributeByKey: AttributeByKey? = nil) {
        self.init(unsafeResultMap: ["__typename": "Query", "attributeByKey": attributeByKey.flatMap { (value: AttributeByKey) -> ResultMap in value.resultMap }])
      }

      public var attributeByKey: AttributeByKey? {
        get {
          return (resultMap["attributeByKey"] as? ResultMap).flatMap { AttributeByKey(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "attributeByKey")
        }
      }

      public struct AttributeByKey: GraphQLSelectionSet {
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

        public static func makeUsageSign() -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "UsageSign"])
        }

        public static func makeAdditionalInfo() -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "AdditionalInfo"])
        }

        public static func makeSubject() -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "Subject"])
        }

        public static func makeMaterial(id: UUID, slug: String, description: String? = nil) -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "Material", "id": id, "slug": slug, "description": description])
        }

        public static func makeArtist(id: UUID, title: String, slug: String, description: String? = nil) -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "Artist", "id": id, "title": title, "slug": slug, "description": description])
        }

        public static func makeBrand(id: UUID, title: String, slug: String, description: String? = nil) -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "Brand", "id": id, "title": title, "slug": slug, "description": description])
        }

        public static func makeColor(id: UUID, title: String, hex: String, slug: String, description: String? = nil) -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "Color", "id": id, "title": title, "hex": hex, "slug": slug, "description": description])
        }

        public static func makeDesigner(id: UUID, title: String, slug: String, description: String? = nil) -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "Designer", "id": id, "title": title, "slug": slug, "description": description])
        }

        public static func makeLabel(id: UUID, slug: String, description: String? = nil, color: String? = nil) -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "description": description, "color": color])
        }

        public static func makeStyle(id: UUID, slug: String, description: String? = nil) -> AttributeByKey {
          return AttributeByKey(unsafeResultMap: ["__typename": "Style", "id": id, "slug": slug, "description": description])
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
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("color", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, slug: String, description: String? = nil, color: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Label", "id": id, "slug": slug, "description": description, "color": color])
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

          @available(*, deprecated, message: "No longer supported")
          public var color: String? {
            get {
              return resultMap["color"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "color")
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
