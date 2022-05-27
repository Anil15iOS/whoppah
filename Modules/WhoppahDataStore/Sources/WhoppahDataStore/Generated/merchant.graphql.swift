// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetMerchantQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getMerchant($id: UUID!) {
        merchant(id: $id) {
          __typename
          ...MerchantFragment
          ...MerchantIdentity
          ...MerchantProfile
          currency
          avatar: image(type: AVATAR) {
            __typename
            ...MerchantAvatar
          }
          cover: image(type: COVER) {
            __typename
            ...MerchantCover
          }
          addresses {
            __typename
            ...MerchantAddressFragment
          }
        }
      }
      """

    public let operationName: String = "getMerchant"

    public var queryDocument: String {
      var document: String = operationDefinition
      document.append("\n" + MerchantFragment.fragmentDefinition)
      document.append("\n" + MerchantIdentity.fragmentDefinition)
      document.append("\n" + MerchantProfile.fragmentDefinition)
      document.append("\n" + MerchantAvatar.fragmentDefinition)
      document.append("\n" + MerchantCover.fragmentDefinition)
      document.append("\n" + MerchantAddressFragment.fragmentDefinition)
      return document
    }

    public var id: UUID

    public init(id: UUID) {
      self.id = id
    }

    public var variables: GraphQLMap? {
      return ["id": id]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("merchant", arguments: ["id": GraphQLVariable("id")], type: .object(Merchant.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(merchant: Merchant? = nil) {
        self.init(unsafeResultMap: ["__typename": "Query", "merchant": merchant.flatMap { (value: Merchant) -> ResultMap in value.resultMap }])
      }

      public var merchant: Merchant? {
        get {
          return (resultMap["merchant"] as? ResultMap).flatMap { Merchant(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "merchant")
        }
      }

      public struct Merchant: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Merchant"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
            GraphQLField("url", type: .scalar(String.self)),
            GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
            GraphQLField("compliance_level", type: .scalar(Int.self)),
            GraphQLField("expert_seller", type: .scalar(Bool.self)),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("business_name", type: .scalar(String.self)),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("biography", type: .scalar(String.self)),
            GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
            GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
            GraphQLField("image", alias: "cover", arguments: ["type": "COVER"], type: .object(Cover.selections)),
            GraphQLField("addresses", type: .nonNull(.list(.nonNull(.object(Address.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, name: String, created: DateTime, url: String? = nil, type: MerchantType, complianceLevel: Int? = nil, expertSeller: Bool? = nil, businessName: String? = nil, biography: String? = nil, currency: Currency, avatar: Avatar? = nil, cover: Cover? = nil, addresses: [Address]) {
          self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "created": created, "url": url, "type": type, "compliance_level": complianceLevel, "expert_seller": expertSeller, "business_name": businessName, "biography": biography, "currency": currency, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }, "cover": cover.flatMap { (value: Cover) -> ResultMap in value.resultMap }, "addresses": addresses.map { (value: Address) -> ResultMap in value.resultMap }])
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

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var created: DateTime {
          get {
            return resultMap["created"]! as! DateTime
          }
          set {
            resultMap.updateValue(newValue, forKey: "created")
          }
        }

        public var url: String? {
          get {
            return resultMap["url"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "url")
          }
        }

        public var type: MerchantType {
          get {
            return resultMap["type"]! as! MerchantType
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var complianceLevel: Int? {
          get {
            return resultMap["compliance_level"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "compliance_level")
          }
        }

        public var expertSeller: Bool? {
          get {
            return resultMap["expert_seller"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "expert_seller")
          }
        }

        public var businessName: String? {
          get {
            return resultMap["business_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "business_name")
          }
        }

        public var biography: String? {
          get {
            return resultMap["biography"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "biography")
          }
        }

        public var currency: Currency {
          get {
            return resultMap["currency"]! as! Currency
          }
          set {
            resultMap.updateValue(newValue, forKey: "currency")
          }
        }

        public var avatar: Avatar? {
          get {
            return (resultMap["avatar"] as? ResultMap).flatMap { Avatar(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "avatar")
          }
        }

        public var cover: Cover? {
          get {
            return (resultMap["cover"] as? ResultMap).flatMap { Cover(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "cover")
          }
        }

        public var addresses: [Address] {
          get {
            return (resultMap["addresses"] as! [ResultMap]).map { (value: ResultMap) -> Address in Address(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Address) -> ResultMap in value.resultMap }, forKey: "addresses")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var merchantFragment: MerchantFragment {
            get {
              return MerchantFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public var merchantIdentity: MerchantIdentity {
            get {
              return MerchantIdentity(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public var merchantProfile: MerchantProfile {
            get {
              return MerchantProfile(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }

        public struct Avatar: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var merchantAvatar: MerchantAvatar {
              get {
                return MerchantAvatar(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }

        public struct Cover: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("url", arguments: ["size": "LG"], type: .nonNull(.scalar(String.self))),
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

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var merchantCover: MerchantCover {
              get {
                return MerchantCover(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }

        public struct Address: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Address"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("city", type: .nonNull(.scalar(String.self))),
              GraphQLField("country", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, city: String, country: String) {
            self.init(unsafeResultMap: ["__typename": "Address", "id": id, "city": city, "country": country])
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

          public var city: String {
            get {
              return resultMap["city"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "city")
            }
          }

          public var country: String {
            get {
              return resultMap["country"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "country")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var merchantAddressFragment: MerchantAddressFragment {
              get {
                return MerchantAddressFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }
  }

  struct MerchantAvatar: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment MerchantAvatar on Image {
        __typename
        id
        url(size: MD)
      }
      """

    public static let possibleTypes: [String] = ["Image"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
        GraphQLField("url", arguments: ["size": "MD"], type: .nonNull(.scalar(String.self))),
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

  struct MerchantCover: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment MerchantCover on Image {
        __typename
        id
        url(size: LG)
      }
      """

    public static let possibleTypes: [String] = ["Image"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
        GraphQLField("url", arguments: ["size": "LG"], type: .nonNull(.scalar(String.self))),
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

  struct MerchantAddressFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment MerchantAddressFragment on Address {
        __typename
        id
        city
        country
      }
      """

    public static let possibleTypes: [String] = ["Address"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
        GraphQLField("city", type: .nonNull(.scalar(String.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: UUID, city: String, country: String) {
      self.init(unsafeResultMap: ["__typename": "Address", "id": id, "city": city, "country": country])
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

    public var city: String {
      get {
        return resultMap["city"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "city")
      }
    }

    public var country: String {
      get {
        return resultMap["country"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "country")
      }
    }
  }

  struct MerchantFragment: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment MerchantFragment on Merchant {
        __typename
        id
        name
        created
        url
        type
        compliance_level
        expert_seller
      }
      """

    public static let possibleTypes: [String] = ["Merchant"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
        GraphQLField("url", type: .scalar(String.self)),
        GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
        GraphQLField("compliance_level", type: .scalar(Int.self)),
        GraphQLField("expert_seller", type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: UUID, name: String, created: DateTime, url: String? = nil, type: MerchantType, complianceLevel: Int? = nil, expertSeller: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "created": created, "url": url, "type": type, "compliance_level": complianceLevel, "expert_seller": expertSeller])
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

    public var name: String {
      get {
        return resultMap["name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "name")
      }
    }

    public var created: DateTime {
      get {
        return resultMap["created"]! as! DateTime
      }
      set {
        resultMap.updateValue(newValue, forKey: "created")
      }
    }

    public var url: String? {
      get {
        return resultMap["url"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "url")
      }
    }

    public var type: MerchantType {
      get {
        return resultMap["type"]! as! MerchantType
      }
      set {
        resultMap.updateValue(newValue, forKey: "type")
      }
    }

    public var complianceLevel: Int? {
      get {
        return resultMap["compliance_level"] as? Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "compliance_level")
      }
    }

    public var expertSeller: Bool? {
      get {
        return resultMap["expert_seller"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "expert_seller")
      }
    }
  }

  struct MerchantIdentity: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment MerchantIdentity on Merchant {
        __typename
        business_name
      }
      """

    public static let possibleTypes: [String] = ["Merchant"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("business_name", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(businessName: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Merchant", "business_name": businessName])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var businessName: String? {
      get {
        return resultMap["business_name"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "business_name")
      }
    }
  }

  struct MerchantProfile: GraphQLFragment {
    /// The raw GraphQL definition of this fragment.
    public static let fragmentDefinition: String =
      """
      fragment MerchantProfile on Merchant {
        __typename
        biography
      }
      """

    public static let possibleTypes: [String] = ["Merchant"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("biography", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(biography: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Merchant", "biography": biography])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var biography: String? {
      get {
        return resultMap["biography"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "biography")
      }
    }
  }
}
