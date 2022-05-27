// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetShippingMethodsQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getShippingMethods($origin: String, $destination: String) {
        shippingMethods {
          __typename
          id
          slug
          price(origin: $origin, country: $destination) {
            __typename
            currency
            amount
          }
        }
      }
      """

    public let operationName: String = "getShippingMethods"

    public var origin: String?
    public var destination: String?

    public init(origin: String? = nil, destination: String? = nil) {
      self.origin = origin
      self.destination = destination
    }

    public var variables: GraphQLMap? {
      return ["origin": origin, "destination": destination]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("shippingMethods", type: .nonNull(.list(.nonNull(.object(ShippingMethod.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(shippingMethods: [ShippingMethod]) {
        self.init(unsafeResultMap: ["__typename": "Query", "shippingMethods": shippingMethods.map { (value: ShippingMethod) -> ResultMap in value.resultMap }])
      }

      public var shippingMethods: [ShippingMethod] {
        get {
          return (resultMap["shippingMethods"] as! [ResultMap]).map { (value: ResultMap) -> ShippingMethod in ShippingMethod(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: ShippingMethod) -> ResultMap in value.resultMap }, forKey: "shippingMethods")
        }
      }

      public struct ShippingMethod: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ShippingMethod"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("slug", type: .nonNull(.scalar(String.self))),
            GraphQLField("price", arguments: ["origin": GraphQLVariable("origin"), "country": GraphQLVariable("destination")], type: .nonNull(.object(Price.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, slug: String, price: Price) {
          self.init(unsafeResultMap: ["__typename": "ShippingMethod", "id": id, "slug": slug, "price": price.resultMap])
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

        public var price: Price {
          get {
            return Price(unsafeResultMap: resultMap["price"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "price")
          }
        }

        public struct Price: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Price"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
              GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(currency: Currency, amount: Double) {
            self.init(unsafeResultMap: ["__typename": "Price", "currency": currency, "amount": amount])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
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

          public var amount: Double {
            get {
              return resultMap["amount"]! as! Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "amount")
            }
          }
        }
      }
    }
  }
}
