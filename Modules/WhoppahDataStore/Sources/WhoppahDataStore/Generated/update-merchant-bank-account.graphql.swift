// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class UpdateMerchantBankAccountMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation updateMerchantBankAccount($id: UUID!, $input: BankAccountInput!) {
        updateMerchantBankAccount(id: $id, input: $input) {
          __typename
          id
          compliance_level
          bank_account {
            __typename
            account_number
            routing_number
            account_holder_name
          }
        }
      }
      """

    public let operationName: String = "updateMerchantBankAccount"

    public var id: UUID
    public var input: BankAccountInput

    public init(id: UUID, input: BankAccountInput) {
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
          GraphQLField("updateMerchantBankAccount", arguments: ["id": GraphQLVariable("id"), "input": GraphQLVariable("input")], type: .nonNull(.object(UpdateMerchantBankAccount.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(updateMerchantBankAccount: UpdateMerchantBankAccount) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "updateMerchantBankAccount": updateMerchantBankAccount.resultMap])
      }

      public var updateMerchantBankAccount: UpdateMerchantBankAccount {
        get {
          return UpdateMerchantBankAccount(unsafeResultMap: resultMap["updateMerchantBankAccount"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "updateMerchantBankAccount")
        }
      }

      public struct UpdateMerchantBankAccount: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Merchant"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("compliance_level", type: .scalar(Int.self)),
            GraphQLField("bank_account", type: .object(BankAccount.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, complianceLevel: Int? = nil, bankAccount: BankAccount? = nil) {
          self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "compliance_level": complianceLevel, "bank_account": bankAccount.flatMap { (value: BankAccount) -> ResultMap in value.resultMap }])
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

        public var complianceLevel: Int? {
          get {
            return resultMap["compliance_level"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "compliance_level")
          }
        }

        public var bankAccount: BankAccount? {
          get {
            return (resultMap["bank_account"] as? ResultMap).flatMap { BankAccount(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "bank_account")
          }
        }

        public struct BankAccount: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["BankAccount"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("account_number", type: .nonNull(.scalar(String.self))),
              GraphQLField("routing_number", type: .scalar(String.self)),
              GraphQLField("account_holder_name", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(accountNumber: String, routingNumber: String? = nil, accountHolderName: String) {
            self.init(unsafeResultMap: ["__typename": "BankAccount", "account_number": accountNumber, "routing_number": routingNumber, "account_holder_name": accountHolderName])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var accountNumber: String {
            get {
              return resultMap["account_number"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "account_number")
            }
          }

          public var routingNumber: String? {
            get {
              return resultMap["routing_number"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "routing_number")
            }
          }

          public var accountHolderName: String {
            get {
              return resultMap["account_holder_name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "account_holder_name")
            }
          }
        }
      }
    }
  }
}
