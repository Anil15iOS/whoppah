// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class GetMeQuery: GraphQLQuery {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      query getMe {
        me {
          __typename
          id
          given_name
          family_name
          email
          date_joined
          dob
          locale
          merchants {
            __typename
            id
            name
            created
            type
            email
            phone
            url
            business_name
            tax_id
            vat_id
            vat_id_registrar
            biography
            compliance_level
            fee {
              __typename
              type
              amount
            }
            currency
            bank_account {
              __typename
              account_number
              routing_number
              account_holder_name
            }
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
            bank_account {
              __typename
              account_number
              routing_number
              account_holder_name
            }
            avatar: image(type: AVATAR) {
              __typename
              id
              url
            }
            cover: image(type: COVER) {
              __typename
              id
              url
            }
          }
        }
      }
      """

    public let operationName: String = "getMe"

    public init() {
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Query"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("me", type: .object(Me.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(me: Me? = nil) {
        self.init(unsafeResultMap: ["__typename": "Query", "me": me.flatMap { (value: Me) -> ResultMap in value.resultMap }])
      }

      public var me: Me? {
        get {
          return (resultMap["me"] as? ResultMap).flatMap { Me(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "me")
        }
      }

      public struct Me: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Member"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
            GraphQLField("given_name", type: .nonNull(.scalar(String.self))),
            GraphQLField("family_name", type: .nonNull(.scalar(String.self))),
            GraphQLField("email", type: .nonNull(.scalar(String.self))),
            GraphQLField("date_joined", type: .nonNull(.scalar(DateTime.self))),
            GraphQLField("dob", type: .scalar(Date.self)),
            GraphQLField("locale", type: .nonNull(.scalar(Locale.self))),
            GraphQLField("merchants", type: .nonNull(.list(.nonNull(.object(Merchant.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: UUID, givenName: String, familyName: String, email: String, dateJoined: DateTime, dob: Date? = nil, locale: Locale, merchants: [Merchant]) {
          self.init(unsafeResultMap: ["__typename": "Member", "id": id, "given_name": givenName, "family_name": familyName, "email": email, "date_joined": dateJoined, "dob": dob, "locale": locale, "merchants": merchants.map { (value: Merchant) -> ResultMap in value.resultMap }])
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

        public var givenName: String {
          get {
            return resultMap["given_name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "given_name")
          }
        }

        public var familyName: String {
          get {
            return resultMap["family_name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "family_name")
          }
        }

        public var email: String {
          get {
            return resultMap["email"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var dateJoined: DateTime {
          get {
            return resultMap["date_joined"]! as! DateTime
          }
          set {
            resultMap.updateValue(newValue, forKey: "date_joined")
          }
        }

        public var dob: Date? {
          get {
            return resultMap["dob"] as? Date
          }
          set {
            resultMap.updateValue(newValue, forKey: "dob")
          }
        }

        public var locale: Locale {
          get {
            return resultMap["locale"]! as! Locale
          }
          set {
            resultMap.updateValue(newValue, forKey: "locale")
          }
        }

        public var merchants: [Merchant] {
          get {
            return (resultMap["merchants"] as! [ResultMap]).map { (value: ResultMap) -> Merchant in Merchant(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Merchant) -> ResultMap in value.resultMap }, forKey: "merchants")
          }
        }

        public struct Merchant: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Merchant"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(UUID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("created", type: .nonNull(.scalar(DateTime.self))),
              GraphQLField("type", type: .nonNull(.scalar(MerchantType.self))),
              GraphQLField("email", type: .scalar(String.self)),
              GraphQLField("phone", type: .scalar(String.self)),
              GraphQLField("url", type: .scalar(String.self)),
              GraphQLField("business_name", type: .scalar(String.self)),
              GraphQLField("tax_id", type: .scalar(String.self)),
              GraphQLField("vat_id", type: .scalar(String.self)),
              GraphQLField("vat_id_registrar", type: .scalar(String.self)),
              GraphQLField("biography", type: .scalar(String.self)),
              GraphQLField("compliance_level", type: .scalar(Int.self)),
              GraphQLField("fee", type: .object(Fee.selections)),
              GraphQLField("currency", type: .nonNull(.scalar(Currency.self))),
              GraphQLField("bank_account", type: .object(BankAccount.selections)),
              GraphQLField("addresses", type: .nonNull(.list(.nonNull(.object(Address.selections))))),
              GraphQLField("bank_account", type: .object(BankAccount.selections)),
              GraphQLField("image", alias: "avatar", arguments: ["type": "AVATAR"], type: .object(Avatar.selections)),
              GraphQLField("image", alias: "cover", arguments: ["type": "COVER"], type: .object(Cover.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: UUID, name: String, created: DateTime, type: MerchantType, email: String? = nil, phone: String? = nil, url: String? = nil, businessName: String? = nil, taxId: String? = nil, vatId: String? = nil, vatIdRegistrar: String? = nil, biography: String? = nil, complianceLevel: Int? = nil, fee: Fee? = nil, currency: Currency, bankAccount: BankAccount? = nil, addresses: [Address], avatar: Avatar? = nil, cover: Cover? = nil) {
            self.init(unsafeResultMap: ["__typename": "Merchant", "id": id, "name": name, "created": created, "type": type, "email": email, "phone": phone, "url": url, "business_name": businessName, "tax_id": taxId, "vat_id": vatId, "vat_id_registrar": vatIdRegistrar, "biography": biography, "compliance_level": complianceLevel, "fee": fee.flatMap { (value: Fee) -> ResultMap in value.resultMap }, "currency": currency, "bank_account": bankAccount.flatMap { (value: BankAccount) -> ResultMap in value.resultMap }, "addresses": addresses.map { (value: Address) -> ResultMap in value.resultMap }, "avatar": avatar.flatMap { (value: Avatar) -> ResultMap in value.resultMap }, "cover": cover.flatMap { (value: Cover) -> ResultMap in value.resultMap }])
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

          public var type: MerchantType {
            get {
              return resultMap["type"]! as! MerchantType
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }

          public var email: String? {
            get {
              return resultMap["email"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "email")
            }
          }

          public var phone: String? {
            get {
              return resultMap["phone"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "phone")
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

          public var businessName: String? {
            get {
              return resultMap["business_name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "business_name")
            }
          }

          public var taxId: String? {
            get {
              return resultMap["tax_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "tax_id")
            }
          }

          public var vatId: String? {
            get {
              return resultMap["vat_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "vat_id")
            }
          }

          public var vatIdRegistrar: String? {
            get {
              return resultMap["vat_id_registrar"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "vat_id_registrar")
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

          public var complianceLevel: Int? {
            get {
              return resultMap["compliance_level"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "compliance_level")
            }
          }

          public var fee: Fee? {
            get {
              return (resultMap["fee"] as? ResultMap).flatMap { Fee(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "fee")
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

          public var bankAccount: BankAccount? {
            get {
              return (resultMap["bank_account"] as? ResultMap).flatMap { BankAccount(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "bank_account")
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

          public struct Fee: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Fee"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("type", type: .nonNull(.scalar(CalculationMethod.self))),
                GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(type: CalculationMethod, amount: Double) {
              self.init(unsafeResultMap: ["__typename": "Fee", "type": type, "amount": amount])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var type: CalculationMethod {
              get {
                return resultMap["type"]! as! CalculationMethod
              }
              set {
                resultMap.updateValue(newValue, forKey: "type")
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

          public struct BankAccount: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["BankAccount"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("account_number", type: .nonNull(.scalar(String.self))),
                GraphQLField("routing_number", type: .scalar(String.self)),
                GraphQLField("account_holder_name", type: .nonNull(.scalar(String.self))),
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

          public struct Avatar: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
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

          public struct Cover: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Image"]

            public static var selections: [GraphQLSelection] {
              return [
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
        }
      }
    }
  }
}
