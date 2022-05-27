//
//  MockServiceProviders.swift
//  WhoppahTests
//
//  Created by Eddie Long on 01/11/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Apollo
import CoreLocation

@testable import Testing_Debug
@testable import WhoppahCore
@testable import WhoppahCoreNext
@testable import WhoppahModel
@testable import WhoppahDataStore

let env = AppEnvironment("test", host: "localhost", authHost: "localhost", graphHost: "localhost", mediaHost: "localhost", version: "1")

class MockMember: LegacyMember {
    var locale: GraphQL.Locale = .nlNl

    var id = UUID()
    var givenName: String = "Test"
    var familyName: String = "User"
    var email: String = "test@test.com"
    var dateJoined = DateTime()

    var merchant: [LegacyMerchant] = []
    var dob: Date? = Date()

    init(merchant: [LegacyMerchant]) {
        self.merchant = merchant
    }
}
class MockAddress: WhoppahCore.LegacyAddress {
    var id = UUID()
    var line1 = "123 Fake St"
    var line2: String? = "Somestraat"
    var postalCode = "1013 SC"
    var city = "Amsterdam"
    var state: String? { nil }
    var country = "NL"
    var point: Point? { nil }
}
let mockAddress = MockAddress()

class MockMerchantFee: WhoppahCore.Fee {
    var type: GraphQL.CalculationMethod { .percentage }
    var amount: Double { 20.0 }
}
private let merchantFee = MockMerchantFee()

class MockMerchant: LegacyMerchant {
    var currency = GraphQL.Currency.eur

    var address: [WhoppahCore.LegacyAddress]

    var primaryAddress: AddressBasic? { mockAddress as AddressBasic }

    var id = UUID()
    var name = "test company"
    var created = DateTime()
    var email: String? = "test@test.com"
    var phone: String? = "+31123456789"
    var type: GraphQL.MerchantType = .business
    var biography: String? = "some spiel"
    var vatId: String? = "1234567"
    var taxId: String? = "1234567899"
    var avatarImage: WhoppahCore.Image? { nil }
    var coverImage: WhoppahCore.Image? { nil }
    var bank: WhoppahCore.BankAccount? { nil }
    var fees: WhoppahCore.Fee? { merchantFee }
    var isVerified: Bool  = true
    var businessName: String? = "Some business"
    var url: String? = "https://www.whoppah.com"

    private(set) var member = [LegacyMember]()

    init(type: GraphQL.MerchantType) {
        self.type = type
        self.address = [mockAddress]
    }

    func add(theMember: LegacyMember) {
        member.append(theMember)
    }
}

var mockMember = MockMember(merchant: [MockMerchant(type: .business)])
let mockMerchant = mockMember.mainMerchant as! MockMerchant

var mockIndividualMember = MockMember(merchant: [MockMerchant(type: .individual)])
let mockIndividualMerchant = mockIndividualMember.mainMerchant as! MockMerchant

class MockCancellable: WhoppahCore.ProgressCancellable {
    func didSendBytes(forUrl url: URL, bytesWritten _: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {}
    
    func cancel() {}
    var progress: Observable<HTTPProgress> { Observable.just(HTTPProgress(id: UUID(), request: URL(string: "https://test.com")!, fraction: 0.0, totalDownloaded: 0, totalSizeBytes: 0)) }
}
let mockCancellable = MockCancellable()

class MockHttpService: HTTPServiceInterface {
    required init() {}

    @discardableResult
    func execute<T: Codable>(request: HTTPRequestable, retryNumber: Int, completion: @escaping (Result<T, Error>) -> Void) -> WhoppahCore.ProgressCancellable { mockCancellable }

