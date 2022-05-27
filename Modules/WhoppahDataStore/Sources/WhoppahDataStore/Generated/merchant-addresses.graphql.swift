// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetMerchantAddressesQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getMerchantAddresses($id: UUID!) {
        merchant(id: $id) {
          __typename
          id
          addresses {
            __typename
            title
            id
            line1
            line2
            postal_code
            city
            state
            country
            location {
              __typename
              latitude
              longitude
            }
          }
        }
      }
      """

    public let operationName: String = "getMerchantAddresses"

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
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("addresses", type: .nonNull(.list(.nonNull(.object(Address.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, addresses: [Address]) {
          self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "addresses": addresses.map { (value: Address) -> ResultMap in value.resultMap }])
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

        public var addresses: [Address] {
          get {
            return (resultMap["addresses"] as! [ResultMap]).map { (value: ResultMap) -> Address in Address(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Address) -> ResultMap in value.resultMap }, forKey: "addresses")
          }
        }

        public struct Address: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Address"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("title", type: .scalar(String.self)),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("line1", type: .nonNull(.scalar(String.self))),
              GraphQLField("line2", type: .scalar(String.self)),
              GraphQLField("postal_code", type: .nonNull(.scalar(String.self))),
              GraphQLField("city", type: .nonNull(.scalar(String.self))),
              GraphQLField("state", type: .scalar(String.self)),
              GraphQLField("country", type: .nonNull(.scalar(String.self))),
              GraphQLField("location", type: .object(Location.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(title: String? = nil, id: UUID, line1: String, line2: String? = nil, postalCode: String, city: String, state: String? = nil, country: String, location: Location? = nil) {
            self.init(unsafeResultMap: ["__typename": "Address", "title": title, "id": id, "line1": line1, "line2": line2, "postal_code": postalCode, "city": city, "state": state, "country": country, "location": location.flatMap { (value: Location) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var title: String? {
            get {
              return resultMap["title"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
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

          public var line1: String {
            get {
              return resultMap["line1"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "line1")
            }
          }

          public var line2: String? {
            get {
              return resultMap["line2"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "line2")
            }
          }

          public var postalCode: String {
            get {
              return resultMap["postal_code"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "postal_code")
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

          public var state: String? {
            get {
              return resultMap["state"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
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

          public var location: Location? {
            get {
              return (resultMap["location"] as? ResultMap).flatMap { Location(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "location")
            }
          }

          public struct Location: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Location"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
                GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(latitude: Double, longitude: Double) {
              self.init(unsafeResultMap: ["__typename": "Location", "latitude": latitude, "longitude": longitude])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var latitude: Double {
              get {
                return resultMap["latitude"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "latitude")
              }
            }

            public var longitude: Double {
              get {
                return resultMap["longitude"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "longitude")
              }
            }
          }
        }
      }
    }
  }
}
