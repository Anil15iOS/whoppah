// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class UpdateAddressMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation updateAddress($id: UUID!, $input: AddressInput!) {
        updateAddress(id: $id, input: $input) {
          __typename
          id
          title
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
      """

    public let operationName: String = "updateAddress"

    public var id: UUID
    public var input: AddressInput

    public init(id: UUID, input: AddressInput) {
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
          GraphQLField("updateAddress", arguments: ["id": GraphQLVariable("id"), "input": GraphQLVariable("input")], type: .nonNull(.object(UpdateAddress.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(updateAddress: UpdateAddress) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "updateAddress": updateAddress.resultMap])
      }

      public var updateAddress: UpdateAddress {
        get {
          return UpdateAddress(unsafeResultMap: resultMap["updateAddress"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "updateAddress")
        }
      }

      public struct UpdateAddress: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Address"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("title", type: .scalar(String.self)),
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

        public init(id: UUID, title: String? = nil, line1: String, line2: String? = nil, postalCode: String, city: String, state: String? = nil, country: String, location: Location? = nil) {
          self.init(unsafeResultMap: ["__typename": "Address", "id": id, "title": title, "line1": line1, "line2": line2, "postal_code": postalCode, "city": city, "state": state, "country": country, "location": location.flatMap { (value: Location) -> ResultMap in value.resultMap }])
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

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
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