    @discardableResult
    func upload<T: Codable>(request: HTTPRequestable, retryNumber: Int, completion: @escaping (Result<T, Error>) -> Void) -> WhoppahCore.ProgressCancellable { mockCancellable }
}

//class MockAuthService: AuthService {
//    var token = "token"
//    var userID = UUID()
//
//    var loginEmail: String?
//    var loginPassword: String?
//
//    func logIn(email: String,
//               password: String,
//               completion handler: @escaping (Result<UserAccessToken, Error>) -> Void) {
//        loginEmail = email
//        loginPassword = password
//        handler(.success(UserAccessToken(token: token, userID: userID, type: .token, isMerchant: false)))
//    }
//
//    var signupEmail: String?
//    var signupPassword: String?
//    var signupIsMerchant: Bool?
//    func signUp(email: String,
//                password: String,
//                isMerchant: Bool,
//                completion handler: @escaping (Result<UserAccessToken, Error>) -> Void) {
//        signupEmail = email
//        signupPassword = password
//        signupIsMerchant = isMerchant
//        handler(.success(UserAccessToken(token: token, userID: userID, type: .token, isMerchant: false)))
//    }
//
//    var authorizeSocialNetwork: SocialNetwork?
//    func authorize(via network: SocialNetwork,
//                   withVC vc: UIViewController,
//                   mode: SocialAuthMode,
//                   completion handler: @escaping (Result<UserAccessToken, Error>?) -> Void) {
//        authorizeSocialNetwork = network
//        handler(.success(UserAccessToken(token: token, userID: userID, type: .token, isMerchant: false)))
//    }
//
//    func logOut(completion handler: @escaping (Result<Void, Error>) -> Void) {}
//
//    func changePassword(oldPassword: String,
//                        newPassword: String,
//                        repeatNewPassword: String,
//                        completion handler: @escaping (Result<HTTPMessage, Error>) -> Void) {}
//
//    func resetPassword(email: String,
//                       completion handler: @escaping (Result<HTTPMessage, Error>) -> Void) {}
//
//    func setNewPassword(userID: String,
//                        token: String,
//                        password: String,
//                        completion handler: @escaping (Result<HTTPMessage, Error>) -> Void) {}
//}

class MockUserService: WhoppahCore.LegacyUserService {
    var requiresLogout: Bool { true }
    
    var current: LegacyMember? {
        didSet {
            active.onNext(current)
            isLoggedIn = current != nil
            accessToken = current != nil ? UUID().uuidString : nil
        }
    }
    var active = BehaviorSubject<LegacyMember?>(value: nil)

    var isLoggedIn: Bool = false
    var hasCompletedProfile: Bool = false
    func getActive() {}

    // Token
    var accessToken: String? {
        didSet {
            token.onNext(accessToken)
        }
    }

    var token = BehaviorSubject<String?>(value: nil)
    func onTokenAcquired(accessToken: String, type: UserAccessTokenType) -> Observable<LegacyMember> { return Observable.just(mockMember) }

    var memberInput: WhoppahCore.LegacyMemberInput?
    func update(id: UUID, member: WhoppahCore.LegacyMemberInput) -> Observable<UUID> {
        self.memberInput = member
        return Observable.just(UUID())
    }

    // Notification Settings
    func getNotificationSettings(completion handler: @escaping (Swift.Result<NotificationSettings, Error>) -> Void) {

    }

    func updateNotificationSettings(settings: NotificationSettings, completion handler: @escaping (Swift.Result<NotificationSettings, Error>) -> Void) {

    }

    // Searches
    func getMySearches() -> Observable<[GraphQL.SavedSearchesQuery.Data.SavedSearch.Item]> { Observable.just([]) }
    func saveSearch(search: GraphQL.SavedSearchInput) -> Observable<UUID?> { Observable.just(UUID()) }
    func deleteSearch(id: UUID) -> Observable<Void> { return Observable.just(()) }

    func sendQuestionForSupport(text: String) -> Observable<Void> { Observable.just(())}
}

class MockPrice: WhoppahCore.Price {
    var currency: GraphQL.Currency = .eur
    var amount = 0.0

    init(amount: Double) {
        self.amount = amount
    }
}

class MockBid: WhoppahCore.Bid {
    var id = UUID()
    var price: WhoppahCore.Price = MockPrice(amount: 100.0)
    var state = GraphQL.BidState.new
}

class MockAuctionService: AuctionService {
    func withdrawBid(id: UUID) -> Observable<UUID> {
        return Observable.just(bid.id)
    }

