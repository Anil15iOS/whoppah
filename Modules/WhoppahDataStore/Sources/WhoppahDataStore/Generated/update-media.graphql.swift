// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class UpdateMediaMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation updateMedia($id: UUID!, $input: MediaUpdateInput!) {
        updateMedia(id: $id, input: $input) {
          __typename
          ... on Image {
            __typename
            id
            url
          }
          ... on Video {
            __typename
            id
            url
          }
          ... on ARObject {
            __typename
            id
            url
            detection
            allows_pan
            allows_rotation
            type
          }
        }
      }
      """

    public let operationName: String = "updateMedia"

    public var id: UUID
    public var input: MediaUpdateInput

    public init(id: UUID, input: MediaUpdateInput) {
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
          GraphQLField("updateMedia", arguments: ["id": GraphQLVariable("id"), "input": GraphQLVariable("input")], type: .nonNull(.object(UpdateMedium.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(updateMedia: UpdateMedium) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "updateMedia": updateMedia.resultMap])
      }

      public var updateMedia: UpdateMedium {
        get {
          return UpdateMedium(unsafeResultMap: resultMap["updateMedia"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "updateMedia")
        }
      }

      public struct UpdateMedium: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Audio", "Document", "Image", "ARObject", "Video"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLTypeCase(
              variants: ["Image": AsImage.selections, "Video": AsVideo.selections, "ARObject": AsArObject.selections],
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

        public static func makeAudio() -> UpdateMedium {
          return UpdateMedium(unsafeResultMap: ["__typename": "Audio"])
        }

        public static func makeDocument() -> UpdateMedium {
          return UpdateMedium(unsafeResultMap: ["__typename": "Document"])
        }

        public static func makeImage(id: UUID, url: String) -> UpdateMedium {
          return UpdateMedium(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
        }

        public static func makeVideo(id: UUID, url: String) -> UpdateMedium {
          return UpdateMedium(unsafeResultMap: ["__typename": "Video", "id": id, "url": url])
        }

        public static func makeARObject(id: UUID, url: String, detection: ARDetection? = nil, allowsPan: Bool? = nil, allowsRotation: Bool? = nil, type: ARObjectType? = nil) -> UpdateMedium {
          return UpdateMedium(unsafeResultMap: ["__typename": "ARObject", "id": id, "url": url, "detection": detection, "allows_pan": allowsPan, "allows_rotation": allowsRotation, "type": type])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var asImage: AsImage? {
          get {
            if !AsImage.possibleTypes.contains(__typename) { return nil }
            return AsImage(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsImage: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, url: String) {
            self.init(unsafeResultMap: ["__typename": "Image", "id": id, "url": url])
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

          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }
        }

        public var asVideo: AsVideo? {
          get {
            if !AsVideo.possibleTypes.contains(__typename) { return nil }
            return AsVideo(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsVideo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Video"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, url: String) {
            self.init(unsafeResultMap: ["__typename": "Video", "id": id, "url": url])
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

          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }
        }

        public var asArObject: AsArObject? {
          get {
            if !AsArObject.possibleTypes.contains(__typename) { return nil }
            return AsArObject(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsArObject: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ARObject"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
              GraphQLField("detection", type: .scalar(ARDetection.self)),
              GraphQLField("allows_pan", type: .scalar(Bool.self)),
              GraphQLField("allows_rotation", type: .scalar(Bool.self)),
              GraphQLField("type", type: .scalar(ARObjectType.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, url: String, detection: ARDetection? = nil, allowsPan: Bool? = nil, allowsRotation: Bool? = nil, type: ARObjectType? = nil) {
            self.init(unsafeResultMap: ["__typename": "ARObject", "id": id, "url": url, "detection": detection, "allows_pan": allowsPan, "allows_rotation": allowsRotation, "type": type])
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

          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          @available(*, deprecated, message: "Not required")
          public var detection: ARDetection? {
            get {
              return resultMap["detection"] as? ARDetection
            }
            set {
              resultMap.updateValue(newValue, forKey: "detection")
            }
          }

          @available(*, deprecated, message: "Not required")
          public var allowsPan: Bool? {
            get {
              return resultMap["allows_pan"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "allows_pan")
            }
          }

          @available(*, deprecated, message: "Not required")
          public var allowsRotation: Bool? {
            get {
              return resultMap["allows_rotation"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "allows_rotation")
            }
          }

          @available(*, deprecated, message: "Not required")
          public var type: ARObjectType? {
            get {
              return resultMap["type"] as? ARObjectType
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }
        }
      }
    }
  }
}
