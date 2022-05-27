// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class CreateShipmentMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation createShipment($input: ShipmentInput!) {
        createShipment(input: $input) {
          __typename
          id
          order {
            __typename
            id
            state
            shipment {
              __typename
              id
              tracking_code
              return_code
            }
          }
          tracking_code
          return_code
        }
      }
      """

    public let operationName: String = "createShipment"

    public var input: ShipmentInput

    public init(input: ShipmentInput) {
      self.input = input
    }

    public var variables: GraphQLMap? {
      return ["input": input]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("createShipment", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreateShipment.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(createShipment: CreateShipment) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "createShipment": createShipment.resultMap])
      }

      public var createShipment: CreateShipment {
        get {
          return CreateShipment(unsafeResultMap: resultMap["createShipment"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "createShipment")
        }
      }

      public struct CreateShipment: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Shipment"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("order", type: .nonNull(.object(Order.selections))),
            GraphQLField("tracking_code", type: .scalar(String.self)),
            GraphQLField("return_code", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, order: Order, trackingCode: String? = nil, returnCode: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Shipment", "id": id, "order": order.resultMap, "tracking_code": trackingCode, "return_code": returnCode])
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

        public var order: Order {
          get {
            return Order(unsafeResultMap: resultMap["order"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "order")
          }
        }

        public var trackingCode: String? {
          get {
            return resultMap["tracking_code"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "tracking_code")
          }
        }

        public var returnCode: String? {
          get {
            return resultMap["return_code"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "return_code")
          }
        }

        public struct Order: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Order"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("state", type: .nonNull(.scalar(OrderState.self))),
              GraphQLField("shipment", type: .object(Shipment.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, state: OrderState, shipment: Shipment? = nil) {
            self.init(unsafeResultMap: ["__typename": "Order", "id": id, "state": state, "shipment": shipment.flatMap { (value: Shipment) -> ResultMap in value.resultMap }])
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

          public var state: OrderState {
            get {
              return resultMap["state"]! as! OrderState
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
            }
          }

          public var shipment: Shipment? {
            get {
              return (resultMap["shipment"] as? ResultMap).flatMap { Shipment(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "shipment")
            }
          }

          public struct Shipment: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Shipment"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
                GraphQLField("tracking_code", type: .scalar(String.self)),
                GraphQLField("return_code", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: UUID, trackingCode: String? = nil, returnCode: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Shipment", "id": id, "tracking_code": trackingCode, "return_code": returnCode])
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

            public var trackingCode: String? {
              get {
                return resultMap["tracking_code"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "tracking_code")
              }
            }

            public var returnCode: String? {
              get {
                return resultMap["return_code"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "return_code")
              }
            }
          }
        }
      }
    }
  }
}