    var bid = MockBid()
    func createBid(productId: UUID, auctionId: UUID, amount: WhoppahCore.PriceInput, createThread: Bool) -> Observable<WhoppahCore.Bid> {
        return Observable.just(bid)
    }

    func createCounterBid(productId: UUID, auctionId: UUID, amount: WhoppahCore.PriceInput, buyerId: UUID) -> Observable<WhoppahCore.Bid> {
        return Observable.just(bid)
    }

    func acceptBid(id: UUID) -> Observable<WhoppahCore.Bid> {
        return Observable.just(bid)
    }
    func rejectBid(id: UUID) -> Observable<WhoppahCore.Bid> {
        return Observable.just(bid)
    }
}

class MockLanguageTranslationService: LanguageTranslationService {
    func translate(strings: [String], language: GraphQL.Lang) -> Observable<LegacyTranslationResponse?> {
        return Observable.just(nil)
    }
}

class MockLocationService: LocationService {
    // MARK: - Properties
     var currentLocation: CLLocation? { nil }

     // MARK: - Geocoding
    func address(by location: CLLocation, completion: @escaping (String?, CLPlacemark?, Error?) -> Void) {}
}

class MockAdService: ADsService {
    func viewAd(id: UUID) -> Observable<Void> {
        return Observable.just(())
    }

    func deleteAd(id: UUID, state: GraphQL.ProductState, reason: GraphQL.ProductWithdrawReason?) -> Observable<Void> {
        return Observable.just(())
    }
    func repostAd(id: UUID) -> Observable<GraphQL.ProductState?> {
        return Observable.just(.accepted)
    }
    func publishAd(id: UUID) -> Observable<GraphQL.ProductState?> {
        return Observable.just(.accepted)
    }
    func canWithdrawAd(state: GraphQL.ProductState) -> Bool {
        return false
    }

    // MARK: - Report
    func reportItem(itemId: UUID, reason: GraphQL.AbuseReportReason, comment: String) -> Observable<Void> {
        return Observable.just(())
    }
}

class MockADCreator: ADCreator {
    func validate(step: AdValidationSequenceStep?) -> AdValidationError {
        return .none
    }

    // MARK: - Properties
    var template: AdTemplate?
    var mediaManager: AdMediaManager!

    var mode: AdCreationMode = .create(data: nil)

    // MARK: -
    func startCreating() {}
    func startEditing(_ template: AdTemplate) {}

    func finish() -> Observable<AdCreationResult> { Observable.just(.created) }
    func saveDraft() -> Observable<AdCreationResult> { Observable.just(.created) }
    func validate() -> AdValidationError { return .none }
    func cancelPendingUploads() {}
    func cancelCreating() {}
    func hasCachedItem(forKey: String) -> Bool { return false }
    init() {
        self.mediaManager = AdMediaManager()
    }
}

class MockCacheService: CacheService {
    var colors = [WhoppahCore.Color]()
    var colorRepo: AdAttributeRepository?
    var categoryRepo: WhoppahCore.CategoryRepository?
    var brandRepo: AdAttributeRepository?
    var artistRepo: AdAttributeRepository?
    var designerRepo: AdAttributeRepository?
    var materialRepo: AdAttributeRepository?
}

class MockMediaCacheService: MediaCacheService {
    enum FetchError: Error { case unknown }
    var cacheKey: String = ""
    var items = Set<String>()
    var fetchImage: UIImage?

    func loadVideo(video: WhoppahCore.Video, expiry: TimeInterval?, completion: @escaping ((URL?) -> Void)) {

    }

    func hasCachedItem(identifier: String) -> Bool { items.contains(identifier) }

    func fetchImage(identifier: String, url: URL?, expirySeconds: TimeInterval?, completion: @escaping ImageFetchCompletion) {
        guard items.contains(identifier) else {
            return completion(.failure(FetchError.unknown))
        }
        if let image = fetchImage {
            completion(.success(image))
        } else {
            completion(.failure(FetchError.unknown))
        }
    }

