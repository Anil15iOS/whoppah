// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public enum GraphQL {
  public enum BidState: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case new
    case accepted
    case canceled
    case processing
    case completed
    case expired
    case rejected
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "NEW": self = .new
        case "ACCEPTED": self = .accepted
        case "CANCELED": self = .canceled
        case "PROCESSING": self = .processing
        case "COMPLETED": self = .completed
        case "EXPIRED": self = .expired
        case "REJECTED": self = .rejected
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .new: return "NEW"
        case .accepted: return "ACCEPTED"
        case .canceled: return "CANCELED"
        case .processing: return "PROCESSING"
        case .completed: return "COMPLETED"
        case .expired: return "EXPIRED"
        case .rejected: return "REJECTED"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: BidState, rhs: BidState) -> Bool {
      switch (lhs, rhs) {
        case (.new, .new): return true
        case (.accepted, .accepted): return true
        case (.canceled, .canceled): return true
        case (.processing, .processing): return true
        case (.completed, .completed): return true
        case (.expired, .expired): return true
        case (.rejected, .rejected): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [BidState] {
      return [
        .new,
        .accepted,
        .canceled,
        .processing,
        .completed,
        .expired,
        .rejected,
      ]
    }
  }

  public enum Currency: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case eur
    case usd
    case gbp
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "EUR": self = .eur
        case "USD": self = .usd
        case "GBP": self = .gbp
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .eur: return "EUR"
        case .usd: return "USD"
        case .gbp: return "GBP"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Currency, rhs: Currency) -> Bool {
      switch (lhs, rhs) {
        case (.eur, .eur): return true
        case (.usd, .usd): return true
        case (.gbp, .gbp): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Currency] {
      return [
        .eur,
        .usd,
        .gbp,
      ]
    }
  }

  public enum AuctionState: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case draft
    case published
    case canceled
    case expired
    case reserved
    case completed
    case banned
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "DRAFT": self = .draft
        case "PUBLISHED": self = .published
        case "CANCELED": self = .canceled
        case "EXPIRED": self = .expired
        case "RESERVED": self = .reserved
        case "COMPLETED": self = .completed
        case "BANNED": self = .banned
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .draft: return "DRAFT"
        case .published: return "PUBLISHED"
        case .canceled: return "CANCELED"
        case .expired: return "EXPIRED"
        case .reserved: return "RESERVED"
        case .completed: return "COMPLETED"
        case .banned: return "BANNED"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: AuctionState, rhs: AuctionState) -> Bool {
      switch (lhs, rhs) {
        case (.draft, .draft): return true
        case (.published, .published): return true
        case (.canceled, .canceled): return true
        case (.expired, .expired): return true
        case (.reserved, .reserved): return true
        case (.completed, .completed): return true
        case (.banned, .banned): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [AuctionState] {
      return [
        .draft,
        .published,
        .canceled,
        .expired,
        .reserved,
        .completed,
        .banned,
      ]
    }
  }

  public enum OrderState: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case new
    case canceled
    case expired
    case accepted
    case shipped
    case disputed
    case completed
    case delivered
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "NEW": self = .new
        case "CANCELED": self = .canceled
        case "EXPIRED": self = .expired
        case "ACCEPTED": self = .accepted
        case "SHIPPED": self = .shipped
        case "DISPUTED": self = .disputed
        case "COMPLETED": self = .completed
        case "DELIVERED": self = .delivered
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .new: return "NEW"
        case .canceled: return "CANCELED"
        case .expired: return "EXPIRED"
        case .accepted: return "ACCEPTED"
        case .shipped: return "SHIPPED"
        case .disputed: return "DISPUTED"
        case .completed: return "COMPLETED"
        case .delivered: return "DELIVERED"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: OrderState, rhs: OrderState) -> Bool {
      switch (lhs, rhs) {
        case (.new, .new): return true
        case (.canceled, .canceled): return true
        case (.expired, .expired): return true
        case (.accepted, .accepted): return true
        case (.shipped, .shipped): return true
        case (.disputed, .disputed): return true
        case (.completed, .completed): return true
        case (.delivered, .delivered): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [OrderState] {
      return [
        .new,
        .canceled,
        .expired,
        .accepted,
        .shipped,
        .disputed,
        .completed,
        .delivered,
      ]
    }
  }

  public enum CheckEmailExistsStatus: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case available
    case unavailable
    case banned
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "AVAILABLE": self = .available
        case "UNAVAILABLE": self = .unavailable
        case "BANNED": self = .banned
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .available: return "AVAILABLE"
        case .unavailable: return "UNAVAILABLE"
        case .banned: return "BANNED"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: CheckEmailExistsStatus, rhs: CheckEmailExistsStatus) -> Bool {
      switch (lhs, rhs) {
        case (.available, .available): return true
        case (.unavailable, .unavailable): return true
        case (.banned, .banned): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [CheckEmailExistsStatus] {
      return [
        .available,
        .unavailable,
        .banned,
      ]
    }
  }

  public struct AbuseReportInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - id
    ///   - type
    ///   - reason
    ///   - description
    public init(id: UUID, type: AbuseReportType, reason: AbuseReportReason, description: Swift.Optional<String?> = nil) {
      graphQLMap = ["id": id, "type": type, "reason": reason, "description": description]
    }

    public var id: UUID {
      get {
        return graphQLMap["id"] as! UUID
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "id")
      }
    }

    public var type: AbuseReportType {
      get {
        return graphQLMap["type"] as! AbuseReportType
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "type")
      }
    }

    public var reason: AbuseReportReason {
      get {
        return graphQLMap["reason"] as! AbuseReportReason
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "reason")
      }
    }

    public var description: Swift.Optional<String?> {
      get {
        return graphQLMap["description"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "description")
      }
    }
  }

  public enum AbuseReportType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case product
    case user
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "PRODUCT": self = .product
        case "USER": self = .user
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .product: return "PRODUCT"
        case .user: return "USER"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: AbuseReportType, rhs: AbuseReportType) -> Bool {
      switch (lhs, rhs) {
        case (.product, .product): return true
        case (.user, .user): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [AbuseReportType] {
      return [
        .product,
        .user,
      ]
    }
  }

  public enum AbuseReportReason: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case violatingContent
    case spam
    case wrongCategory
    case poorPhotoQuality
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "VIOLATING_CONTENT": self = .violatingContent
        case "SPAM": self = .spam
        case "WRONG_CATEGORY": self = .wrongCategory
        case "POOR_PHOTO_QUALITY": self = .poorPhotoQuality
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .violatingContent: return "VIOLATING_CONTENT"
        case .spam: return "SPAM"
        case .wrongCategory: return "WRONG_CATEGORY"
        case .poorPhotoQuality: return "POOR_PHOTO_QUALITY"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: AbuseReportReason, rhs: AbuseReportReason) -> Bool {
      switch (lhs, rhs) {
        case (.violatingContent, .violatingContent): return true
        case (.spam, .spam): return true
        case (.wrongCategory, .wrongCategory): return true
        case (.poorPhotoQuality, .poorPhotoQuality): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [AbuseReportReason] {
      return [
        .violatingContent,
        .spam,
        .wrongCategory,
        .poorPhotoQuality,
      ]
    }
  }

  public struct AddressInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - merchantId
    ///   - title
    ///   - line1
    ///   - line2
    ///   - postalCode
    ///   - city
    ///   - state
    ///   - country
    ///   - location
    public init(merchantId: UUID, title: Swift.Optional<String?> = nil, line1: String, line2: Swift.Optional<String?> = nil, postalCode: String, city: String, state: Swift.Optional<String?> = nil, country: String, location: Swift.Optional<LocationInput?> = nil) {
      graphQLMap = ["merchant_id": merchantId, "title": title, "line1": line1, "line2": line2, "postal_code": postalCode, "city": city, "state": state, "country": country, "location": location]
    }

    public var merchantId: UUID {
      get {
        return graphQLMap["merchant_id"] as! UUID
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "merchant_id")
      }
    }

    public var title: Swift.Optional<String?> {
      get {
        return graphQLMap["title"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "title")
      }
    }

    public var line1: String {
      get {
        return graphQLMap["line1"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "line1")
      }
    }

    public var line2: Swift.Optional<String?> {
      get {
        return graphQLMap["line2"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "line2")
      }
    }

    public var postalCode: String {
      get {
        return graphQLMap["postal_code"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "postal_code")
      }
    }

    public var city: String {
      get {
        return graphQLMap["city"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "city")
      }
    }

    public var state: Swift.Optional<String?> {
      get {
        return graphQLMap["state"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "state")
      }
    }

    public var country: String {
      get {
        return graphQLMap["country"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "country")
      }
    }

    public var location: Swift.Optional<LocationInput?> {
      get {
        return graphQLMap["location"] as? Swift.Optional<LocationInput?> ?? Swift.Optional<LocationInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "location")
      }
    }
  }

  public struct LocationInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - latitude
    ///   - longitude
    public init(latitude: Double, longitude: Double) {
      graphQLMap = ["latitude": latitude, "longitude": longitude]
    }

    public var latitude: Double {
      get {
        return graphQLMap["latitude"] as! Double
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "latitude")
      }
    }

    public var longitude: Double {
      get {
        return graphQLMap["longitude"] as! Double
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "longitude")
      }
    }
  }

  public struct BidInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - auctionId
    ///   - amount
    ///   - createThread
    public init(auctionId: UUID, amount: PriceInput, createThread: Swift.Optional<Bool?> = nil) {
      graphQLMap = ["auction_id": auctionId, "amount": amount, "create_thread": createThread]
    }

    public var auctionId: UUID {
      get {
        return graphQLMap["auction_id"] as! UUID
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "auction_id")
      }
    }

    public var amount: PriceInput {
      get {
        return graphQLMap["amount"] as! PriceInput
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "amount")
      }
    }

    public var createThread: Swift.Optional<Bool?> {
      get {
        return graphQLMap["create_thread"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "create_thread")
      }
    }
  }

  public struct PriceInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - amount
    ///   - currency
    public init(amount: Double, currency: Currency) {
      graphQLMap = ["amount": amount, "currency": currency]
    }

    public var amount: Double {
      get {
        return graphQLMap["amount"] as! Double
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "amount")
      }
    }

    public var currency: Currency {
      get {
        return graphQLMap["currency"] as! Currency
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "currency")
      }
    }
  }

  public struct CounterBidInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - auctionId
    ///   - amount
    ///   - buyerId
    public init(auctionId: UUID, amount: PriceInput, buyerId: UUID) {
      graphQLMap = ["auction_id": auctionId, "amount": amount, "buyer_id": buyerId]
    }

    public var auctionId: UUID {
      get {
        return graphQLMap["auction_id"] as! UUID
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "auction_id")
      }
    }

    public var amount: PriceInput {
      get {
        return graphQLMap["amount"] as! PriceInput
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "amount")
      }
    }

    public var buyerId: UUID {
      get {
        return graphQLMap["buyer_id"] as! UUID
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "buyer_id")
      }
    }
  }

  public struct FavoriteInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - contentType
    ///   - objectId
    ///   - collection
    public init(contentType: ContentType, objectId: UUID, collection: Swift.Optional<UUID?> = nil) {
      graphQLMap = ["content_type": contentType, "object_id": objectId, "collection": collection]
    }

    public var contentType: ContentType {
      get {
        return graphQLMap["content_type"] as! ContentType
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "content_type")
      }
    }

    public var objectId: UUID {
      get {
        return graphQLMap["object_id"] as! UUID
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "object_id")
      }
    }

    public var collection: Swift.Optional<UUID?> {
      get {
        return graphQLMap["collection"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "collection")
      }
    }
  }

  public enum ContentType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case product
    case merchant
    case message
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "PRODUCT": self = .product
        case "MERCHANT": self = .merchant
        case "MESSAGE": self = .message
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .product: return "PRODUCT"
        case .merchant: return "MERCHANT"
        case .message: return "MESSAGE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ContentType, rhs: ContentType) -> Bool {
      switch (lhs, rhs) {
        case (.product, .product): return true
        case (.merchant, .merchant): return true
        case (.message, .message): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ContentType] {
      return [
        .product,
        .merchant,
        .message,
      ]
    }
  }

  public struct ShipmentInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - orderId
    ///   - trackingCode
    ///   - returnCode
    public init(orderId: UUID, trackingCode: Swift.Optional<String?> = nil, returnCode: Swift.Optional<String?> = nil) {
      graphQLMap = ["order_id": orderId, "tracking_code": trackingCode, "return_code": returnCode]
    }

    public var orderId: UUID {
      get {
        return graphQLMap["order_id"] as! UUID
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "order_id")
      }
    }

    public var trackingCode: Swift.Optional<String?> {
      get {
        return graphQLMap["tracking_code"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "tracking_code")
      }
    }

    public var returnCode: Swift.Optional<String?> {
      get {
        return graphQLMap["return_code"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "return_code")
      }
    }
  }

  public struct OrderInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - purchaseType
    ///   - bidId
    ///   - productId
    ///   - paymentMethod
    ///   - paymentMethodId
    ///   - deliveryMethod
    ///   - shippingMethodId
    ///   - addressId
    ///   - couponCode
    ///   - buyerProtection
    ///   - usePaymentIntents
    public init(purchaseType: PurchaseType, bidId: Swift.Optional<UUID?> = nil, productId: Swift.Optional<UUID?> = nil, paymentMethod: Swift.Optional<PaymentMethod?> = nil, paymentMethodId: Swift.Optional<String?> = nil, deliveryMethod: Swift.Optional<DeliveryMethod?> = nil, shippingMethodId: Swift.Optional<UUID?> = nil, addressId: Swift.Optional<UUID?> = nil, couponCode: Swift.Optional<String?> = nil, buyerProtection: Swift.Optional<Bool?> = nil, usePaymentIntents: Swift.Optional<Bool?> = nil) {
      graphQLMap = ["purchase_type": purchaseType, "bid_id": bidId, "product_id": productId, "payment_method": paymentMethod, "payment_method_id": paymentMethodId, "delivery_method": deliveryMethod, "shipping_method_id": shippingMethodId, "address_id": addressId, "coupon_code": couponCode, "buyer_protection": buyerProtection, "use_payment_intents": usePaymentIntents]
    }

    public var purchaseType: PurchaseType {
      get {
        return graphQLMap["purchase_type"] as! PurchaseType
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "purchase_type")
      }
    }

    public var bidId: Swift.Optional<UUID?> {
      get {
        return graphQLMap["bid_id"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "bid_id")
      }
    }

    public var productId: Swift.Optional<UUID?> {
      get {
        return graphQLMap["product_id"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "product_id")
      }
    }

    public var paymentMethod: Swift.Optional<PaymentMethod?> {
      get {
        return graphQLMap["payment_method"] as? Swift.Optional<PaymentMethod?> ?? Swift.Optional<PaymentMethod?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "payment_method")
      }
    }

    public var paymentMethodId: Swift.Optional<String?> {
      get {
        return graphQLMap["payment_method_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "payment_method_id")
      }
    }

    public var deliveryMethod: Swift.Optional<DeliveryMethod?> {
      get {
        return graphQLMap["delivery_method"] as? Swift.Optional<DeliveryMethod?> ?? Swift.Optional<DeliveryMethod?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "delivery_method")
      }
    }

    public var shippingMethodId: Swift.Optional<UUID?> {
      get {
        return graphQLMap["shipping_method_id"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "shipping_method_id")
      }
    }

    public var addressId: Swift.Optional<UUID?> {
      get {
        return graphQLMap["address_id"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "address_id")
      }
    }

    public var couponCode: Swift.Optional<String?> {
      get {
        return graphQLMap["coupon_code"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "coupon_code")
      }
    }

    public var buyerProtection: Swift.Optional<Bool?> {
      get {
        return graphQLMap["buyer_protection"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "buyer_protection")
      }
    }

    public var usePaymentIntents: Swift.Optional<Bool?> {
      get {
        return graphQLMap["use_payment_intents"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "use_payment_intents")
      }
    }
  }

  public enum PurchaseType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case bid
    case directPurchase
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "BID": self = .bid
        case "DIRECT_PURCHASE": self = .directPurchase
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .bid: return "BID"
        case .directPurchase: return "DIRECT_PURCHASE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: PurchaseType, rhs: PurchaseType) -> Bool {
      switch (lhs, rhs) {
        case (.bid, .bid): return true
        case (.directPurchase, .directPurchase): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [PurchaseType] {
      return [
        .bid,
        .directPurchase,
      ]
    }
  }

  public enum PaymentMethod: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case card
    case bancontact
    case ideal
    case klarna
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "CARD": self = .card
        case "BANCONTACT": self = .bancontact
        case "IDEAL": self = .ideal
        case "KLARNA": self = .klarna
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .card: return "CARD"
        case .bancontact: return "BANCONTACT"
        case .ideal: return "IDEAL"
        case .klarna: return "KLARNA"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: PaymentMethod, rhs: PaymentMethod) -> Bool {
      switch (lhs, rhs) {
        case (.card, .card): return true
        case (.bancontact, .bancontact): return true
        case (.ideal, .ideal): return true
        case (.klarna, .klarna): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [PaymentMethod] {
      return [
        .card,
        .bancontact,
        .ideal,
        .klarna,
      ]
    }
  }

  public enum DeliveryMethod: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case pickup
    case delivery
    case pickupDelivery
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "PICKUP": self = .pickup
        case "DELIVERY": self = .delivery
        case "PICKUP_DELIVERY": self = .pickupDelivery
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .pickup: return "PICKUP"
        case .delivery: return "DELIVERY"
        case .pickupDelivery: return "PICKUP_DELIVERY"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: DeliveryMethod, rhs: DeliveryMethod) -> Bool {
      switch (lhs, rhs) {
        case (.pickup, .pickup): return true
        case (.delivery, .delivery): return true
        case (.pickupDelivery, .pickupDelivery): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [DeliveryMethod] {
      return [
        .pickup,
        .delivery,
        .pickupDelivery,
      ]
    }
  }

  public enum ProductState: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case draft
    case curation
    case rejected
    case banned
    case canceled
    case accepted
    case updated
    case archive
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "DRAFT": self = .draft
        case "CURATION": self = .curation
        case "REJECTED": self = .rejected
        case "BANNED": self = .banned
        case "CANCELED": self = .canceled
        case "ACCEPTED": self = .accepted
        case "UPDATED": self = .updated
        case "ARCHIVE": self = .archive
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .draft: return "DRAFT"
        case .curation: return "CURATION"
        case .rejected: return "REJECTED"
        case .banned: return "BANNED"
        case .canceled: return "CANCELED"
        case .accepted: return "ACCEPTED"
        case .updated: return "UPDATED"
        case .archive: return "ARCHIVE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ProductState, rhs: ProductState) -> Bool {
      switch (lhs, rhs) {
        case (.draft, .draft): return true
        case (.curation, .curation): return true
        case (.rejected, .rejected): return true
        case (.banned, .banned): return true
        case (.canceled, .canceled): return true
        case (.accepted, .accepted): return true
        case (.updated, .updated): return true
        case (.archive, .archive): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ProductState] {
      return [
        .draft,
        .curation,
        .rejected,
        .banned,
        .canceled,
        .accepted,
        .updated,
        .archive,
      ]
    }
  }

  public struct PaymentInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - usePaymentIntents
    ///   - paymentMethod
    ///   - paymentMethodId
    ///   - deliveryMethod
    ///   - shippingMethodId
    ///   - addressId
    ///   - couponCode
    ///   - buyerProtection
    public init(usePaymentIntents: Swift.Optional<Bool?> = nil, paymentMethod: PaymentMethod, paymentMethodId: Swift.Optional<String?> = nil, deliveryMethod: Swift.Optional<DeliveryMethod?> = nil, shippingMethodId: Swift.Optional<UUID?> = nil, addressId: Swift.Optional<UUID?> = nil, couponCode: Swift.Optional<String?> = nil, buyerProtection: Swift.Optional<Bool?> = nil) {
      graphQLMap = ["use_payment_intents": usePaymentIntents, "payment_method": paymentMethod, "payment_method_id": paymentMethodId, "delivery_method": deliveryMethod, "shipping_method_id": shippingMethodId, "address_id": addressId, "coupon_code": couponCode, "buyer_protection": buyerProtection]
    }

    public var usePaymentIntents: Swift.Optional<Bool?> {
      get {
        return graphQLMap["use_payment_intents"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "use_payment_intents")
      }
    }

    public var paymentMethod: PaymentMethod {
      get {
        return graphQLMap["payment_method"] as! PaymentMethod
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "payment_method")
      }
    }

    public var paymentMethodId: Swift.Optional<String?> {
      get {
        return graphQLMap["payment_method_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "payment_method_id")
      }
    }

    public var deliveryMethod: Swift.Optional<DeliveryMethod?> {
      get {
        return graphQLMap["delivery_method"] as? Swift.Optional<DeliveryMethod?> ?? Swift.Optional<DeliveryMethod?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "delivery_method")
      }
    }

    public var shippingMethodId: Swift.Optional<UUID?> {
      get {
        return graphQLMap["shipping_method_id"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "shipping_method_id")
      }
    }

    public var addressId: Swift.Optional<UUID?> {
      get {
        return graphQLMap["address_id"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "address_id")
      }
    }

    public var couponCode: Swift.Optional<String?> {
      get {
        return graphQLMap["coupon_code"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "coupon_code")
      }
    }

    public var buyerProtection: Swift.Optional<Bool?> {
      get {
        return graphQLMap["buyer_protection"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "buyer_protection")
      }
    }
  }

  public struct ProductInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - title
    ///   - description
    ///   - condition
    ///   - quality
    ///   - sku
    ///   - mpn
    ///   - gtin
    ///   - width
    ///   - height
    ///   - depth
    ///   - seatHeight
    ///   - weight
    ///   - artOrientation
    ///   - deliveryMethod
    ///   - shippingMethod
    ///   - shippingCost
    ///   - address
    ///   - merchant
    ///   - quantity
    ///   - numberOfItems
    ///   - buyNowPrice
    ///   - originalPrice
    ///   - minimumBid
    ///   - allowBid
    ///   - allowBuyNow
    ///   - reactivate
    ///   - categories
    ///   - brand
    ///   - designers
    ///   - artists
    ///   - styles
    ///   - materials
    ///   - colors
    ///   - usageSigns
    ///   - additionalInfo
    ///   - subjects
    ///   - brandSuggestion
    ///   - designerSuggestion
    ///   - artistSuggestion
    ///   - isInShowroom
    public init(title: String, description: Swift.Optional<String?> = nil, condition: Swift.Optional<ProductCondition?> = nil, quality: ProductQuality, sku: Swift.Optional<String?> = nil, mpn: Swift.Optional<String?> = nil, gtin: Swift.Optional<String?> = nil, width: Swift.Optional<Int?> = nil, height: Swift.Optional<Int?> = nil, depth: Swift.Optional<Int?> = nil, seatHeight: Swift.Optional<Int?> = nil, weight: Swift.Optional<Int?> = nil, artOrientation: Swift.Optional<ArtOrientation?> = nil, deliveryMethod: DeliveryMethod, shippingMethod: Swift.Optional<UUID?> = nil, shippingCost: Swift.Optional<PriceInput?> = nil, address: Swift.Optional<UUID?> = nil, merchant: UUID, quantity: Swift.Optional<Int?> = nil, numberOfItems: Swift.Optional<Int?> = nil, buyNowPrice: Swift.Optional<PriceInput?> = nil, originalPrice: Swift.Optional<PriceInput?> = nil, minimumBid: Swift.Optional<PriceInput?> = nil, allowBid: Bool, allowBuyNow: Bool, reactivate: Swift.Optional<Bool?> = nil, categories: Swift.Optional<[UUID]?> = nil, brand: Swift.Optional<UUID?> = nil, designers: Swift.Optional<[UUID]?> = nil, artists: Swift.Optional<[UUID]?> = nil, styles: Swift.Optional<[UUID]?> = nil, materials: Swift.Optional<[UUID]?> = nil, colors: Swift.Optional<[UUID]?> = nil, usageSigns: Swift.Optional<[UUID]?> = nil, additionalInfo: Swift.Optional<[UUID]?> = nil, subjects: Swift.Optional<[UUID]?> = nil, brandSuggestion: Swift.Optional<String?> = nil, designerSuggestion: Swift.Optional<String?> = nil, artistSuggestion: Swift.Optional<String?> = nil, isInShowroom: Swift.Optional<Bool?> = nil) {
      graphQLMap = ["title": title, "description": description, "condition": condition, "quality": quality, "sku": sku, "mpn": mpn, "gtin": gtin, "width": width, "height": height, "depth": depth, "seat_height": seatHeight, "weight": weight, "art_orientation": artOrientation, "delivery_method": deliveryMethod, "shipping_method": shippingMethod, "shipping_cost": shippingCost, "address": address, "merchant": merchant, "quantity": quantity, "number_of_items": numberOfItems, "buy_now_price": buyNowPrice, "original_price": originalPrice, "minimum_bid": minimumBid, "allow_bid": allowBid, "allow_buy_now": allowBuyNow, "reactivate": reactivate, "categories": categories, "brand": brand, "designers": designers, "artists": artists, "styles": styles, "materials": materials, "colors": colors, "usage_signs": usageSigns, "additional_info": additionalInfo, "subjects": subjects, "brand_suggestion": brandSuggestion, "designer_suggestion": designerSuggestion, "artist_suggestion": artistSuggestion, "is_in_showroom": isInShowroom]
    }

    public var title: String {
      get {
        return graphQLMap["title"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "title")
      }
    }

    public var description: Swift.Optional<String?> {
      get {
        return graphQLMap["description"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "description")
      }
    }

    public var condition: Swift.Optional<ProductCondition?> {
      get {
        return graphQLMap["condition"] as? Swift.Optional<ProductCondition?> ?? Swift.Optional<ProductCondition?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "condition")
      }
    }

    public var quality: ProductQuality {
      get {
        return graphQLMap["quality"] as! ProductQuality
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "quality")
      }
    }

    public var sku: Swift.Optional<String?> {
      get {
        return graphQLMap["sku"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "sku")
      }
    }

    public var mpn: Swift.Optional<String?> {
      get {
        return graphQLMap["mpn"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "mpn")
      }
    }

    public var gtin: Swift.Optional<String?> {
      get {
        return graphQLMap["gtin"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "gtin")
      }
    }

    public var width: Swift.Optional<Int?> {
      get {
        return graphQLMap["width"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "width")
      }
    }

    public var height: Swift.Optional<Int?> {
      get {
        return graphQLMap["height"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "height")
      }
    }

    public var depth: Swift.Optional<Int?> {
      get {
        return graphQLMap["depth"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "depth")
      }
    }

    public var seatHeight: Swift.Optional<Int?> {
      get {
        return graphQLMap["seat_height"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "seat_height")
      }
    }

    public var weight: Swift.Optional<Int?> {
      get {
        return graphQLMap["weight"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "weight")
      }
    }

    public var artOrientation: Swift.Optional<ArtOrientation?> {
      get {
        return graphQLMap["art_orientation"] as? Swift.Optional<ArtOrientation?> ?? Swift.Optional<ArtOrientation?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "art_orientation")
      }
    }

    public var deliveryMethod: DeliveryMethod {
      get {
        return graphQLMap["delivery_method"] as! DeliveryMethod
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "delivery_method")
      }
    }

    public var shippingMethod: Swift.Optional<UUID?> {
      get {
        return graphQLMap["shipping_method"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "shipping_method")
      }
    }

    public var shippingCost: Swift.Optional<PriceInput?> {
      get {
        return graphQLMap["shipping_cost"] as? Swift.Optional<PriceInput?> ?? Swift.Optional<PriceInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "shipping_cost")
      }
    }

    public var address: Swift.Optional<UUID?> {
      get {
        return graphQLMap["address"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "address")
      }
    }

    public var merchant: UUID {
      get {
        return graphQLMap["merchant"] as! UUID
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "merchant")
      }
    }

    public var quantity: Swift.Optional<Int?> {
      get {
        return graphQLMap["quantity"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "quantity")
      }
    }

    public var numberOfItems: Swift.Optional<Int?> {
      get {
        return graphQLMap["number_of_items"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "number_of_items")
      }
    }

    public var buyNowPrice: Swift.Optional<PriceInput?> {
      get {
        return graphQLMap["buy_now_price"] as? Swift.Optional<PriceInput?> ?? Swift.Optional<PriceInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "buy_now_price")
      }
    }

    public var originalPrice: Swift.Optional<PriceInput?> {
      get {
        return graphQLMap["original_price"] as? Swift.Optional<PriceInput?> ?? Swift.Optional<PriceInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "original_price")
      }
    }

    public var minimumBid: Swift.Optional<PriceInput?> {
      get {
        return graphQLMap["minimum_bid"] as? Swift.Optional<PriceInput?> ?? Swift.Optional<PriceInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "minimum_bid")
      }
    }

    public var allowBid: Bool {
      get {
        return graphQLMap["allow_bid"] as! Bool
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "allow_bid")
      }
    }

    public var allowBuyNow: Bool {
      get {
        return graphQLMap["allow_buy_now"] as! Bool
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "allow_buy_now")
      }
    }

    public var reactivate: Swift.Optional<Bool?> {
      get {
        return graphQLMap["reactivate"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "reactivate")
      }
    }

    public var categories: Swift.Optional<[UUID]?> {
      get {
        return graphQLMap["categories"] as? Swift.Optional<[UUID]?> ?? Swift.Optional<[UUID]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "categories")
      }
    }

    public var brand: Swift.Optional<UUID?> {
      get {
        return graphQLMap["brand"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "brand")
      }
    }

    public var designers: Swift.Optional<[UUID]?> {
      get {
        return graphQLMap["designers"] as? Swift.Optional<[UUID]?> ?? Swift.Optional<[UUID]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "designers")
      }
    }

    public var artists: Swift.Optional<[UUID]?> {
      get {
        return graphQLMap["artists"] as? Swift.Optional<[UUID]?> ?? Swift.Optional<[UUID]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "artists")
      }
    }

    public var styles: Swift.Optional<[UUID]?> {
      get {
        return graphQLMap["styles"] as? Swift.Optional<[UUID]?> ?? Swift.Optional<[UUID]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "styles")
      }
    }

    public var materials: Swift.Optional<[UUID]?> {
      get {
        return graphQLMap["materials"] as? Swift.Optional<[UUID]?> ?? Swift.Optional<[UUID]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "materials")
      }
    }

    public var colors: Swift.Optional<[UUID]?> {
      get {
        return graphQLMap["colors"] as? Swift.Optional<[UUID]?> ?? Swift.Optional<[UUID]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "colors")
      }
    }

    public var usageSigns: Swift.Optional<[UUID]?> {
      get {
        return graphQLMap["usage_signs"] as? Swift.Optional<[UUID]?> ?? Swift.Optional<[UUID]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "usage_signs")
      }
    }

    public var additionalInfo: Swift.Optional<[UUID]?> {
      get {
        return graphQLMap["additional_info"] as? Swift.Optional<[UUID]?> ?? Swift.Optional<[UUID]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "additional_info")
      }
    }

    public var subjects: Swift.Optional<[UUID]?> {
      get {
        return graphQLMap["subjects"] as? Swift.Optional<[UUID]?> ?? Swift.Optional<[UUID]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "subjects")
      }
    }

    public var brandSuggestion: Swift.Optional<String?> {
      get {
        return graphQLMap["brand_suggestion"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "brand_suggestion")
      }
    }

    public var designerSuggestion: Swift.Optional<String?> {
      get {
        return graphQLMap["designer_suggestion"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "designer_suggestion")
      }
    }

    public var artistSuggestion: Swift.Optional<String?> {
      get {
        return graphQLMap["artist_suggestion"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "artist_suggestion")
      }
    }

    public var isInShowroom: Swift.Optional<Bool?> {
      get {
        return graphQLMap["is_in_showroom"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "is_in_showroom")
      }
    }
  }

  public enum ProductCondition: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case new
    case refurbished
    case openbox
    case used
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "NEW": self = .new
        case "REFURBISHED": self = .refurbished
        case "OPENBOX": self = .openbox
        case "USED": self = .used
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .new: return "NEW"
        case .refurbished: return "REFURBISHED"
        case .openbox: return "OPENBOX"
        case .used: return "USED"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ProductCondition, rhs: ProductCondition) -> Bool {
      switch (lhs, rhs) {
        case (.new, .new): return true
        case (.refurbished, .refurbished): return true
        case (.openbox, .openbox): return true
        case (.used, .used): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ProductCondition] {
      return [
        .new,
        .refurbished,
        .openbox,
        .used,
      ]
    }
  }

  public enum ProductQuality: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case good
    case great
    case perfect
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "GOOD": self = .good
        case "GREAT": self = .great
        case "PERFECT": self = .perfect
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .good: return "GOOD"
        case .great: return "GREAT"
        case .perfect: return "PERFECT"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ProductQuality, rhs: ProductQuality) -> Bool {
      switch (lhs, rhs) {
        case (.good, .good): return true
        case (.great, .great): return true
        case (.perfect, .perfect): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ProductQuality] {
      return [
        .good,
        .great,
        .perfect,
      ]
    }
  }

  public enum ArtOrientation: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case landscape
    case portrait
    case square
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "LANDSCAPE": self = .landscape
        case "PORTRAIT": self = .portrait
        case "SQUARE": self = .square
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .landscape: return "LANDSCAPE"
        case .portrait: return "PORTRAIT"
        case .square: return "SQUARE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ArtOrientation, rhs: ArtOrientation) -> Bool {
      switch (lhs, rhs) {
        case (.landscape, .landscape): return true
        case (.portrait, .portrait): return true
        case (.square, .square): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ArtOrientation] {
      return [
        .landscape,
        .portrait,
        .square,
      ]
    }
  }

  public enum PlaylistType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case hls
    case mpegdash
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "HLS": self = .hls
        case "MPEGDASH": self = .mpegdash
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .hls: return "HLS"
        case .mpegdash: return "MPEGDASH"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: PlaylistType, rhs: PlaylistType) -> Bool {
      switch (lhs, rhs) {
        case (.hls, .hls): return true
        case (.mpegdash, .mpegdash): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [PlaylistType] {
      return [
        .hls,
        .mpegdash,
      ]
    }
  }

  public enum ARDetection: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case vertical
    case horizontal
    case verticalAndHorizontal
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "VERTICAL": self = .vertical
        case "HORIZONTAL": self = .horizontal
        case "VERTICAL_AND_HORIZONTAL": self = .verticalAndHorizontal
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .vertical: return "VERTICAL"
        case .horizontal: return "HORIZONTAL"
        case .verticalAndHorizontal: return "VERTICAL_AND_HORIZONTAL"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ARDetection, rhs: ARDetection) -> Bool {
      switch (lhs, rhs) {
        case (.vertical, .vertical): return true
        case (.horizontal, .horizontal): return true
        case (.verticalAndHorizontal, .verticalAndHorizontal): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ARDetection] {
      return [
        .vertical,
        .horizontal,
        .verticalAndHorizontal,
      ]
    }
  }

  public enum ARObjectType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case `default`
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "DEFAULT": self = .default
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .default: return "DEFAULT"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ARObjectType, rhs: ARObjectType) -> Bool {
      switch (lhs, rhs) {
        case (.default, .default): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ARObjectType] {
      return [
        .default,
      ]
    }
  }

  public struct SavedSearchInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - title
    ///   - query
    ///   - filters
    public init(title: Swift.Optional<String?> = nil, query: Swift.Optional<String?> = nil, filters: Swift.Optional<SearchFilterInput?> = nil) {
      graphQLMap = ["title": title, "query": query, "filters": filters]
    }

    public var title: Swift.Optional<String?> {
      get {
        return graphQLMap["title"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "title")
      }
    }

    public var query: Swift.Optional<String?> {
      get {
        return graphQLMap["query"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "query")
      }
    }

    public var filters: Swift.Optional<SearchFilterInput?> {
      get {
        return graphQLMap["filters"] as? Swift.Optional<SearchFilterInput?> ?? Swift.Optional<SearchFilterInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "filters")
      }
    }
  }

  public struct SearchFilterInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - attributes
    ///   - properties
    ///   - categories
    ///   - price
    ///   - inShowroom
    ///   - location
    public init(attributes: Swift.Optional<[AttributeSearchFilterInput]?> = nil, properties: Swift.Optional<[PropertySearchFilterInput]?> = nil, categories: Swift.Optional<CategorySearchFilterInput?> = nil, price: Swift.Optional<PriceSearchFilterInput?> = nil, inShowroom: Swift.Optional<Bool?> = nil, location: Swift.Optional<LocationSearchFilterInput?> = nil) {
      graphQLMap = ["attributes": attributes, "properties": properties, "categories": categories, "price": price, "in_showroom": inShowroom, "location": location]
    }

    public var attributes: Swift.Optional<[AttributeSearchFilterInput]?> {
      get {
        return graphQLMap["attributes"] as? Swift.Optional<[AttributeSearchFilterInput]?> ?? Swift.Optional<[AttributeSearchFilterInput]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "attributes")
      }
    }

    public var properties: Swift.Optional<[PropertySearchFilterInput]?> {
      get {
        return graphQLMap["properties"] as? Swift.Optional<[PropertySearchFilterInput]?> ?? Swift.Optional<[PropertySearchFilterInput]?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "properties")
      }
    }

    public var categories: Swift.Optional<CategorySearchFilterInput?> {
      get {
        return graphQLMap["categories"] as? Swift.Optional<CategorySearchFilterInput?> ?? Swift.Optional<CategorySearchFilterInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "categories")
      }
    }

    public var price: Swift.Optional<PriceSearchFilterInput?> {
      get {
        return graphQLMap["price"] as? Swift.Optional<PriceSearchFilterInput?> ?? Swift.Optional<PriceSearchFilterInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "price")
      }
    }

    public var inShowroom: Swift.Optional<Bool?> {
      get {
        return graphQLMap["in_showroom"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "in_showroom")
      }
    }

    public var location: Swift.Optional<LocationSearchFilterInput?> {
      get {
        return graphQLMap["location"] as? Swift.Optional<LocationSearchFilterInput?> ?? Swift.Optional<LocationSearchFilterInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "location")
      }
    }
  }

  public struct AttributeSearchFilterInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - key
    ///   - value
    public init(key: AttributeType, value: [String]) {
      graphQLMap = ["key": key, "value": value]
    }

    public var key: AttributeType {
      get {
        return graphQLMap["key"] as! AttributeType
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "key")
      }
    }

    public var value: [String] {
      get {
        return graphQLMap["value"] as! [String]
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  public enum AttributeType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case artist
    case brand
    case color
    case designer
    case label
    case material
    case style
    case usageSign
    case additionalInfo
    case subject
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "ARTIST": self = .artist
        case "BRAND": self = .brand
        case "COLOR": self = .color
        case "DESIGNER": self = .designer
        case "LABEL": self = .label
        case "MATERIAL": self = .material
        case "STYLE": self = .style
        case "USAGE_SIGN": self = .usageSign
        case "ADDITIONAL_INFO": self = .additionalInfo
        case "SUBJECT": self = .subject
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .artist: return "ARTIST"
        case .brand: return "BRAND"
        case .color: return "COLOR"
        case .designer: return "DESIGNER"
        case .label: return "LABEL"
        case .material: return "MATERIAL"
        case .style: return "STYLE"
        case .usageSign: return "USAGE_SIGN"
        case .additionalInfo: return "ADDITIONAL_INFO"
        case .subject: return "SUBJECT"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: AttributeType, rhs: AttributeType) -> Bool {
      switch (lhs, rhs) {
        case (.artist, .artist): return true
        case (.brand, .brand): return true
        case (.color, .color): return true
        case (.designer, .designer): return true
        case (.label, .label): return true
        case (.material, .material): return true
        case (.style, .style): return true
        case (.usageSign, .usageSign): return true
        case (.additionalInfo, .additionalInfo): return true
        case (.subject, .subject): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [AttributeType] {
      return [
        .artist,
        .brand,
        .color,
        .designer,
        .label,
        .material,
        .style,
        .usageSign,
        .additionalInfo,
        .subject,
      ]
    }
  }

  public struct PropertySearchFilterInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - key
    ///   - value
    public init(key: ProductPropertyKey, value: String) {
      graphQLMap = ["key": key, "value": value]
    }

    public var key: ProductPropertyKey {
      get {
        return graphQLMap["key"] as! ProductPropertyKey
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "key")
      }
    }

    public var value: String {
      get {
        return graphQLMap["value"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  public enum ProductPropertyKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case condition
    case quality
    case hasAr
    case merchant
    case country
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "CONDITION": self = .condition
        case "QUALITY": self = .quality
        case "HAS_AR": self = .hasAr
        case "MERCHANT": self = .merchant
        case "COUNTRY": self = .country
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .condition: return "CONDITION"
        case .quality: return "QUALITY"
        case .hasAr: return "HAS_AR"
        case .merchant: return "MERCHANT"
        case .country: return "COUNTRY"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ProductPropertyKey, rhs: ProductPropertyKey) -> Bool {
      switch (lhs, rhs) {
        case (.condition, .condition): return true
        case (.quality, .quality): return true
        case (.hasAr, .hasAr): return true
        case (.merchant, .merchant): return true
        case (.country, .country): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ProductPropertyKey] {
      return [
        .condition,
        .quality,
        .hasAr,
        .merchant,
        .country,
      ]
    }
  }

  public struct CategorySearchFilterInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - value
    public init(value: [String]) {
      graphQLMap = ["value": value]
    }

    public var value: [String] {
      get {
        return graphQLMap["value"] as! [String]
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  public struct PriceSearchFilterInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - currency
    ///   - from
    ///   - to
    public init(currency: Swift.Optional<Currency?> = nil, from: Swift.Optional<Double?> = nil, to: Swift.Optional<Double?> = nil) {
      graphQLMap = ["currency": currency, "from": from, "to": to]
    }

    public var currency: Swift.Optional<Currency?> {
      get {
        return graphQLMap["currency"] as? Swift.Optional<Currency?> ?? Swift.Optional<Currency?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "currency")
      }
    }

    public var from: Swift.Optional<Double?> {
      get {
        return graphQLMap["from"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "from")
      }
    }

    public var to: Swift.Optional<Double?> {
      get {
        return graphQLMap["to"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "to")
      }
    }
  }

  public struct LocationSearchFilterInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - latitude
    ///   - longitude
    ///   - address
    ///   - distance
    public init(latitude: Swift.Optional<Double?> = nil, longitude: Swift.Optional<Double?> = nil, address: Swift.Optional<String?> = nil, distance: Swift.Optional<Int?> = nil) {
      graphQLMap = ["latitude": latitude, "longitude": longitude, "address": address, "distance": distance]
    }

    public var latitude: Swift.Optional<Double?> {
      get {
        return graphQLMap["latitude"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "latitude")
      }
    }

    public var longitude: Swift.Optional<Double?> {
      get {
        return graphQLMap["longitude"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "longitude")
      }
    }

    public var address: Swift.Optional<String?> {
      get {
        return graphQLMap["address"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "address")
      }
    }

    public var distance: Swift.Optional<Int?> {
      get {
        return graphQLMap["distance"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "distance")
      }
    }
  }

  public struct ForgotPasswordInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - email
    public init(email: String) {
      graphQLMap = ["email": email]
    }

    public var email: String {
      get {
        return graphQLMap["email"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "email")
      }
    }
  }

  public enum ForgotPasswordResult: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case emailSent
    case emailNotFound
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "EMAIL_SENT": self = .emailSent
        case "EMAIL_NOT_FOUND": self = .emailNotFound
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .emailSent: return "EMAIL_SENT"
        case .emailNotFound: return "EMAIL_NOT_FOUND"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ForgotPasswordResult, rhs: ForgotPasswordResult) -> Bool {
      switch (lhs, rhs) {
        case (.emailSent, .emailSent): return true
        case (.emailNotFound, .emailNotFound): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ForgotPasswordResult] {
      return [
        .emailSent,
        .emailNotFound,
      ]
    }
  }

  public enum Platform: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case ios
    case android
    case web
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "IOS": self = .ios
        case "ANDROID": self = .android
        case "WEB": self = .web
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .ios: return "IOS"
        case .android: return "ANDROID"
        case .web: return "WEB"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Platform, rhs: Platform) -> Bool {
      switch (lhs, rhs) {
        case (.ios, .ios): return true
        case (.android, .android): return true
        case (.web, .web): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Platform] {
      return [
        .ios,
        .android,
        .web,
      ]
    }
  }

  public struct AuctionInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - productId
    ///   - currency
    ///   - buyNowPrice
    ///   - minimumBid
    ///   - allowBid
    ///   - allowBuyNow
    public init(productId: UUID, currency: Currency, buyNowPrice: Swift.Optional<PriceInput?> = nil, minimumBid: Swift.Optional<PriceInput?> = nil, allowBid: Bool, allowBuyNow: Bool) {
      graphQLMap = ["product_id": productId, "currency": currency, "buy_now_price": buyNowPrice, "minimum_bid": minimumBid, "allow_bid": allowBid, "allow_buy_now": allowBuyNow]
    }

    public var productId: UUID {
      get {
        return graphQLMap["product_id"] as! UUID
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "product_id")
      }
    }

    public var currency: Currency {
      get {
        return graphQLMap["currency"] as! Currency
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "currency")
      }
    }

    public var buyNowPrice: Swift.Optional<PriceInput?> {
      get {
        return graphQLMap["buy_now_price"] as? Swift.Optional<PriceInput?> ?? Swift.Optional<PriceInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "buy_now_price")
      }
    }

    public var minimumBid: Swift.Optional<PriceInput?> {
      get {
        return graphQLMap["minimum_bid"] as? Swift.Optional<PriceInput?> ?? Swift.Optional<PriceInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "minimum_bid")
      }
    }

    public var allowBid: Bool {
      get {
        return graphQLMap["allow_bid"] as! Bool
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "allow_bid")
      }
    }

    public var allowBuyNow: Bool {
      get {
        return graphQLMap["allow_buy_now"] as! Bool
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "allow_buy_now")
      }
    }
  }

  public enum SubscriberRole: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case bot
    case curator
    case subscriber
    case support
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "BOT": self = .bot
        case "CURATOR": self = .curator
        case "SUBSCRIBER": self = .subscriber
        case "SUPPORT": self = .support
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .bot: return "BOT"
        case .curator: return "CURATOR"
        case .subscriber: return "SUBSCRIBER"
        case .support: return "SUPPORT"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: SubscriberRole, rhs: SubscriberRole) -> Bool {
      switch (lhs, rhs) {
        case (.bot, .bot): return true
        case (.curator, .curator): return true
        case (.subscriber, .subscriber): return true
        case (.support, .support): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [SubscriberRole] {
      return [
        .bot,
        .curator,
        .subscriber,
        .support,
      ]
    }
  }

  public struct MemberInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - email
    ///   - givenName
    ///   - familyName
    ///   - password
    ///   - dob
    ///   - locale
    public init(email: String, givenName: String, familyName: String, password: Swift.Optional<String?> = nil, dob: Swift.Optional<Date?> = nil, locale: Swift.Optional<Locale?> = nil) {
      graphQLMap = ["email": email, "given_name": givenName, "family_name": familyName, "password": password, "dob": dob, "locale": locale]
    }

    public var email: String {
      get {
        return graphQLMap["email"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "email")
      }
    }

    public var givenName: String {
      get {
        return graphQLMap["given_name"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "given_name")
      }
    }

    public var familyName: String {
      get {
        return graphQLMap["family_name"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "family_name")
      }
    }

    public var password: Swift.Optional<String?> {
      get {
        return graphQLMap["password"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "password")
      }
    }

    public var dob: Swift.Optional<Date?> {
      get {
        return graphQLMap["dob"] as? Swift.Optional<Date?> ?? Swift.Optional<Date?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "dob")
      }
    }

    public var locale: Swift.Optional<Locale?> {
      get {
        return graphQLMap["locale"] as? Swift.Optional<Locale?> ?? Swift.Optional<Locale?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "locale")
      }
    }
  }

  /// The Locale enum represents the possible locality settings for the
  /// current merchant.
  public enum Locale: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case deDe
    case deAt
    case frFr
    case frBe
    case nlNl
    case nlBe
    case enGb
    case enUs
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "DE_DE": self = .deDe
        case "DE_AT": self = .deAt
        case "FR_FR": self = .frFr
        case "FR_BE": self = .frBe
        case "NL_NL": self = .nlNl
        case "NL_BE": self = .nlBe
        case "EN_GB": self = .enGb
        case "EN_US": self = .enUs
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .deDe: return "DE_DE"
        case .deAt: return "DE_AT"
        case .frFr: return "FR_FR"
        case .frBe: return "FR_BE"
        case .nlNl: return "NL_NL"
        case .nlBe: return "NL_BE"
        case .enGb: return "EN_GB"
        case .enUs: return "EN_US"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Locale, rhs: Locale) -> Bool {
      switch (lhs, rhs) {
        case (.deDe, .deDe): return true
        case (.deAt, .deAt): return true
        case (.frFr, .frFr): return true
        case (.frBe, .frBe): return true
        case (.nlNl, .nlNl): return true
        case (.nlBe, .nlBe): return true
        case (.enGb, .enGb): return true
        case (.enUs, .enUs): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Locale] {
      return [
        .deDe,
        .deAt,
        .frFr,
        .frBe,
        .nlNl,
        .nlBe,
        .enGb,
        .enUs,
      ]
    }
  }

  public struct MerchantInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - type
    ///   - name
    ///   - biography
    ///   - url
    ///   - phone
    ///   - email
    ///   - businessName
    ///   - taxId
    ///   - vatId
    ///   - vatIdRegistrar
    ///   - currency
    public init(type: MerchantType, name: String, biography: Swift.Optional<String?> = nil, url: Swift.Optional<String?> = nil, phone: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, businessName: Swift.Optional<String?> = nil, taxId: Swift.Optional<String?> = nil, vatId: Swift.Optional<String?> = nil, vatIdRegistrar: Swift.Optional<String?> = nil, currency: Swift.Optional<Currency?> = nil) {
      graphQLMap = ["type": type, "name": name, "biography": biography, "url": url, "phone": phone, "email": email, "business_name": businessName, "tax_id": taxId, "vat_id": vatId, "vat_id_registrar": vatIdRegistrar, "currency": currency]
    }

    public var type: MerchantType {
      get {
        return graphQLMap["type"] as! MerchantType
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "type")
      }
    }

    public var name: String {
      get {
        return graphQLMap["name"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "name")
      }
    }

    public var biography: Swift.Optional<String?> {
      get {
        return graphQLMap["biography"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "biography")
      }
    }

    public var url: Swift.Optional<String?> {
      get {
        return graphQLMap["url"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "url")
      }
    }

    public var phone: Swift.Optional<String?> {
      get {
        return graphQLMap["phone"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "phone")
      }
    }

    public var email: Swift.Optional<String?> {
      get {
        return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "email")
      }
    }

    public var businessName: Swift.Optional<String?> {
      get {
        return graphQLMap["business_name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "business_name")
      }
    }

    public var taxId: Swift.Optional<String?> {
      get {
        return graphQLMap["tax_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "tax_id")
      }
    }

    public var vatId: Swift.Optional<String?> {
      get {
        return graphQLMap["vat_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "vat_id")
      }
    }

    public var vatIdRegistrar: Swift.Optional<String?> {
      get {
        return graphQLMap["vat_id_registrar"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "vat_id_registrar")
      }
    }

    public var currency: Swift.Optional<Currency?> {
      get {
        return graphQLMap["currency"] as? Swift.Optional<Currency?> ?? Swift.Optional<Currency?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "currency")
      }
    }
  }

  public enum MerchantType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case individual
    case business
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "INDIVIDUAL": self = .individual
        case "BUSINESS": self = .business
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .individual: return "INDIVIDUAL"
        case .business: return "BUSINESS"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: MerchantType, rhs: MerchantType) -> Bool {
      switch (lhs, rhs) {
        case (.individual, .individual): return true
        case (.business, .business): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [MerchantType] {
      return [
        .individual,
        .business,
      ]
    }
  }

  public struct SignupWithEmailPasswordInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - email
    ///   - password
    ///   - type
    ///   - name
    ///   - phone
    ///   - givenName
    ///   - familyName
    ///   - address
    public init(email: String, password: String, type: MerchantType, name: String, phone: String, givenName: Swift.Optional<String?> = nil, familyName: Swift.Optional<String?> = nil, address: Swift.Optional<SignupAddressInput?> = nil) {
      graphQLMap = ["email": email, "password": password, "type": type, "name": name, "phone": phone, "given_name": givenName, "family_name": familyName, "address": address]
    }

    public var email: String {
      get {
        return graphQLMap["email"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "email")
      }
    }

    public var password: String {
      get {
        return graphQLMap["password"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "password")
      }
    }

    public var type: MerchantType {
      get {
        return graphQLMap["type"] as! MerchantType
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "type")
      }
    }

    public var name: String {
      get {
        return graphQLMap["name"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "name")
      }
    }

    public var phone: String {
      get {
        return graphQLMap["phone"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "phone")
      }
    }

    public var givenName: Swift.Optional<String?> {
      get {
        return graphQLMap["given_name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "given_name")
      }
    }

    public var familyName: Swift.Optional<String?> {
      get {
        return graphQLMap["family_name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "family_name")
      }
    }

    public var address: Swift.Optional<SignupAddressInput?> {
      get {
        return graphQLMap["address"] as? Swift.Optional<SignupAddressInput?> ?? Swift.Optional<SignupAddressInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "address")
      }
    }
  }

  public struct SignupAddressInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - line1
    ///   - line2
    ///   - postalCode
    ///   - city
    ///   - state
    ///   - country
    ///   - location
    public init(line1: String, line2: Swift.Optional<String?> = nil, postalCode: String, city: String, state: Swift.Optional<String?> = nil, country: String, location: Swift.Optional<LocationInput?> = nil) {
      graphQLMap = ["line1": line1, "line2": line2, "postal_code": postalCode, "city": city, "state": state, "country": country, "location": location]
    }

    public var line1: String {
      get {
        return graphQLMap["line1"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "line1")
      }
    }

    public var line2: Swift.Optional<String?> {
      get {
        return graphQLMap["line2"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "line2")
      }
    }

    public var postalCode: String {
      get {
        return graphQLMap["postal_code"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "postal_code")
      }
    }

    public var city: String {
      get {
        return graphQLMap["city"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "city")
      }
    }

    public var state: Swift.Optional<String?> {
      get {
        return graphQLMap["state"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "state")
      }
    }

    public var country: String {
      get {
        return graphQLMap["country"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "country")
      }
    }

    public var location: Swift.Optional<LocationInput?> {
      get {
        return graphQLMap["location"] as? Swift.Optional<LocationInput?> ?? Swift.Optional<LocationInput?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "location")
      }
    }
  }

  public struct Pagination: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - page
    ///   - limit
    public init(page: Swift.Optional<Int?> = nil, limit: Swift.Optional<Int?> = nil) {
      graphQLMap = ["page": page, "limit": limit]
    }

    public var page: Swift.Optional<Int?> {
      get {
        return graphQLMap["page"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "page")
      }
    }

    public var limit: Swift.Optional<Int?> {
      get {
        return graphQLMap["limit"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "limit")
      }
    }
  }

  public enum Entity: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case product
    case category
    case merchant
    case favoriteCollection
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "PRODUCT": self = .product
        case "CATEGORY": self = .category
        case "MERCHANT": self = .merchant
        case "FAVORITE_COLLECTION": self = .favoriteCollection
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .product: return "PRODUCT"
        case .category: return "CATEGORY"
        case .merchant: return "MERCHANT"
        case .favoriteCollection: return "FAVORITE_COLLECTION"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Entity, rhs: Entity) -> Bool {
      switch (lhs, rhs) {
        case (.product, .product): return true
        case (.category, .category): return true
        case (.merchant, .merchant): return true
        case (.favoriteCollection, .favoriteCollection): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Entity] {
      return [
        .product,
        .category,
        .merchant,
        .favoriteCollection,
      ]
    }
  }

  public enum Event: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case view
    case like
    case buy
    case bid
    case question
    case message
    case share
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "VIEW": self = .view
        case "LIKE": self = .like
        case "BUY": self = .buy
        case "BID": self = .bid
        case "QUESTION": self = .question
        case "MESSAGE": self = .message
        case "SHARE": self = .share
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .view: return "VIEW"
        case .like: return "LIKE"
        case .buy: return "BUY"
        case .bid: return "BID"
        case .question: return "QUESTION"
        case .message: return "MESSAGE"
        case .share: return "SHARE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Event, rhs: Event) -> Bool {
      switch (lhs, rhs) {
        case (.view, .view): return true
        case (.like, .like): return true
        case (.buy, .buy): return true
        case (.bid, .bid): return true
        case (.question, .question): return true
        case (.message, .message): return true
        case (.share, .share): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Event] {
      return [
        .view,
        .like,
        .buy,
        .bid,
        .question,
        .message,
        .share,
      ]
    }
  }

  public struct UpdateForgottenPasswordInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - uid
    ///   - token
    ///   - newPassword
    ///   - newPasswordConfirmation
    public init(uid: String, token: String, newPassword: String, newPasswordConfirmation: String) {
      graphQLMap = ["uid": uid, "token": token, "new_password": newPassword, "new_password_confirmation": newPasswordConfirmation]
    }

    public var uid: String {
      get {
        return graphQLMap["uid"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "uid")
      }
    }

    public var token: String {
      get {
        return graphQLMap["token"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "token")
      }
    }

    public var newPassword: String {
      get {
        return graphQLMap["new_password"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "new_password")
      }
    }

    public var newPasswordConfirmation: String {
      get {
        return graphQLMap["new_password_confirmation"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "new_password_confirmation")
      }
    }
  }

  public enum UpdateForgottenPasswordResult: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case success
    case failure
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "SUCCESS": self = .success
        case "FAILURE": self = .failure
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .success: return "SUCCESS"
        case .failure: return "FAILURE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: UpdateForgottenPasswordResult, rhs: UpdateForgottenPasswordResult) -> Bool {
      switch (lhs, rhs) {
        case (.success, .success): return true
        case (.failure, .failure): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [UpdateForgottenPasswordResult] {
      return [
        .success,
        .failure,
      ]
    }
  }

  public struct MediaUpdateInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - position
    ///   - contentType
    ///   - type
    ///   - objectId
    public init(position: Swift.Optional<Int?> = nil, contentType: Swift.Optional<ContentType?> = nil, type: Swift.Optional<String?> = nil, objectId: Swift.Optional<UUID?> = nil) {
      graphQLMap = ["position": position, "content_type": contentType, "type": type, "object_id": objectId]
    }

    public var position: Swift.Optional<Int?> {
      get {
        return graphQLMap["position"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "position")
      }
    }

    public var contentType: Swift.Optional<ContentType?> {
      get {
        return graphQLMap["content_type"] as? Swift.Optional<ContentType?> ?? Swift.Optional<ContentType?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "content_type")
      }
    }

    public var type: Swift.Optional<String?> {
      get {
        return graphQLMap["type"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "type")
      }
    }

    public var objectId: Swift.Optional<UUID?> {
      get {
        return graphQLMap["object_id"] as? Swift.Optional<UUID?> ?? Swift.Optional<UUID?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "object_id")
      }
    }
  }

  public struct UpdateMemberPassword: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - current
    ///   - password
    public init(current: Swift.Optional<String?> = nil, password: Swift.Optional<String?> = nil) {
      graphQLMap = ["current": current, "password": password]
    }

    public var current: Swift.Optional<String?> {
      get {
        return graphQLMap["current"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "current")
      }
    }

    public var password: Swift.Optional<String?> {
      get {
        return graphQLMap["password"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "password")
      }
    }
  }

  public struct BankAccountInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - accountNumber
    ///   - routingNumber
    ///   - accountHolderName
    public init(accountNumber: String, routingNumber: Swift.Optional<String?> = nil, accountHolderName: String) {
      graphQLMap = ["account_number": accountNumber, "routing_number": routingNumber, "account_holder_name": accountHolderName]
    }

    public var accountNumber: String {
      get {
        return graphQLMap["account_number"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "account_number")
      }
    }

    public var routingNumber: Swift.Optional<String?> {
      get {
        return graphQLMap["routing_number"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "routing_number")
      }
    }

    public var accountHolderName: String {
      get {
        return graphQLMap["account_holder_name"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "account_holder_name")
      }
    }
  }

  public enum CalculationMethod: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case percentage
    case fixed
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "PERCENTAGE": self = .percentage
        case "FIXED": self = .fixed
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .percentage: return "PERCENTAGE"
        case .fixed: return "FIXED"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: CalculationMethod, rhs: CalculationMethod) -> Bool {
      switch (lhs, rhs) {
        case (.percentage, .percentage): return true
        case (.fixed, .fixed): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [CalculationMethod] {
      return [
        .percentage,
        .fixed,
      ]
    }
  }

  public enum ProductWithdrawReason: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case soldWhoppah
    case soldElsewhere
    case soldEbay
    case soldPamono
    case soldSelency
    case sold_1Stdibs
    case soldMarktplaats
    case soldTweedehands
    case expiredNoResponse
    case noLongerSelling
    case leavingWhoppah
    case other
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "SOLD_WHOPPAH": self = .soldWhoppah
        case "SOLD_ELSEWHERE": self = .soldElsewhere
        case "SOLD_EBAY": self = .soldEbay
        case "SOLD_PAMONO": self = .soldPamono
        case "SOLD_SELENCY": self = .soldSelency
        case "SOLD_1STDIBS": self = .sold_1Stdibs
        case "SOLD_MARKTPLAATS": self = .soldMarktplaats
        case "SOLD_TWEEDEHANDS": self = .soldTweedehands
        case "EXPIRED_NO_RESPONSE": self = .expiredNoResponse
        case "NO_LONGER_SELLING": self = .noLongerSelling
        case "LEAVING_WHOPPAH": self = .leavingWhoppah
        case "OTHER": self = .other
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .soldWhoppah: return "SOLD_WHOPPAH"
        case .soldElsewhere: return "SOLD_ELSEWHERE"
        case .soldEbay: return "SOLD_EBAY"
        case .soldPamono: return "SOLD_PAMONO"
        case .soldSelency: return "SOLD_SELENCY"
        case .sold_1Stdibs: return "SOLD_1STDIBS"
        case .soldMarktplaats: return "SOLD_MARKTPLAATS"
        case .soldTweedehands: return "SOLD_TWEEDEHANDS"
        case .expiredNoResponse: return "EXPIRED_NO_RESPONSE"
        case .noLongerSelling: return "NO_LONGER_SELLING"
        case .leavingWhoppah: return "LEAVING_WHOPPAH"
        case .other: return "OTHER"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ProductWithdrawReason, rhs: ProductWithdrawReason) -> Bool {
      switch (lhs, rhs) {
        case (.soldWhoppah, .soldWhoppah): return true
        case (.soldElsewhere, .soldElsewhere): return true
        case (.soldEbay, .soldEbay): return true
        case (.soldPamono, .soldPamono): return true
        case (.soldSelency, .soldSelency): return true
        case (.sold_1Stdibs, .sold_1Stdibs): return true
        case (.soldMarktplaats, .soldMarktplaats): return true
        case (.soldTweedehands, .soldTweedehands): return true
        case (.expiredNoResponse, .expiredNoResponse): return true
        case (.noLongerSelling, .noLongerSelling): return true
        case (.leavingWhoppah, .leavingWhoppah): return true
        case (.other, .other): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ProductWithdrawReason] {
      return [
        .soldWhoppah,
        .soldElsewhere,
        .soldEbay,
        .soldPamono,
        .soldSelency,
        .sold_1Stdibs,
        .soldMarktplaats,
        .soldTweedehands,
        .expiredNoResponse,
        .noLongerSelling,
        .leavingWhoppah,
        .other,
      ]
    }
  }

  public enum AttributeFilterKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case slug
    case type
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "SLUG": self = .slug
        case "TYPE": self = .type
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .slug: return "SLUG"
        case .type: return "TYPE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: AttributeFilterKey, rhs: AttributeFilterKey) -> Bool {
      switch (lhs, rhs) {
        case (.slug, .slug): return true
        case (.type, .type): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [AttributeFilterKey] {
      return [
        .slug,
        .type,
      ]
    }
  }

  public struct CategoryFilter: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - key
    ///   - value
    public init(key: CategoryFilterKey, value: String) {
      graphQLMap = ["key": key, "value": value]
    }

    public var key: CategoryFilterKey {
      get {
        return graphQLMap["key"] as! CategoryFilterKey
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "key")
      }
    }

    public var value: String {
      get {
        return graphQLMap["value"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  public enum CategoryFilterKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case slug
    case parent
    case level
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "SLUG": self = .slug
        case "PARENT": self = .parent
        case "LEVEL": self = .level
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .slug: return "SLUG"
        case .parent: return "PARENT"
        case .level: return "LEVEL"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: CategoryFilterKey, rhs: CategoryFilterKey) -> Bool {
      switch (lhs, rhs) {
        case (.slug, .slug): return true
        case (.parent, .parent): return true
        case (.level, .level): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [CategoryFilterKey] {
      return [
        .slug,
        .parent,
        .level,
      ]
    }
  }

  public struct OrderFilter: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - key
    ///   - value
    public init(key: OrderFilterKey, value: String) {
      graphQLMap = ["key": key, "value": value]
    }

    public var key: OrderFilterKey {
      get {
        return graphQLMap["key"] as! OrderFilterKey
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "key")
      }
    }

    public var value: String {
      get {
        return graphQLMap["value"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  public enum OrderFilterKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case merchant
    case buyer
    case product
    case auction
    case bid
    case deliveryMethod
    case shippingMethod
    case state
    case productTitle
    case bidState
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "MERCHANT": self = .merchant
        case "BUYER": self = .buyer
        case "PRODUCT": self = .product
        case "AUCTION": self = .auction
        case "BID": self = .bid
        case "DELIVERY_METHOD": self = .deliveryMethod
        case "SHIPPING_METHOD": self = .shippingMethod
        case "STATE": self = .state
        case "PRODUCT__TITLE": self = .productTitle
        case "BID__STATE": self = .bidState
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .merchant: return "MERCHANT"
        case .buyer: return "BUYER"
        case .product: return "PRODUCT"
        case .auction: return "AUCTION"
        case .bid: return "BID"
        case .deliveryMethod: return "DELIVERY_METHOD"
        case .shippingMethod: return "SHIPPING_METHOD"
        case .state: return "STATE"
        case .productTitle: return "PRODUCT__TITLE"
        case .bidState: return "BID__STATE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: OrderFilterKey, rhs: OrderFilterKey) -> Bool {
      switch (lhs, rhs) {
        case (.merchant, .merchant): return true
        case (.buyer, .buyer): return true
        case (.product, .product): return true
        case (.auction, .auction): return true
        case (.bid, .bid): return true
        case (.deliveryMethod, .deliveryMethod): return true
        case (.shippingMethod, .shippingMethod): return true
        case (.state, .state): return true
        case (.productTitle, .productTitle): return true
        case (.bidState, .bidState): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [OrderFilterKey] {
      return [
        .merchant,
        .buyer,
        .product,
        .auction,
        .bid,
        .deliveryMethod,
        .shippingMethod,
        .state,
        .productTitle,
        .bidState,
      ]
    }
  }

  public enum OrderSort: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case `default`
    case created
    case expiryDate
    case endDate
    case payout
    case productTitle
    case totalInclVat
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "DEFAULT": self = .default
        case "CREATED": self = .created
        case "EXPIRY_DATE": self = .expiryDate
        case "END_DATE": self = .endDate
        case "PAYOUT": self = .payout
        case "PRODUCT__TITLE": self = .productTitle
        case "TOTAL_INCL_VAT": self = .totalInclVat
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .default: return "DEFAULT"
        case .created: return "CREATED"
        case .expiryDate: return "EXPIRY_DATE"
        case .endDate: return "END_DATE"
        case .payout: return "PAYOUT"
        case .productTitle: return "PRODUCT__TITLE"
        case .totalInclVat: return "TOTAL_INCL_VAT"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: OrderSort, rhs: OrderSort) -> Bool {
      switch (lhs, rhs) {
        case (.default, .default): return true
        case (.created, .created): return true
        case (.expiryDate, .expiryDate): return true
        case (.endDate, .endDate): return true
        case (.payout, .payout): return true
        case (.productTitle, .productTitle): return true
        case (.totalInclVat, .totalInclVat): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [OrderSort] {
      return [
        .default,
        .created,
        .expiryDate,
        .endDate,
        .payout,
        .productTitle,
        .totalInclVat,
      ]
    }
  }

  public enum Ordering: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case asc
    case desc
    case rand
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "ASC": self = .asc
        case "DESC": self = .desc
        case "RAND": self = .rand
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .asc: return "ASC"
        case .desc: return "DESC"
        case .rand: return "RAND"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Ordering, rhs: Ordering) -> Bool {
      switch (lhs, rhs) {
        case (.asc, .asc): return true
        case (.desc, .desc): return true
        case (.rand, .rand): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Ordering] {
      return [
        .asc,
        .desc,
        .rand,
      ]
    }
  }

  public enum PageFilterKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case slug
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "SLUG": self = .slug
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .slug: return "SLUG"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: PageFilterKey, rhs: PageFilterKey) -> Bool {
      switch (lhs, rhs) {
        case (.slug, .slug): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [PageFilterKey] {
      return [
        .slug,
      ]
    }
  }

  public enum BlockLocation: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case header
    case footer
    case body
    case asideLeft
    case asideRight
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "HEADER": self = .header
        case "FOOTER": self = .footer
        case "BODY": self = .body
        case "ASIDE_LEFT": self = .asideLeft
        case "ASIDE_RIGHT": self = .asideRight
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .header: return "HEADER"
        case .footer: return "FOOTER"
        case .body: return "BODY"
        case .asideLeft: return "ASIDE_LEFT"
        case .asideRight: return "ASIDE_RIGHT"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: BlockLocation, rhs: BlockLocation) -> Bool {
      switch (lhs, rhs) {
        case (.header, .header): return true
        case (.footer, .footer): return true
        case (.body, .body): return true
        case (.asideLeft, .asideLeft): return true
        case (.asideRight, .asideRight): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [BlockLocation] {
      return [
        .header,
        .footer,
        .body,
        .asideLeft,
        .asideRight,
      ]
    }
  }

  public enum ProductSlugKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case slug
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "SLUG": self = .slug
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .slug: return "SLUG"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ProductSlugKey, rhs: ProductSlugKey) -> Bool {
      switch (lhs, rhs) {
        case (.slug, .slug): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ProductSlugKey] {
      return [
        .slug,
      ]
    }
  }

  public enum ARPlatform: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case android
    case web
    case ios
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "ANDROID": self = .android
        case "WEB": self = .web
        case "IOS": self = .ios
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .android: return "ANDROID"
        case .web: return "WEB"
        case .ios: return "IOS"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ARPlatform, rhs: ARPlatform) -> Bool {
      switch (lhs, rhs) {
        case (.android, .android): return true
        case (.web, .web): return true
        case (.ios, .ios): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ARPlatform] {
      return [
        .android,
        .web,
        .ios,
      ]
    }
  }

  public struct ProductFilter: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - key
    ///   - value
    public init(key: ProductFilterKey, value: String) {
      graphQLMap = ["key": key, "value": value]
    }

    public var key: ProductFilterKey {
      get {
        return graphQLMap["key"] as! ProductFilterKey
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "key")
      }
    }

    public var value: String {
      get {
        return graphQLMap["value"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  public enum ProductFilterKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case title
    case slug
    case category
    case productState
    case auctionState
    case merchant
    case style
    case artist
    case brand
    case color
    case designer
    case label
    case material
    case tag
    case price
    case isInShowroom
    case expiryDate
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "TITLE": self = .title
        case "SLUG": self = .slug
        case "CATEGORY": self = .category
        case "PRODUCT_STATE": self = .productState
        case "AUCTION_STATE": self = .auctionState
        case "MERCHANT": self = .merchant
        case "STYLE": self = .style
        case "ARTIST": self = .artist
        case "BRAND": self = .brand
        case "COLOR": self = .color
        case "DESIGNER": self = .designer
        case "LABEL": self = .label
        case "MATERIAL": self = .material
        case "TAG": self = .tag
        case "PRICE": self = .price
        case "IS_IN_SHOWROOM": self = .isInShowroom
        case "EXPIRY_DATE": self = .expiryDate
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .title: return "TITLE"
        case .slug: return "SLUG"
        case .category: return "CATEGORY"
        case .productState: return "PRODUCT_STATE"
        case .auctionState: return "AUCTION_STATE"
        case .merchant: return "MERCHANT"
        case .style: return "STYLE"
        case .artist: return "ARTIST"
        case .brand: return "BRAND"
        case .color: return "COLOR"
        case .designer: return "DESIGNER"
        case .label: return "LABEL"
        case .material: return "MATERIAL"
        case .tag: return "TAG"
        case .price: return "PRICE"
        case .isInShowroom: return "IS_IN_SHOWROOM"
        case .expiryDate: return "EXPIRY_DATE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ProductFilterKey, rhs: ProductFilterKey) -> Bool {
      switch (lhs, rhs) {
        case (.title, .title): return true
        case (.slug, .slug): return true
        case (.category, .category): return true
        case (.productState, .productState): return true
        case (.auctionState, .auctionState): return true
        case (.merchant, .merchant): return true
        case (.style, .style): return true
        case (.artist, .artist): return true
        case (.brand, .brand): return true
        case (.color, .color): return true
        case (.designer, .designer): return true
        case (.label, .label): return true
        case (.material, .material): return true
        case (.tag, .tag): return true
        case (.price, .price): return true
        case (.isInShowroom, .isInShowroom): return true
        case (.expiryDate, .expiryDate): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ProductFilterKey] {
      return [
        .title,
        .slug,
        .category,
        .productState,
        .auctionState,
        .merchant,
        .style,
        .artist,
        .brand,
        .color,
        .designer,
        .label,
        .material,
        .tag,
        .price,
        .isInShowroom,
        .expiryDate,
      ]
    }
  }

  public enum ProductSort: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case `default`
    case created
    case updated
    case title
    case askingPrice
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "DEFAULT": self = .default
        case "CREATED": self = .created
        case "UPDATED": self = .updated
        case "TITLE": self = .title
        case "ASKING_PRICE": self = .askingPrice
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .default: return "DEFAULT"
        case .created: return "CREATED"
        case .updated: return "UPDATED"
        case .title: return "TITLE"
        case .askingPrice: return "ASKING_PRICE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ProductSort, rhs: ProductSort) -> Bool {
      switch (lhs, rhs) {
        case (.default, .default): return true
        case (.created, .created): return true
        case (.updated, .updated): return true
        case (.title, .title): return true
        case (.askingPrice, .askingPrice): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ProductSort] {
      return [
        .default,
        .created,
        .updated,
        .title,
        .askingPrice,
      ]
    }
  }

  public struct ReviewFilter: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - key
    ///   - value
    public init(key: ReviewFilterKey, value: String) {
      graphQLMap = ["key": key, "value": value]
    }

    public var key: ReviewFilterKey {
      get {
        return graphQLMap["key"] as! ReviewFilterKey
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "key")
      }
    }

    public var value: String {
      get {
        return graphQLMap["value"] as! String
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  public enum ReviewFilterKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case merchant
    case reviewer
    case score
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "MERCHANT": self = .merchant
        case "REVIEWER": self = .reviewer
        case "SCORE": self = .score
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .merchant: return "MERCHANT"
        case .reviewer: return "REVIEWER"
        case .score: return "SCORE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ReviewFilterKey, rhs: ReviewFilterKey) -> Bool {
      switch (lhs, rhs) {
        case (.merchant, .merchant): return true
        case (.reviewer, .reviewer): return true
        case (.score, .score): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ReviewFilterKey] {
      return [
        .merchant,
        .reviewer,
        .score,
      ]
    }
  }

  public enum ReviewSort: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case `default`
    case created
    case score
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "DEFAULT": self = .default
        case "CREATED": self = .created
        case "SCORE": self = .score
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .default: return "DEFAULT"
        case .created: return "CREATED"
        case .score: return "SCORE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ReviewSort, rhs: ReviewSort) -> Bool {
      switch (lhs, rhs) {
        case (.default, .default): return true
        case (.created, .created): return true
        case (.score, .score): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ReviewSort] {
      return [
        .default,
        .created,
        .score,
      ]
    }
  }

  public enum SearchSort: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case `default`
    case distance
    case price
    case created
    case title
    case popularity
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "DEFAULT": self = .default
        case "DISTANCE": self = .distance
        case "PRICE": self = .price
        case "CREATED": self = .created
        case "TITLE": self = .title
        case "POPULARITY": self = .popularity
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .default: return "DEFAULT"
        case .distance: return "DISTANCE"
        case .price: return "PRICE"
        case .created: return "CREATED"
        case .title: return "TITLE"
        case .popularity: return "POPULARITY"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: SearchSort, rhs: SearchSort) -> Bool {
      switch (lhs, rhs) {
        case (.default, .default): return true
        case (.distance, .distance): return true
        case (.price, .price): return true
        case (.created, .created): return true
        case (.title, .title): return true
        case (.popularity, .popularity): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [SearchSort] {
      return [
        .default,
        .distance,
        .price,
        .created,
        .title,
        .popularity,
      ]
    }
  }

  /// The SearchFacetKey enum represents the ability of attributes
  /// to facet upon.
  public enum SearchFacetKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case category
    case brand
    case style
    case material
    case color
    case country
    case label
    case quality
    case artSize
    case artSubject
    case artOrientation
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "CATEGORY": self = .category
        case "BRAND": self = .brand
        case "STYLE": self = .style
        case "MATERIAL": self = .material
        case "COLOR": self = .color
        case "COUNTRY": self = .country
        case "LABEL": self = .label
        case "QUALITY": self = .quality
        case "ART_SIZE": self = .artSize
        case "ART_SUBJECT": self = .artSubject
        case "ART_ORIENTATION": self = .artOrientation
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .category: return "CATEGORY"
        case .brand: return "BRAND"
        case .style: return "STYLE"
        case .material: return "MATERIAL"
        case .color: return "COLOR"
        case .country: return "COUNTRY"
        case .label: return "LABEL"
        case .quality: return "QUALITY"
        case .artSize: return "ART_SIZE"
        case .artSubject: return "ART_SUBJECT"
        case .artOrientation: return "ART_ORIENTATION"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: SearchFacetKey, rhs: SearchFacetKey) -> Bool {
      switch (lhs, rhs) {
        case (.category, .category): return true
        case (.brand, .brand): return true
        case (.style, .style): return true
        case (.material, .material): return true
        case (.color, .color): return true
        case (.country, .country): return true
        case (.label, .label): return true
        case (.quality, .quality): return true
        case (.artSize, .artSize): return true
        case (.artSubject, .artSubject): return true
        case (.artOrientation, .artOrientation): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [SearchFacetKey] {
      return [
        .category,
        .brand,
        .style,
        .material,
        .color,
        .country,
        .label,
        .quality,
        .artSize,
        .artSubject,
        .artOrientation,
      ]
    }
  }

  /// FilterInput is a key / value pair to build filters.
  /// 
  /// A SearchKey can only be defined once, but can have
  /// multiple values by joining the string with a ,
  /// 
  /// To filter on multiple values join the string with a comma
  /// {
  /// "key": "COLOR",
  /// "value": "red,white"
  /// }
  /// 
  /// To filter on ranges join the range with a comma (values
  /// may be omitted)
  /// {
  /// "key": "PRICE",
  /// "value": "0,100"
  /// }
  public struct FilterInput: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - key
    ///   - value
    public init(key: Swift.Optional<SearchFilterKey?> = nil, value: Swift.Optional<String?> = nil) {
      graphQLMap = ["key": key, "value": value]
    }

    public var key: Swift.Optional<SearchFilterKey?> {
      get {
        return graphQLMap["key"] as? Swift.Optional<SearchFilterKey?> ?? Swift.Optional<SearchFilterKey?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "key")
      }
    }

    public var value: Swift.Optional<String?> {
      get {
        return graphQLMap["value"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  /// The SearchFilterKey enum represents the ability of attributes
  /// to filter upon.
  public enum SearchFilterKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case category
    case brand
    case style
    case material
    case color
    case country
    case label
    case quality
    case artSize
    case artSubject
    case artOrientation
    case availability
    case inShowroom
    case allowBid
    case price
    case width
    case height
    case depth
    case seatHeight
    case numberOfItems
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "CATEGORY": self = .category
        case "BRAND": self = .brand
        case "STYLE": self = .style
        case "MATERIAL": self = .material
        case "COLOR": self = .color
        case "COUNTRY": self = .country
        case "LABEL": self = .label
        case "QUALITY": self = .quality
        case "ART_SIZE": self = .artSize
        case "ART_SUBJECT": self = .artSubject
        case "ART_ORIENTATION": self = .artOrientation
        case "AVAILABILITY": self = .availability
        case "IN_SHOWROOM": self = .inShowroom
        case "ALLOW_BID": self = .allowBid
        case "PRICE": self = .price
        case "WIDTH": self = .width
        case "HEIGHT": self = .height
        case "DEPTH": self = .depth
        case "SEAT_HEIGHT": self = .seatHeight
        case "NUMBER_OF_ITEMS": self = .numberOfItems
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .category: return "CATEGORY"
        case .brand: return "BRAND"
        case .style: return "STYLE"
        case .material: return "MATERIAL"
        case .color: return "COLOR"
        case .country: return "COUNTRY"
        case .label: return "LABEL"
        case .quality: return "QUALITY"
        case .artSize: return "ART_SIZE"
        case .artSubject: return "ART_SUBJECT"
        case .artOrientation: return "ART_ORIENTATION"
        case .availability: return "AVAILABILITY"
        case .inShowroom: return "IN_SHOWROOM"
        case .allowBid: return "ALLOW_BID"
        case .price: return "PRICE"
        case .width: return "WIDTH"
        case .height: return "HEIGHT"
        case .depth: return "DEPTH"
        case .seatHeight: return "SEAT_HEIGHT"
        case .numberOfItems: return "NUMBER_OF_ITEMS"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: SearchFilterKey, rhs: SearchFilterKey) -> Bool {
      switch (lhs, rhs) {
        case (.category, .category): return true
        case (.brand, .brand): return true
        case (.style, .style): return true
        case (.material, .material): return true
        case (.color, .color): return true
        case (.country, .country): return true
        case (.label, .label): return true
        case (.quality, .quality): return true
        case (.artSize, .artSize): return true
        case (.artSubject, .artSubject): return true
        case (.artOrientation, .artOrientation): return true
        case (.availability, .availability): return true
        case (.inShowroom, .inShowroom): return true
        case (.allowBid, .allowBid): return true
        case (.price, .price): return true
        case (.width, .width): return true
        case (.height, .height): return true
        case (.depth, .depth): return true
        case (.seatHeight, .seatHeight): return true
        case (.numberOfItems, .numberOfItems): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [SearchFilterKey] {
      return [
        .category,
        .brand,
        .style,
        .material,
        .color,
        .country,
        .label,
        .quality,
        .artSize,
        .artSubject,
        .artOrientation,
        .availability,
        .inShowroom,
        .allowBid,
        .price,
        .width,
        .height,
        .depth,
        .seatHeight,
        .numberOfItems,
      ]
    }
  }

  public enum ImageType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case `default`
    case thumbnail
    case cover
    case detail
    case avatar
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "DEFAULT": self = .default
        case "THUMBNAIL": self = .thumbnail
        case "COVER": self = .cover
        case "DETAIL": self = .detail
        case "AVATAR": self = .avatar
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .default: return "DEFAULT"
        case .thumbnail: return "THUMBNAIL"
        case .cover: return "COVER"
        case .detail: return "DETAIL"
        case .avatar: return "AVATAR"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ImageType, rhs: ImageType) -> Bool {
      switch (lhs, rhs) {
        case (.default, .default): return true
        case (.thumbnail, .thumbnail): return true
        case (.cover, .cover): return true
        case (.detail, .detail): return true
        case (.avatar, .avatar): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ImageType] {
      return [
        .default,
        .thumbnail,
        .cover,
        .detail,
        .avatar,
      ]
    }
  }

  public enum SearchType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case product
    case category
    case page
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "PRODUCT": self = .product
        case "CATEGORY": self = .category
        case "PAGE": self = .page
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .product: return "PRODUCT"
        case .category: return "CATEGORY"
        case .page: return "PAGE"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: SearchType, rhs: SearchType) -> Bool {
      switch (lhs, rhs) {
        case (.product, .product): return true
        case (.category, .category): return true
        case (.page, .page): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [SearchType] {
      return [
        .product,
        .category,
        .page,
      ]
    }
  }

  public struct MessageFilter: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - key
    ///   - value
    public init(key: Swift.Optional<MessageFilterKey?> = nil, value: Swift.Optional<String?> = nil) {
      graphQLMap = ["key": key, "value": value]
    }

    public var key: Swift.Optional<MessageFilterKey?> {
      get {
        return graphQLMap["key"] as? Swift.Optional<MessageFilterKey?> ?? Swift.Optional<MessageFilterKey?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "key")
      }
    }

    public var value: Swift.Optional<String?> {
      get {
        return graphQLMap["value"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  public enum MessageFilterKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case thread
    case sender
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "THREAD": self = .thread
        case "SENDER": self = .sender
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .thread: return "THREAD"
        case .sender: return "SENDER"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: MessageFilterKey, rhs: MessageFilterKey) -> Bool {
      switch (lhs, rhs) {
        case (.thread, .thread): return true
        case (.sender, .sender): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [MessageFilterKey] {
      return [
        .thread,
        .sender,
      ]
    }
  }

  public enum MessageSort: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case created
    case updated
    case sender
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "CREATED": self = .created
        case "UPDATED": self = .updated
        case "SENDER": self = .sender
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .created: return "CREATED"
        case .updated: return "UPDATED"
        case .sender: return "SENDER"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: MessageSort, rhs: MessageSort) -> Bool {
      switch (lhs, rhs) {
        case (.created, .created): return true
        case (.updated, .updated): return true
        case (.sender, .sender): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [MessageSort] {
      return [
        .created,
        .updated,
        .sender,
      ]
    }
  }

  public struct ThreadFilter: GraphQLMapConvertible {
    public var graphQLMap: GraphQLMap

    /// - Parameters:
    ///   - key
    ///   - value
    public init(key: Swift.Optional<ThreadFilterKey?> = nil, value: Swift.Optional<String?> = nil) {
      graphQLMap = ["key": key, "value": value]
    }

    public var key: Swift.Optional<ThreadFilterKey?> {
      get {
        return graphQLMap["key"] as? Swift.Optional<ThreadFilterKey?> ?? Swift.Optional<ThreadFilterKey?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "key")
      }
    }

    public var value: Swift.Optional<String?> {
      get {
        return graphQLMap["value"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
      }
      set {
        graphQLMap.updateValue(newValue, forKey: "value")
      }
    }
  }

  public enum ThreadFilterKey: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case thread
    case startedBy
    case item
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "THREAD": self = .thread
        case "STARTED_BY": self = .startedBy
        case "ITEM": self = .item
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .thread: return "THREAD"
        case .startedBy: return "STARTED_BY"
        case .item: return "ITEM"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ThreadFilterKey, rhs: ThreadFilterKey) -> Bool {
      switch (lhs, rhs) {
        case (.thread, .thread): return true
        case (.startedBy, .startedBy): return true
        case (.item, .item): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ThreadFilterKey] {
      return [
        .thread,
        .startedBy,
        .item,
      ]
    }
  }

  public enum ThreadSort: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case created
    case updated
    case startedBy
    case item
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "CREATED": self = .created
        case "UPDATED": self = .updated
        case "STARTED_BY": self = .startedBy
        case "ITEM": self = .item
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .created: return "CREATED"
        case .updated: return "UPDATED"
        case .startedBy: return "STARTED_BY"
        case .item: return "ITEM"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: ThreadSort, rhs: ThreadSort) -> Bool {
      switch (lhs, rhs) {
        case (.created, .created): return true
        case (.updated, .updated): return true
        case (.startedBy, .startedBy): return true
        case (.item, .item): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [ThreadSort] {
      return [
        .created,
        .updated,
        .startedBy,
        .item,
      ]
    }
  }

  public enum Lang: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
    public typealias RawValue = String
    case nl
    case en
    case fr
    case de
    case es
    /// Auto generated constant for unknown enum values
    case __unknown(RawValue)

    public init?(rawValue: RawValue) {
      switch rawValue {
        case "NL": self = .nl
        case "EN": self = .en
        case "FR": self = .fr
        case "DE": self = .de
        case "ES": self = .es
        default: self = .__unknown(rawValue)
      }
    }

    public var rawValue: RawValue {
      switch self {
        case .nl: return "NL"
        case .en: return "EN"
        case .fr: return "FR"
        case .de: return "DE"
        case .es: return "ES"
        case .__unknown(let value): return value
      }
    }

    public static func == (lhs: Lang, rhs: Lang) -> Bool {
      switch (lhs, rhs) {
        case (.nl, .nl): return true
        case (.en, .en): return true
        case (.fr, .fr): return true
        case (.de, .de): return true
        case (.es, .es): return true
        case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
        default: return false
      }
    }

    public static var allCases: [Lang] {
      return [
        .nl,
        .en,
        .fr,
        .de,
        .es,
      ]
    }
  }
}
