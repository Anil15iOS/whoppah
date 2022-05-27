// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetOrderTotalsQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getOrderTotals($values: OrderInput!) {
        getOrderTotals(values: $values) {
          __typename
          subtotal_incl_vat
          subtotal_excl_vat
          shipping_incl_vat
          shipping_excl_vat
          payment_incl_vat
          payment_excl_vat
          discount_incl_vat
          discount_excl_vat
          total_incl_vat
          total_excl_vat
          buyer_protection_incl_vat
          buyer_protection_excl_vat
        }
      }
      """

    public let operationName: String = "getOrderTotals"

    public var values: OrderInput

    public init(values: OrderInput) {
      self.values = values
    }

    public var variables: GraphQLMap? {
      return ["values": values]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("getOrderTotals", arguments: ["values": GraphQLVariable("values")], type: .nonNull(.object(GetOrderTotal.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(getOrderTotals: GetOrderTotal) {
        self.init(unsafeResultMap: ["__typename": "Query", "getOrderTotals": getOrderTotals.resultMap])
      }

      public var getOrderTotals: GetOrderTotal {
        get {
          return GetOrderTotal(unsafeResultMap: resultMap["getOrderTotals"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "getOrderTotals")
        }
      }

      public struct GetOrderTotal: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["OrderTotals"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("subtotal_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("subtotal_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("shipping_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("shipping_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("payment_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("payment_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("discount_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("discount_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("total_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("total_excl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("buyer_protection_incl_vat", type: .nonNull(.scalar(Double.self))),
            GraphQLField("buyer_protection_excl_vat", type: .nonNull(.scalar(Double.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(subtotalInclVat: Double, subtotalExclVat: Double, shippingInclVat: Double, shippingExclVat: Double, paymentInclVat: Double, paymentExclVat: Double, discountInclVat: Double, discountExclVat: Double, totalInclVat: Double, totalExclVat: Double, buyerProtectionInclVat: Double, buyerProtectionExclVat: Double) {
          self.init(unsafeResultMap: ["__typename": "OrderTotals", "subtotal_incl_vat": subtotalInclVat, "subtotal_excl_vat": subtotalExclVat, "shipping_incl_vat": shippingInclVat, "shipping_excl_vat": shippingExclVat, "payment_incl_vat": paymentInclVat, "payment_excl_vat": paymentExclVat, "discount_incl_vat": discountInclVat, "discount_excl_vat": discountExclVat, "total_incl_vat": totalInclVat, "total_excl_vat": totalExclVat, "buyer_protection_incl_vat": buyerProtectionInclVat, "buyer_protection_excl_vat": buyerProtectionExclVat])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var subtotalInclVat: Double {
          get {
            return resultMap["subtotal_incl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "subtotal_incl_vat")
          }
        }

        public var subtotalExclVat: Double {
          get {
            return resultMap["subtotal_excl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "subtotal_excl_vat")
          }
        }

        public var shippingInclVat: Double {
          get {
            return resultMap["shipping_incl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "shipping_incl_vat")
          }
        }

        public var shippingExclVat: Double {
          get {
            return resultMap["shipping_excl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "shipping_excl_vat")
          }
        }

        @available(*, deprecated, message: "No longer supported")
        public var paymentInclVat: Double {
          get {
            return resultMap["payment_incl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "payment_incl_vat")
          }
        }

        @available(*, deprecated, message: "No longer supported")
        public var paymentExclVat: Double {
          get {
            return resultMap["payment_excl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "payment_excl_vat")
          }
        }

        public var discountInclVat: Double {
          get {
            return resultMap["discount_incl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "discount_incl_vat")
          }
        }

        public var discountExclVat: Double {
          get {
            return resultMap["discount_excl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "discount_excl_vat")
          }
        }

        public var totalInclVat: Double {
          get {
            return resultMap["total_incl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "total_incl_vat")
          }
        }

        public var totalExclVat: Double {
          get {
            return resultMap["total_excl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "total_excl_vat")
          }
        }

        public var buyerProtectionInclVat: Double {
          get {
            return resultMap["buyer_protection_incl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "buyer_protection_incl_vat")
          }
        }

        public var buyerProtectionExclVat: Double {
          get {
            return resultMap["buyer_protection_excl_vat"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "buyer_protection_excl_vat")
          }
        }
      }
    }
  }
}