    func fetchData(identifier: String, url: URL?, expirySeconds: TimeInterval?, completion: @escaping DataFetchCompletion) {}
    func saveData(identifier: String, data: Data, expirySeconds: TimeInterval?) {
        items.insert(identifier)
    }
    func cancelPendingDownloads() {}
    func removeData(identifier: String) {
        items.remove(identifier)
    }
    func getCacheKey(identifier: String, type: CacheMediaType) -> String { identifier }
}

class MockRecognitionService: RecognitionService {
    func uploadImage(data: Data) -> Observable<RecognitionImageUploadState> {
        return Observable.just(RecognitionImageUploadState.complete(result: Recognition()))
    }
}

class MockPermissionService: PermissionsService {
    // MARK: - Properties
    var isCameraAccessGranted: Bool = true
    var isLocationAccessGranted: Bool = true

    // MARK: - Request Access
    func requestCameraAccess(completionHandler: @escaping (Bool) -> Void) {}
    func requestLocationAccess() {}
    func requestPermissionsIfApplicable() {}
}

class MockMediaService: MediaService {
    func uploadImage(data: Data, contentType: GraphQL.ContentType, objectId: UUID?, type: String?, position: Int?) -> Observable<ImageMediaUploadState> { Observable.just(ImageMediaUploadState.complete(result: UUID())) }
    func uploadVideo(data: Data, contentType: GraphQL.ContentType, objectId: UUID?, position: Int?) -> Observable<ImageMediaUploadState> { Observable.just(ImageMediaUploadState.complete(result: UUID()))
    }
    func linkMediaToProduct(mediaId: UUID, objectId: UUID, position: Int) -> Observable<Void> { Observable.just(()) }
        func deleteProductMedia(id: UUID, objectId: UUID) -> Observable<Void> { Observable.just(()) }
    func deleteMerchantMedia(id: UUID, type: MerchantImageType, objectId: UUID) -> Observable<Void> { Observable.just(()) }
}

class MockChatService: ChatService {
    func sendChatMessage(id: UUID, text: String) -> Observable<GraphQL.SendMessageMutation.Data.SendMessage> {
        Observable.just(GraphQL.SendMessageMutation.Data.SendMessage(id: UUID(), created: DateTime(), sender: GraphQL.SendMessageMutation.Data.SendMessage.Sender(id: UUID(), givenName: "Test", familyName: "User"), merchant: GraphQL.SendMessageMutation.Data.SendMessage.Merchant(id: UUID(), name: "Merchant"), subscriber: GraphQL.SendMessageMutation.Data.SendMessage.Subscriber(id: UUID(), role: .subscriber), unread: true))
    }
    func sendProductMessage(id: UUID, body: String) -> Observable<UUID?> {
        Observable.just(nil)
    }
    func getChatThread(filter: WhoppahCore.ThreadFilterKey, id: UUID) -> Observable<UUID?> { Observable.just(nil) }

    // MARK: -
    var unread: Driver<Int> {
        _unread.asDriver()
    }
    var _unread = BehaviorRelay<Int>(value: 0)

    func updateUnreadCount() {}
}

class MockPushNotificationService: PushNotificationsService {
    var openedThreadID: UUID?
    var fcmToken: String?
    func registerForRemoteNotifications() {}

    // TODO: Move to the permissions service
    func requestNotificationPermission(completion: @escaping ((Bool) -> Void)) {}
    func checkNotificationPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {}
}

class MockSearchService: SearchService {
    var searchText: String? = ""
    var minPrice: Money? = 0.0
    var maxPrice: Money? = 0.0
    var address: LegacyAddressInput?
    var postcode: Observable<String?> = Observable.just(nil)
    var radiusKilometres: Int?
    var quality: GraphQL.ProductQuality?
    var categories = Set<FilterAttribute>()
    var brands: [FilterAttribute] = []
    var styles: [FilterAttribute] = []
    var artists: [FilterAttribute] = []
    var designers: [FilterAttribute] = []
    var materials: [FilterAttribute] = []
    var colors: [FilterAttribute] = []
    var countries: [FilterAttribute] = []
    var arReady: Bool?
    var filterInput: GraphQL.SearchFilterInput {
        GraphQL.SearchFilterInput()
    }
    var filtersCount: Int = 0

    // MARK: -
    func removeAllFilters() {}

    func setFrom(search: GraphQL.SavedSearchesQuery.Data.SavedSearch.Item) {}

    func toSavedSearch() -> GraphQL.SavedSearchInput { GraphQL.SavedSearchInput() }
}

class MockPaymentService: PaymentService {
    func getEphemeralKey(sdkVersion: String) -> Observable<JSON> {
        return Observable.just(JSON())
    }
    // Result is order.id
    func createFeedback(orderId: UUID, received: Bool, text: String?) -> Observable<UUID> {
        Observable.just(UUID())
    }

    func createOrder(input: GraphQL.OrderInput) -> Observable<GraphQL.CreateOrderMutation.Data.CreateOrder> {
        
        return Observable.just(GraphQL.CreateOrderMutation.Data.CreateOrder(id: UUID(), state: .accepted, expiryDate: DateTime(), purchaseType: GraphQL.PurchaseType.bid, deliveryMethod: GraphQL.DeliveryMethod.delivery, currency: GraphQL.Currency.eur, subtotalInclVat: 0, subtotalExclVat: 0, shippingInclVat: 0, shippingExclVat: 0, paymentInclVat: 0, paymentExclVat: 0, discountInclVat: 0, discountExclVat: 0, totalInclVat: 0, totalExclVat: 0, feeInclVat: 0, feeExclVat: 0, payout: 0, product: GraphQL.CreateOrderMutation.Data.CreateOrder.Product(id: UUID(), state: .accepted, merchant: GraphQL.CreateOrderMutation.Data.CreateOrder.Product.Merchant(id: UUID(), name: ""), auction: nil)))
    }

    func createPayment(orderId: UUID,
                            paymentMethod: GraphQL.PaymentMethod,
                            paymentMethodId: String?,
                            deliveryMethodId: GraphQL.DeliveryMethod?,
                            shippingMethodId: UUID?,
                            addressID: UUID?,
                            buyerProtection: Bool) -> Observable<GraphQL.CreatePaymentMutation.Data.CreatePayment> {
        return Observable.just(GraphQL.CreatePaymentMutation.Data.CreatePayment(id: UUID(), bid: nil, state: .new, expiryDate: DateTime(), endDate: nil, deliveryMethod: .delivery, shippingMethod: nil, currency: .eur, subtotalInclVat: 0, subtotalExclVat: 0, shippingInclVat: 0, shippingExclVat: 0, paymentInclVat: 0, paymentExclVat: 0, discountInclVat: 0, discountExclVat: 0, totalInclVat: 0, totalExclVat: 0, feeInclVat: 0, feeExclVat: 0, payout: 0, stripePayment: nil, product: GraphQL.CreatePaymentMutation.Data.CreatePayment.Product(id: UUID(), state: .accepted, merchant: GraphQL.CreatePaymentMutation.Data.CreatePayment.Product.Merchant(id: UUID(), name: ""))))
    }

    func checkOrderStatus(orderId: UUID) -> Observable<GraphQL.CheckOrderPaymentMutation.Data.CheckOrderPayment> {
        return Observable.just(GraphQL.CheckOrderPaymentMutation.Data.CheckOrderPayment(id: UUID(), state: .accepted))
    }

    func createShipment(orderId: UUID, trackingCode: String, returnsCode: String?) -> Observable<UUID> {
        Observable.just(UUID())
    }
}

class MockMerchantService: MerchantService {
    func get(id: UUID) -> Observable<LegacyMerchantOther> { Observable.just(mockMerchant) }

    var merchantInput: LegacyMerchantInput?
    func update(_ merchant: LegacyMerchantInput) -> Observable<UUID> {
        merchantInput = merchant
        return Observable.just(mockMerchant.id)
    }
    func updateBankAccount(id: UUID, input: GraphQL.BankAccountInput) -> Observable<UUID> { Observable.just(mockMerchant.id) }

    // Images
    func setAvatar(id: UUID, data: Data, existing: UUID?) -> Observable<UUID> { Observable.just(UUID()) }
    func setCover(id: UUID, data: Data, existing: UUID?) -> Observable<UUID> { Observable.just(UUID()) }
    func removeMedia(id: UUID, type: MerchantImageType, merchantId: UUID) -> Observable<Void> { Observable.just(()) }

    // Reporting
    func report(id: UUID, reason: GraphQL.AbuseReportReason, comment: String) -> Observable<Void> { Observable.just(()) }

    // Addresses
    var addAddressInput: LegacyAddressInput?
    func addAddress(id: UUID, address: LegacyAddressInput) -> Observable<WhoppahCore.LegacyAddress> {
        addAddressInput = address
        return Observable.just(mockAddress)
    }
    func removeAddress(id: UUID, addressId: UUID) -> Observable<Void> { Observable.just(()) }
    var updateAddressInput: LegacyAddressInput?
    func updateAddress(id: UUID, address: LegacyAddressInput) -> Observable<WhoppahCore.LegacyAddress> {
        updateAddressInput = address
        return Observable.just(mockAddress)
    }
}

class MockFeatureService: FeatureService {
    var sslPinningEnabled = false
}

class MockAppConfigService: AppConfigurationProvider {
    var environment: AppEnvironment { env }
    var sslCertFile: String? { nil }
}

class MockApolloService: WhoppahCore.ApolloService {
    func watch<Query: GraphQLQuery>(query: Query, cache: CachePolicy, callback: @escaping ((Swift.Result<Query.Data, Error>) -> Void)) -> GraphQLQueryWatcher<Query> {
        return GraphQLQueryWatcher<Query>(client: ApolloClient(url: URL(string: "https://google.com")!), query: query) { _ in }
    }

    func fetch<Query: GraphQLQuery>(query: Query, cache: CachePolicy) -> Observable<GraphQLResult<Query.Data>> {
        let data = GraphQLResult<Query.Data>.init(data: nil, extensions: nil, errors: [], source: .server, dependentKeys: nil)
        return Observable.just(data)
    }
    func apply<MutationQuery: GraphQLMutation>(mutation: MutationQuery) -> Observable<GraphQLResult<MutationQuery.Data>> {
        let data = GraphQLResult<MutationQuery.Data>.init(data: nil, extensions: nil, errors: [], source: .server, dependentKeys: nil)
        return Observable.just(data)
    }
    func apply<MutationQuery: GraphQLMutation, Query: GraphQLQuery>(mutation: MutationQuery,
                                                                    query: Query?,
                                                                    storeTransaction: ((GraphQLResult<MutationQuery.Data>,
        inout Query.Data) -> Void)?) -> Observable<GraphQLResult<MutationQuery.Data>> {
        let data = GraphQLResult<MutationQuery.Data>.init(data: nil, extensions: nil, errors: [], source: .server, dependentKeys: nil)
        return Observable.just(data)
    }

    func updateCache<Query: GraphQLQuery>(query: Query, transactionCallback: @escaping ((inout Query.Data) -> Void)) {}
}

class MockEventTrackingService: EventTrackingService {
    func trackAddedToCart(product: WhoppahModel.Product) {}
    
    func trackAddShippingInfo() {}
    
    func trackAddPaymentInfo() {}
    
    func trackBeginCheckout(source: CheckoutSource) {}
    
    func trackPurchase() {}
    
    func trackAdViewed(product: WhoppahModel.Product) {}
    
    func trackPhotoViewed(product: WhoppahModel.Product, photoID: UUID, isFullScreen: Bool) {}
    
    func trackVideoViewed(product: WhoppahModel.Product, isFullScreen: Bool, page: PageSource) {}
    
    func trackAdDetailsBuyNow(product: WhoppahModel.Product, categoryText: String, source: BuyNowSource) {}
    
    func trackAdDetailsBid(product: WhoppahModel.Product, categoryText: String, maxBid: WhoppahModel.Price?, source: BidSource) {}
    
    func trackBid(product: WhoppahModel.Product, bid: WhoppahModel.Price, source: BidSource) {}
    
    func trackFavouriteStatusChanged(product: WhoppahModel.Product, status: Bool) {}
    
    func trackLaunchedARView(product: WhoppahModel.Product) {}
    
    func trackDismissedARView(product: WhoppahModel.Product, timeSpentSecs: Double) {}
    
    
    var ad: AdEvents = MockAdEvents()
    var filter: FilterEvents = MockFilterEvents()
    var searchResults: SearchResultsEvents = MockSearchResultsEvents()
    var home: HomeEvents = MockHomeEvents()
    var createAd: CreateAdEvents = MockCreateAdEvents()
    var usp: USPEvents = MockUSPEvents()
    var searchByPhoto: SearchByPhotoEvents = MockSearchByPhotoEvents()
    var appReview: AppReviewEvents = MockAppReviewEvents()

    func trackLogIn(authMethod: AuthenticationMethod, email: String?, userID: String, dataJoined: String) {}

    func trackEmailActivation() {}

    func trackButtonClick(key: String, screen: String) {}

    func trackSignUpStart() {}
    
    func trackSignUpSuccess() {}

    func trackProfileCompleted(isPhotoAdded: Bool, countryNumber: String?, phoneNumber: String?, postalCode: String?, country: String?) {}
    func trackListStyleClicked(style: ListPresentation, page: PageSource) {}

    func trackARLaunchClicked(ad: WhoppahCore.Product, page: PageSource) {}

    func trackAdViewed(ad: ProductDetails) {}
    func trackPhotoViewed(ad: ProductDetails, photoID: UUID, isFullScreen: Bool) {}

    func trackVideoViewed(ad: WhoppahCore.Product, isFullScreen: Bool, page: PageSource) {}

    func trackVideoViewed(ad: ProductDetails, isFullScreen: Bool, page: PageSource) {}

    func trackClickProduct(ad: WhoppahCore.Product, page: PageSource) {}
    func trackClickProduct(ad: WhoppahModel.ProductTileItem, page: PageSource) {}

    func trackAdDetailsBuyNow(ad: ProductDetails, categoryText: String, source: BuyNowSource) {}
    func trackBuyNowConfirmDialogClicked(adID: Int, price: Money) {}

    func trackAdDetailsBid(ad: ProductDetails, categoryText: String, maxBid: Money?, source: BidSource) {}
    func trackBid(ad: ProductDetails, bid: Money, source: BidSource) {}

    // swiftlint:disable function_parameter_count
    func trackPay(adID: UUID, productCost: Money, transportType: TransportType, shippingCost: Money?, transactionCost: Money?, whoppahFee: Money?, totalCheckoutPrice: Money, isBuyNow: Bool) {}
    
    func trackPlaceAd(userID: UUID, price: Money?, category: String?, isBrand: Bool, deliveryType: String?, photosCount: Int, hasVideo: Bool) {}

    func trackAdUploaded(adID: UUID, userID: UUID, price: Money?, category: String, isBrand: Bool, deliveryType: String, photosCount: Int, hasVideo: Bool) {}
    func trackFavouriteStatusChanged(ad: WhoppahCore.Product, status: Bool) {}

    func trackFavouriteStatusChanged(ad: ProductDetails, status: Bool) {}
    func trackFavoritesClicked() {}

    func trackMyWhoppahClicked() {}
    func trackChatsClicked() {}
    func trackMyIncomeClicked() {}

    func trackSendMessage(receiverID: UUID, adID: UUID, conversationID: UUID, counterBid: Double?, textMessage: Bool, isPDPQuestion: Bool) {}

    func trackBidStatusChanged(receiverID: UUID, adID: UUID, conversationID: UUID, bidValue: Int, bidStatus: String) {}
    // swiftlint:enable function_parameter_count
}

class MockAdEvents: AdEvents {
    func trackShareClicked(product: WhoppahModel.Product) {}
    func trackShareCompleted(product: WhoppahModel.Product, shareNetwork: String) {}
    func trackShareClicked(ad: ProductDetails) {}
    func trackShareCompleted(ad: ProductDetails, shareNetwork: String) {}
    func trackARLaunchFromButton(ad: ProductDetails) {}
    func trackARLaunchFromBanner(ad: ProductDetails) {}
    func trackShowAllSimilarItems(ad: ProductDetails) {}
    func trackSafeShoppingBannerClicked() {}
}

class MockFilterEvents: FilterEvents {
    func trackFilterClicked(provider: SearchService) {}
}

class MockSearchResultsEvents: SearchResultsEvents {
    func trackSortClicked(type: SearchSort?, order: Ordering?) {}
    func trackFilterClicked() {}
    func trackSearchScrolled(scrollDepth: Int) {}
    func trackMapClicked() {}
}

class MockHomeEvents: HomeEvents {

    func trackCategoryClicked(category: String) {}
    func trackCategoryMenuClicked(category: String, product: String?) {}
    func trackClickedLook(name: String, page: PageSource) {}
    func trackClickedNewAdsAll() {}
    func trackClickedAllArtUnder1000() {}
    func trackClickedSafeShoppingBanner() {}
    func trackClickedUSPBanner(blockName: String) {}
    func trackClickedSearchByPhoto() {}
    func trackSearchPerformed(text: String) {}
    func trackUSPCarouselScrolled(direction: String, blockName: String) {}
    func trackTrendClicked(name: String) {}
    func trackHighlightClicked(name: String) {}
    func trackRandomScrolled(scrollDepth: Int) {}
}

class MockSearchByPhotoEvents: SearchByPhotoEvents {

    func trackClickedCamera() {}
    func trackClickedGallery() {}
    func trackClickedClose() {}
}

// Create ad
class MockCreateAdEvents: CreateAdEvents {
    func trackTipsAbandon() {}
    func trackTipsPage1() {}
    func trackTipsPage2() {}
    
    func trackStartAdCreating(clickedPlaceAd: Bool) {}
    func trackStartCreatingAd() {}
    func trackCreateFirstAd() {}
    func trackCreateAnotherAdInMyAds() {}
    func trackCreateAnotherAdInDelete() {}
    func trackCreateAnotherAdInConfirmation() {}
    func trackCancelAdCreation() {}
    
    func trackFurnitureCategoryClicked() {}
    func trackLightingCategoryClicked() {}
    func trackArtCategoryClicked() {}
    func trackDecorationCategoryClicked() {}
    
    func trackMaterialClicked() {}
    func trackMaterialSaveClicked(materials: [AdAttribute]) {}

    func trackCancelCameraScreen() {}
    func trackBackPressedAdCreation() {}
    func trackCapturePhotoClicked() {}
    func trackCaptureVideoStart() {}
    func trackCaptureVideoStop() {}
    func trackPhotoTooSmallError(sizeBytes: Int) {}
    func trackVideoTooShort(lengthSeconds: Int) {}
    func trackTakeNewPhotosClicked() {}
    func trackChooseExistingPhotosClicked() {}
    func trackCreateVideoClicked() {}

    func trackImageAdded(atPosition position: Int) {}
    func trackCategoryClicked() {}

    func trackCategorySelected(category: String?, productType: String?, product: String?) {}
    func trackBrandClicked() {}
    func trackArtistClicked() {}
    func trackDesignerClicked() {}

    func trackBrandSaveClicked(brand: String) {}
    func trackArtistSaveClicked(artist: String) {}
    func trackDesignerSaveClicked(designer: String) {}
    
    func trackDescriptionNextClicked() {}
    func trackPhotoNextClicked() {}
    func trackVideoNextClicked() {}
    func trackDetailsNextClicked() {}
    func trackPriceNextClicked(price: Money) {}
    func trackDeliveryNextClicked(location: Point?, deliveryType: String, cost: Money) {}
    
    func trackSummaryAdjustPhotos() {}
    func trackSummaryAdjustVideo() {}
    func trackSummaryAdjustDescription() {}
    func trackSummaryAdjustDetails() {}
    func trackSummaryAdjustPrice() {}
    func trackSummaryAdjustDelivery() {}

    func trackDraftSave() {}
    func trackDraftResume() {}
}

class MockAppReviewEvents: AppReviewEvents {

    func trackSatisfiedClicked() {}
    func trackNotSatisfiedClicked() {}
    func trackAbandonReview() {}
}

class MockUSPEvents: USPEvents {

    func makeAdClicked() {}
    func shopNowClicked() {}
    func backClicked() {}
}

class MockStoreService: StoreService {
    func checkForUpdate(completion: @escaping (Result<AppUpdateRequirement, Error>) -> Void) {}
}
