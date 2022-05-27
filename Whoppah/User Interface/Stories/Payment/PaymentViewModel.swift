//
//  PaymentViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 13/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Stripe
import WhoppahCore
import WhoppahCoreNext
import FirebaseAnalytics
import Resolver
import WhoppahDataStore

protocol PaymentDelegate: AnyObject {
    func didFinishTransaction(input: PaymentInput, successful: Bool)
}

private protocol OrderStripePayment {
    var paymentMethod: String { get }
    var paymentIntentId: String? { get }
    var clientSecretId: String { get }
    var paymentMethodId: String? { get }
    var paymentSourceId: String? { get }
}

private protocol OrderInterface {
    var id: UUID { get }
    var state: GraphQL.OrderState { get }
    var merchantName: String { get }
    var payment: OrderStripePayment? { get }
    var productId: UUID { get }
    var bidAmount: Double? { get }
    var totalInclVat: Double { get }
    var buyerFeeInclVat: Double { get }
    var shippingCost: Double { get }
    var deliveryMethod: GraphQL.DeliveryMethod { get }
    var currency: GraphQL.Currency { get }
    var purchaseTypeInfo: String { get }
    var shippingMethodInfo: String { get }
}

extension GraphQL.CreateOrderMutation.Data.CreateOrder.StripePayment: OrderStripePayment {}
extension GraphQL.CreateOrderMutation.Data.CreateOrder: OrderInterface {
    var merchantName: String { product.merchant.name }
    fileprivate var payment: OrderStripePayment? { stripePayment }
    var productId: UUID { product.id }
    var bidAmount: Double? { bid?.amount.amount }
    var buyerFeeInclVat: Double { paymentInclVat }
    var shippingCost: Double { shippingInclVat }
    var purchaseTypeInfo: String { "" }
    var shippingMethodInfo: String { "" }
}

extension GraphQL.OrderQuery.Data.Order.StripePayment: OrderStripePayment {}
extension GraphQL.OrderQuery.Data.Order: OrderInterface {
    var merchantName: String { product.merchant.name }
    fileprivate var payment: OrderStripePayment? { stripePayment }
    var productId: UUID { product.id }
    var bidAmount: Double? { bid?.amount.amount }
    var buyerFeeInclVat: Double { paymentInclVat }
    var shippingCost: Double { shippingInclVat }
    var purchaseTypeInfo: String { purchaseType.rawValue }
    var shippingMethodInfo: String { shippingMethod?.slug ?? "" }
}

extension GraphQL.CreatePaymentMutation.Data.CreatePayment.StripePayment: OrderStripePayment {}
extension GraphQL.CreatePaymentMutation.Data.CreatePayment: OrderInterface {
    var merchantName: String { product.merchant.name }
    fileprivate var payment: OrderStripePayment? { stripePayment }
    var productId: UUID { product.id }
    var bidAmount: Double? { bid?.amount.amount }
    var buyerFeeInclVat: Double { paymentInclVat }
    var shippingCost: Double { shippingInclVat }
    var purchaseTypeInfo: String { "" }
    var shippingMethodInfo: String { "" }
}

// It's very likely there are going to change
// Rather than changing everywhere I'm wrapping this in a struct
// And can change in 1/2 places
struct PaymentInput {
    let productId: UUID
    let bidId: UUID
    let orderId: UUID?
}

typealias MessageBid = GraphQL.GetMessagesQuery.Data.Message.Item.Item.AsBid

private let threadIdKey = "thread_id"
private let orderIdKey = "order_id"
private let sourceIdKey = "source_id"
private let clientSecretKey = "client_secret"
private let attemptNumberKey = "attempt_number"
// Arbitrary number of poll attempts before bailing out
private let maxPollAttempts = 3

class PaymentViewModel: NSObject {
    struct PaymentProvider: Hashable {
        let title: String
        let type: GraphQL.PaymentMethod
        var reusable: Bool = false

        func hash(into hasher: inout Hasher) {
            hasher.combine(type.hashValue)
        }
    }

    let coordinator: PaymentCoordinator
    let customerContext: STPCustomerContext
    let paymentSources: [PaymentProvider]
    @Injected private var shippingMethodsRepo: LegacyShippingMethodsRepository
    @Injected private var crashReporter: CrashReporter
    @Injected private var userService: WhoppahCore.LegacyUserService
    @Injected private var merchantService: MerchantService
    @Injected private var chatService: ChatService
    @Injected private var paymentService: PaymentService
    @Injected private var apolloService: ApolloService
    @LazyInjected private var eventTracking: EventTrackingService

    // MARK: Private

    private let isBuyNow: Bool

    private let repo: PaymentRepository
    private let paymentData = BehaviorRelay<PaymentViewData?>(value: nil)
    private weak var delegate: PaymentDelegate?
    private let paymentInput: PaymentInput
    private var order = BehaviorRelay<OrderInterface?>(value: nil)
    private var selectedPaymentMethodId = BehaviorRelay<String?>(value: nil)

    private var redirectContext: STPRedirectContext?
    private var pollingTimer: Timer?

    private let bag = DisposeBag()

    private var selectedAddress: LegacyAddress? { userService.current?.mainMerchant.address.first(where: { $0.id == selectedAddressId.value }) }
    private var selectedAddressId = BehaviorRelay<UUID?>(value: nil)

    private enum DeliveryMethod {
        case pickUp
        case address
    }

    private var selectedDeliveryMethod = BehaviorRelay<DeliveryMethod?>(value: nil)
    private var selectedGraphQLDeliveryMethod = BehaviorRelay<GraphQL.DeliveryMethod?>(value: nil)
    private var selectedShippingMethod = BehaviorRelay<UUID?>(value: nil)

    var enableBuyerProtection = true
    
    // MARK: Inputs/Outputs

    struct Inputs {
        let givenName = BehaviorSubject<String?>(value: nil)
        let familyName = BehaviorSubject<String?>(value: nil)
        let phoneNumber = BehaviorSubject<String?>(value: nil)
    }

    struct Outputs {
        var fetchingData: Observable<Bool> { _fetchingData.asObservable() }
        fileprivate let _fetchingData = BehaviorRelay<Bool>(value: true)

        var nextButtonEnabled: Observable<Bool> { _nextButtonEnabled.asObservable() }
        fileprivate let _nextButtonEnabled = BehaviorRelay<Bool>(value: false)

        var payButtonEnabled: Observable<Bool> { _payButtonEnabled.asObservable() }
        fileprivate let _payButtonEnabled = BehaviorRelay<Bool>(value: false)

        var isLoading: Observable<Bool> { _isLoading.asObservable() }
        fileprivate let _isLoading = BehaviorRelay<Bool>(value: false)

        var totals: Observable<PaymentTotals> { _totals.compactMap { $0 }.asObservable() }
        fileprivate let _totals = BehaviorRelay<PaymentTotals?>(value: nil)

        var deliverySelected: Observable<Bool> { _deliverySelected.asObservable() }
        fileprivate let _deliverySelected = BehaviorRelay<Bool>(value: false)

        var isDeliveryVisible: Observable<Bool> { _shippingMethod.map { $0 != nil }.asObservable() }

        var shippingMethod: Observable<ShippingMethod?> { _shippingMethod.asObservable() }
        fileprivate let _shippingMethod = BehaviorRelay<ShippingMethod?>(value: nil)

        var customShippingPrice: Observable<Price?> { _customShippingPrice.asObservable() }
        fileprivate let _customShippingPrice = BehaviorRelay<Price?>(value: nil)

        var isPickupVisible: Observable<Bool> { _isPickupVisible.asObservable() }
        fileprivate let _isPickupVisible = BehaviorRelay<Bool>(value: false)

        var title: Observable<String> { _title.asObservable() }
        fileprivate let _title = BehaviorRelay<String>(value: "")

        var adImage: Observable<URL?> { _adImage.asObservable() }
        fileprivate let _adImage = BehaviorRelay<URL?>(value: nil)

        var showNameFields: Observable<Bool> { _showNameFields.asObservable() }
        fileprivate let _showNameFields = BehaviorRelay<Bool>(value: true)
        
        var missingAddressError: Observable<Bool> { _missingAddressError.asObservable() }
        fileprivate let _missingAddressError = BehaviorRelay<Bool>(value: false)

        var paymentLabel: Observable<String> { _paymentLabel.asObservable() }
        fileprivate let _paymentLabel = BehaviorRelay<String>(value: R.string.localizable.checkoutPaymentCost())

        var addresses: Observable<[DeliveryCellViewModel]> { _addresses.asObservable() }
        fileprivate let _addresses = BehaviorRelay<[DeliveryCellViewModel]>(value: [])

        var givenNameButton: Observable<TextFieldText> { _givenNameButton.asObservable() }
        fileprivate let _givenNameButton = BehaviorRelay<TextFieldText>(value: TextFieldText(title: ""))

        var lastNameButton: Observable<TextFieldText> { _lastNameButton.asObservable() }
        fileprivate let _lastNameButton = BehaviorRelay<TextFieldText>(value: TextFieldText(title: ""))

        var phoneNumber: Observable<TextFieldText> { _phoneNumber.asObservable() }
        fileprivate let _phoneNumber = BehaviorRelay<TextFieldText>(value: TextFieldText(title: ""))

        fileprivate let _showPaymentTotals = BehaviorRelay<Bool>(value: false)

        var selectedProvider: Observable<PaymentProvider> { _selectedProvider.compactMap { $0 }.asObservable() }
        fileprivate var _selectedProvider = BehaviorRelay<PaymentProvider?>(value: nil)
    }

    let inputs = Inputs()
    let outputs = Outputs()

    init(coordinator: PaymentCoordinator,
         delegate: PaymentDelegate?,
         repo: PaymentRepository,
         paymentInput: PaymentInput,
         isBuyNow: Bool?) {
        self.coordinator = coordinator
        self.delegate = delegate
        self.repo = repo
        self.paymentInput = paymentInput
        self.isBuyNow = isBuyNow ?? false
        customerContext = STPCustomerContext(keyProvider: StripeKeyProvider())
        let ideal = PaymentProvider(title: R.string.localizable.paymentMethodIdeal(), type: GraphQL.PaymentMethod.ideal, reusable: false)
        let bancontact = PaymentProvider(title: R.string.localizable.paymentMethodBancontact(), type: GraphQL.PaymentMethod.bancontact, reusable: false)
        let card = PaymentProvider(title: R.string.localizable.paymentMethodCard(), type: GraphQL.PaymentMethod.card, reusable: true)
        paymentSources = [PaymentProvider](arrayLiteral: ideal, bancontact, card)
        outputs._selectedProvider.accept(paymentSources.first!)
        outputs._selectedProvider
            .compactMap { $0?.type == .card ? R.string.localizable.checkoutPaymentCostCard() : R.string.localizable.checkoutPaymentCost() }
            .bind(to: outputs._paymentLabel)
            .disposed(by: bag)
        super.init()

        loadData()

        selectedAddressId.compactMap { $0 }.subscribe(onNext: { [weak self] id in
            guard let self = self else { return }
            self.outputs._addresses.value.forEach { vm in
                vm.selected.onNext(vm.id == id)
            }
        }).disposed(by: bag)

        selectedDeliveryMethod.compactMap { $0 }.map { method in
            switch method {
            case .pickUp:
                return false
            case .address:
                return true
            }
        }.bind(to: outputs._deliverySelected).disposed(by: bag)

        paymentData.compactMap { $0 }
            .filter { $0.deliveryMethod != .pickup }
            .subscribe(onNext: { [weak self] data in
                self?.outputs._shippingMethod.accept(data.shippingMethod)
                self?.selectedShippingMethod.accept(data.shippingMethod?.id)
                if data.shippingMethod?.slug == customShippingSlug, let cost = data.customShippingCost, cost.amount > Double.ulpOfOne {
                    self?.outputs._customShippingPrice.accept(cost)
                } else {
                    self?.outputs._customShippingPrice.accept(nil)
                }
            }).disposed(by: bag)

        userService.active.compactMap { $0 }.subscribe(onNext: { [weak self] member in
            guard let self = self else { return }
            let models = member.mainMerchant.address.map { (address) -> DeliveryCellViewModel in
                let isSelected = address.id == self.selectedAddressId.value
                let model = DeliveryCellViewModel(address: address, bag: self.bag)
                model.selected.onNext(isSelected)
                return model
            }
            self.outputs._showNameFields.accept(!member.isProfessional)
            let existingGiven = try? self.inputs.givenName.value() ?? nil
            self.outputs._givenNameButton.accept(TextFieldText(title: existingGiven ?? member.givenName))
            let existingFamily = try? self.inputs.familyName.value() ?? nil
            self.outputs._lastNameButton.accept(TextFieldText(title: existingFamily ?? member.familyName))
            let existingPhone = try? self.inputs.phoneNumber.value() ?? nil
            self.outputs._phoneNumber.accept(TextFieldText(title: existingPhone ?? member.mainMerchant.phone ?? ""))

            if existingGiven == nil {
                self.inputs.phoneNumber.onNext(member.mainMerchant.phone ?? "")
                self.inputs.givenName.onNext(member.givenName)
                self.inputs.familyName.onNext(member.familyName)
            }
            self.outputs._addresses.accept(models)
            if self.selectedAddressId.value == nil {
                self.selectedAddressId.accept(member.mainMerchant.address.first?.id)
            }
        }, onError: { [weak self] error in
            self?.crashReporter.log(error: error)
            self?.coordinator.showError(error)
        }).disposed(by: bag)

        if let orderId = paymentInput.orderId {
            repo.loadOrder(id: orderId)
                .subscribe(onNext: { [weak self] result in
                    self?.order.accept(result)
                }, onError: { [weak self] error in
                    self?.crashReporter.log(error: error)
                    self?.coordinator.showError(error)
                }).disposed(by: bag)

            // Only hide loading once both order and 1 payment data has loaded
            Observable.combineLatest(order, paymentData)
                .map { $0.0 == nil || $0.1 == nil }
                .bind(to: outputs._fetchingData).disposed(by: bag)
        } else {
            paymentData.map { $0 == nil }.bind(to: outputs._fetchingData).disposed(by: bag)
        }

        repo.paymentInfo
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.paymentData.accept(data)
                self.outputs._title.accept(data.productTitle)
                self.outputs._adImage.accept(data.productUrl)
                self.setupDelivery(data: data)
            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error)
                self?.coordinator.dismissAll(withError: error)
            }).disposed(by: bag)

        repo.totals.subscribe(onNext: { [weak self] totals in
            self?.outputs._totals.accept(totals)
            self?.outputs._showPaymentTotals.accept(true)
        }, onError: { [weak self] error in
            self?.coordinator.showError(error)
        }).disposed(by: bag)

        let obs = selectedAddressId
            .distinctUntilChanged()
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)

        // Update totals iff:
        // 1) The selected address changes
        // 2) The payment detail changes
        // 3) The provider (ideal, card, bancontact) changes
        // 4) The method changes, ie. going from visa to mastercard
        // 5) If the delivery method changes e.g. from pickup to delivery
        Observable.combineLatest(obs,
                                 paymentData.compactMap { $0 },
                                 selectedDeliveryMethod.compactMap { $0 })
            .subscribe(onNext: { [weak self] _ in
                self?.updateTotals()
            }).disposed(by: bag)

        // Update the delivery button price text iff:
        // 1) we have the origin country (in paymentData)
        // 2) the address selected changes
        Observable.combineLatest(obs, paymentData.compactMap { $0 })
            .subscribe(onNext: { [weak self] result in
                guard let selectedAddress = self?.selectedAddress else { return }
                self?.refreshDeliveryButtonText(data: result.1, destination: selectedAddress)
            }).disposed(by: bag)

        inputs.phoneNumber
            .map { $0 != nil }
            .filter { !$0 }
            .map { _ -> TextFieldText in TextFieldText(error: R.string.localizable.commonInvalidPhoneNumber()) }
            .bind(to: outputs._phoneNumber)
            .disposed(by: bag)

        inputs.phoneNumber
            .compactMap { $0 }
            .map { TextFieldText(title: $0) }
            .bind(to: outputs._phoneNumber)
            .disposed(by: bag)

        setupPayButton()
    }

    func next() {
        guard let givenName = try? inputs.givenName.value() else { return }
        guard let lastName = try? inputs.familyName.value() else { return }
        outputs._isLoading.accept(true)

        // Update user
        guard let member = userService.current else { return }
        var input = LegacyMemberInput(member: member)
        input.givenName = givenName
        input.familyName = lastName

        var merchantInput: LegacyMerchantInput?
        // Only update the merchant if the phone number has been filled in
        if let phone = try? inputs.phoneNumber.value() {
            merchantInput = LegacyMerchantInput(merchant: member.mainMerchant)
            merchantInput?.phone = phone
        }

        userService.update(id: member.id, member: input)
            .flatMap { _ -> Observable<UUID> in
                if let input = merchantInput {
                    return self.merchantService.update(input)
                }
                // Just return something - it's not used anyway but allows everything to continue
                return Observable.just(UUID())
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.outputs._isLoading.accept(false)
                self.goToCheckout()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.crashReporter.log(error: error)
                self.coordinator.showError(error)
                self.outputs._isLoading.accept(false)
            }).disposed(by: bag)
    }

    private func setupPayButton() {
        Observable.combineLatest(outputs._showNameFields, selectedDeliveryMethod, inputs.givenName, inputs.familyName, inputs.phoneNumber, paymentData)
            .map { [weak self] result -> Bool in
                guard let self = self else { return false }
                // Need payment data (repo data)
                guard result.5 != nil else { return false }
                // Need an address is not picking up
                guard let deliveryMethod = result.1 else { return false }
                guard deliveryMethod == .pickUp || self.selectedAddress != nil else {
                    return false
                }
                // Require phone always
                guard let phone = result.4, !phone.isEmpty else {
                    return false
                }
                guard result.0 else { return true }
                // Require valid first, last
                guard let givenName = result.2, !givenName.isEmpty else { return false }
                guard let lastName = result.3, !lastName.isEmpty else { return false }
                return true
            }
            .bind(to: outputs._nextButtonEnabled)
            .disposed(by: bag)

        paymentData
            .map { $0 != nil }
            .bind(to: outputs._payButtonEnabled)
            .disposed(by: bag)
    }

    func checkout() {
        guard let method = outputs._selectedProvider.value else {
            handlePaymentError(PaymentError.noPaymentMethodFound)
            return
        }

        outputs._isLoading.accept(true)

        var order: Observable<OrderInterface?>
        // Reuse exsiting order if it exists in new state
        if let existingOrder = self.order.value {
            // Should we cancel this order and re-create it?
            let existingMethod = existingOrder.payment?.paymentMethod
            let existingMethodId = existingOrder.payment?.paymentMethodId
            // Recreate the payment iff:
            // 1) We change method i.e. from iDEAL -> Bancontact
            // 2) If we previously used a single use source
            // 3) If we changed cards from before
            if existingOrder.payment == nil ||
                method.type.rawValue != existingMethod ||
                !method.reusable ||
                selectedPaymentMethodId.value != existingMethodId {
                order = createPayment(id: existingOrder.id, paymentMethod: method.type)
            } else {
                order = Observable.just(existingOrder)
            }
        } else {
            guard let newOrder = createOrder(paymentMethod: method.type) else {
                handlePaymentError(PaymentError.missingOrder)
                return
            }
            order = newOrder
        }

        order.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            guard let order = result, let payment = order.payment else {
                self.handlePaymentError(PaymentError.missingStripePayment)
                return
            }
            // Need the thread id to generate the deep link for Stripe
            // Also then for redirecting to chat after payment
            self.getChatThread(id: order.productId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(threadId):
                    self.takePayment(order, payment, threadId)
                case let .failure(error):
                    self.handlePaymentError(error)
                }
            }
        }, onError: { [weak self] error in
            self?.crashReporter.log(error: error)
            self?.handlePaymentError(error)
        }).disposed(by: bag)
    }

    func selectAddress() {
        eventTracking.trackAddShippingInfo()
        coordinator.selectAddress(delegate: self)
    }

    func selectDelivery() {
        selectedDeliveryMethod.accept(.address)
        selectedGraphQLDeliveryMethod.accept(GraphQL.DeliveryMethod.delivery)
    }

    func selectPickup() {
        selectedDeliveryMethod.accept(.pickUp)
        selectedGraphQLDeliveryMethod.accept(GraphQL.DeliveryMethod.pickup)
    }

    func onBackPressed() {
        coordinator.backPressed()
    }

    func providerSelected(_ source: PaymentProvider, stripeId: String? = nil) {
        selectedPaymentMethodId.accept(stripeId)
        outputs._selectedProvider.accept(source)
        updateTotals()
    }

    // MARK: Privates

    private func setupDelivery(data: PaymentViewData) {
        eventTracking.trackAddShippingInfo()
        switch data.deliveryMethod {
        case .pickup:
            // Only 1 option, don't show both options
            outputs._shippingMethod.accept(nil)
            selectedShippingMethod.accept(nil)
            outputs._isPickupVisible.accept(true)
            selectedDeliveryMethod.accept(.pickUp)
            selectedGraphQLDeliveryMethod.accept(.pickup)
        case .delivery, .pickupDelivery:
            let allowsBothOptions = (data.deliveryMethod == .pickupDelivery)
            // Only show both buttons if there's an option
            selectedShippingMethod.accept(data.shippingMethod?.id)
            outputs._shippingMethod.accept(data.shippingMethod)
            outputs._isPickupVisible.accept(allowsBothOptions)
            
            // Preselect pickup if there's no addresses available (and it's allowed)
            if allowsBothOptions, outputs._addresses.value.isEmpty {
                selectedDeliveryMethod.accept(.pickUp)
                selectedGraphQLDeliveryMethod.accept(.pickup)
            } else {
                selectedDeliveryMethod.accept(.address)
                selectedGraphQLDeliveryMethod.accept(.delivery)
            }
        case .__unknown:
            break
        }
    }

    private func loadData() {
        repo.load(id: paymentInput.productId, bidId: paymentInput.bidId)
        updateTotals()
    }

    func updateTotals() {
        guard let data = paymentData.value else { return }
        guard let provider = outputs._selectedProvider.value else { return }
        guard let input = getOrderInput(paymentMethod: provider.type) else { return }
        repo.loadTotals(input: input, currency: data.currency)
    }

    private func getChatThread(id: UUID, _ completion: @escaping ((Result<UUID, Error>) -> Void)) {
        chatService.getChatThread(filter: ThreadFilterKey.item, id: id)
            .subscribe(onNext: { threadId in
                if let threadId = threadId {
                    completion(.success(threadId))
                }
            }, onError: { [weak self] error in
                self?.crashReporter.log(error: error)
                completion(.failure(error))
            }).disposed(by: bag)
    }

    private func goToCheckout() {
        coordinator.openCheckoutScreen(viewModel: self)
    }

    private func takePayment(_ order: OrderInterface,
                             _ payment: OrderStripePayment,
                             _ threadId: UUID) {
        self.order.accept(order)

        if payment.paymentSourceId != nil {
            return handleOrderSource(payment, threadId)
        }

        let config = STPPaymentConfiguration()
        config.companyName = order.merchantName
        let paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: STPTheme.defaultTheme)
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        // Requires cents not fractions
        paymentContext.paymentAmount = Int(order.totalInclVat * 100)
        paymentContext.paymentCurrency = order.currency.rawValue.lowercased()
        coordinator.setContextHost(paymentContext)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: payment.clientSecretId)
        paymentIntentParams.paymentMethodId = payment.paymentMethodId
        // Not actually used but needed for the payment intent to be used
        paymentIntentParams.returnURL = "whoppah://\(Navigator.RoutePath.paymentCompleted.rawValue)?thread_id=\(threadId)"
        paymentIntentParams.useStripeSDK = NSNumber(value: true)
        STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
            switch status {
            case .succeeded:
                guard let intent = paymentIntent else {
                    return self.handlePaymentError(PaymentError.missingPaymentIntent)
                }
                switch intent.status {
                case .succeeded, .processing:
                    self.validateOrderStatus(orderId: order.id, threadId: threadId)
                case .requiresAction:
                    self.redirectContext = STPRedirectContext(paymentIntent: intent, completion: { [weak self] _, error in
                        guard let self = self else { return }
                        if let error = error {
                            self.handlePaymentError(error)
                            return
                        }

                        switch intent.status {
                        case .succeeded, .processing:
                            self.validateOrderStatus(orderId: order.id, threadId: threadId)
                        case .canceled:
                            self.handlePaymentError()
                        default:
                            self.handlePaymentError()
                        }
                    })
                default:
                    self.handlePaymentError()
                }

            case .failed:
                self.handlePaymentError(error!)
            case .canceled:
                self.handlePaymentError()
            @unknown default:
                break
            }
        }
    }

    private func handleOrderSource(_ payment: OrderStripePayment,
                                   _ threadId: UUID) {
        guard let source = payment.paymentSourceId, let order = order.value else { return }
        STPAPIClient.shared.retrieveSource(withId: source,
                                             clientSecret: payment.clientSecretId) { [weak self] source, error in
            guard let self = self else { return }
            if let error = error {
                self.coordinator.showError(error)
                return
            }
            if let source = source {
                // Update the provider based on the fetched source
                var provider = self.outputs._selectedProvider.value
                if payment.paymentMethod.lowercased() == provider?.type.rawValue.lowercased() {
                    provider?.reusable = source.isReusable
                    self.outputs._selectedProvider.accept(provider)
                }

                if source.flow == .redirect {
                    self.redirectContext = STPRedirectContext(source: source, completion: { [weak self] _, _, error in
                        guard let self = self else { return }
                        if let error = error {
                            self.coordinator.showError(error)
                            return
                        }
                        switch source.status {
                        case .pending:
                            self.startPollingServer(orderId: order.id,
                                                    threadId: threadId,
                                                    sourceId: source.stripeID,
                                                    clientSecret: payment.clientSecretId)
                        case .chargeable:
                            self.validateOrderStatus(orderId: order.id, threadId: threadId)
                        case .failed:
                            // We don't have an error - but do want to display something to the end user
                            self.handlePaymentError(PaymentError.sourceStatusFailed)
                        case .canceled, .unknown:
                            // Just re-enable the button
                            self.handlePaymentError()
                        case .consumed:
                            self.handlePaymentError(PaymentError.sourceStatusConsumed)
                        @unknown default:
                            self.handlePaymentError()
                        }
                    })
                    guard let redirectContext = self.redirectContext else { return }
                    self.coordinator.startPaymentRedirectFlow(redirectContext)
                } else {
                    self.validateOrderStatus(orderId: order.id, threadId: threadId)
                }
            }
        }
    }

    private func stopPollingServer(_ completion: (() -> Void)? = nil) {
        pollingTimer?.invalidate()
        pollingTimer = nil
        DispatchQueue.main.async {
            self.coordinator.hidePaymentProcessingDialog(completion)
        }
    }

    private func startPollingServer(orderId: UUID, threadId: UUID, sourceId: String, clientSecret: String) {
        coordinator.showPaymentProcessingDialog()

        let data: [String: Any] = [threadIdKey: threadId,
                                   orderIdKey: orderId,
                                   sourceIdKey: sourceId,
                                   clientSecretKey: clientSecret,
                                   attemptNumberKey: 0]
        pollingTimer = Timer.scheduledTimer(timeInterval: 0,
                                            target: self,
                                            selector: #selector(onServerPollingFired(_:)),
                                            userInfo: data,
                                            repeats: false)
    }

    private func refreshDeliveryButtonText(data: PaymentViewData, destination: LegacyAddress) {
        guard let requiredShippingMethod = data.shippingMethod, data.deliveryMethod != .pickup else { return }
        // Only refresh the delivery button cost if not using custom shipping
        if requiredShippingMethod.slug == customShippingSlug, let cost = data.customShippingCost, cost.amount > Double.ulpOfOne {
            outputs._customShippingPrice.accept(cost)
            outputs._shippingMethod.accept(data.shippingMethod)
            selectedShippingMethod.accept(data.shippingMethod?.id)
            return
        }
        shippingMethodsRepo.load(origin: data.originCountry, destination: destination.country)
            .subscribe(onNext: { [weak self] methods in
                guard let self = self else { return }
                if let match = methods.first(where: { $0.id == requiredShippingMethod.id }) {
                    self.outputs._shippingMethod.accept(match)
                    self.selectedShippingMethod.accept(match.id)
                }
            }).disposed(by: bag)
    }

    @objc func onServerPollingFired(_ timer: Timer) {
        guard let info = timer.userInfo as? [String: Any] else { return }
        guard let orderId = info[orderIdKey] as? UUID, let threadId = info[threadIdKey] as? UUID else { return }
        guard let sourceId = info[sourceIdKey] as? String, let clientSecret = info[clientSecretKey] as? String else { return }
        guard let attemptNumber = info[attemptNumberKey] as? Int else { return }
        onServerPollingFired(orderId: orderId,
                             threadId: threadId,
                             sourceId: sourceId,
                             clientSecret: clientSecret,
                             attemptNumber: attemptNumber)
    }

    private func onServerPollingFired(orderId: UUID, threadId: UUID, sourceId: String, clientSecret: String, attemptNumber: Int) {
        guard attemptNumber < maxPollAttempts else {
            stopPollingServer {
                self.handlePaymentError()
            }
            return
        }

        // Check the source status first
        // If it's failed we can bail out
        STPAPIClient.shared.retrieveSource(withId: sourceId, clientSecret: clientSecret) { [weak self] source, error in
            guard let self = self else { return }
            if let error = error {
                return self.handlePaymentError(error)
            }
            guard let source = source else { return }
            switch source.status {
            case .canceled:
                self.handlePaymentError()
            case .failed:
                // We don't have an error - but do want to display something to the end user
                self.handlePaymentError(PaymentError.sourceStatusFailed)
            default:
                // Check the order status in the backend
                self.checkOrderStatus(orderId: orderId, threadId: threadId) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(state):
                        switch state {
                        case .accepted, .shipped, .completed:
                            self.redirectContext = nil
                            self.stopPollingServer {
                                self.eventTracking.trackPurchase()
                                self.didPay(threadId)
                            }
                        case .new:
                            if self.pollingTimer == nil {
                                return
                            }
                            let data: [String: Any] = [threadIdKey: threadId,
                                                       orderIdKey: orderId,
                                                       sourceIdKey: sourceId,
                                                       clientSecretKey: clientSecret,
                                                       attemptNumberKey: attemptNumber + 1]
                            self.pollingTimer = Timer.scheduledTimer(timeInterval: 2,
                                                                     target: self,
                                                                     selector: #selector(self.onServerPollingFired(_:)),
                                                                     userInfo: data,
                                                                     repeats: false)
                        default:
                            self.handlePaymentError()
                        }
                    case let .failure(error):
                        self.handlePaymentError(error)
                    }
                }
            }
        }
    }

    private func validateOrderStatus(orderId: UUID, threadId: UUID) {
        checkOrderStatus(orderId: orderId, threadId: threadId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(state):
                if state == .accepted || state == .shipped {
                    self.redirectContext = nil
                    self.didPay(threadId)
                } else {
                    self.handlePaymentError(PaymentError.orderStatusNotUpdated)
                }
            case let .failure(error):
                self.coordinator.showError(error)
            }
        }
    }

    typealias CheckOrderResult = Result<GraphQL.OrderState, Error>
    private func checkOrderStatus(orderId: UUID, threadId _: UUID, completion: @escaping ((CheckOrderResult) -> Void)) {
        paymentService.checkOrderStatus(orderId: orderId)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                completion(.success(result.state))
            }, onError: { error in
                completion(.failure(error))
            }).disposed(by: bag)
    }

    private func handlePaymentError(_ error: Error? = nil) {
        outputs._isLoading.accept(false)
        redirectContext = nil
        stopPollingServer { [weak self] in
            guard let self = self else { return }
            if let error = error {
                self.crashReporter.log(error: error)
                // Show the direct error here because Stripe includes useful information
                // about what went wrong - such as 'card has insufficient funds' or similar
                self.coordinator.showError(error.localizedDescription)
            }
        }
    }

    private func getOrderInput(paymentMethod: GraphQL.PaymentMethod) -> GraphQL.OrderInput? {
        guard let paymentData = paymentData.value else { return nil }
        guard let method = selectedDeliveryMethod.value else { return nil }
        let paymentMethodId = selectedPaymentMethodId.value
        switch method {
        case .pickUp:
            return GraphQL.OrderInput(purchaseType: .bid,
                                      bidId: paymentData.bidId,
                                      productId: paymentInput.productId,
                                      paymentMethod: paymentMethod,
                                      paymentMethodId: paymentMethodId,
                                      deliveryMethod: .pickup,
                                      shippingMethodId: nil,
                                      addressId: nil,
                                      buyerProtection: enableBuyerProtection)
        case .address:
            guard let address = selectedAddressId.value else { return nil }
            return GraphQL.OrderInput(purchaseType: .bid,
                                      bidId: paymentData.bidId,
                                      productId: paymentInput.productId,
                                      paymentMethod: paymentMethod,
                                      paymentMethodId: paymentMethodId,
                                      deliveryMethod: .delivery,
                                      shippingMethodId: paymentData.shippingMethod?.id,
                                      addressId: address,
                                      buyerProtection: enableBuyerProtection)
        }
    }

    private func createOrder(paymentMethod: GraphQL.PaymentMethod) -> Observable<OrderInterface?>? {
        guard let input = getOrderInput(paymentMethod: paymentMethod) else { return nil }
        return paymentService.createOrder(input: input).map { $0 }
    }

    private func createPayment(id: UUID, paymentMethod: GraphQL.PaymentMethod) -> Observable<OrderInterface?> {
        let methodId = selectedPaymentMethodId.value
        let deliveryMethodId = selectedGraphQLDeliveryMethod.value
        let shippingMethodId = selectedShippingMethod.value
        let addressId = selectedAddressId.value
         
        return paymentService.createPayment(
            orderId: id,
            paymentMethod: paymentMethod,
            paymentMethodId: methodId,
            deliveryMethodId: deliveryMethodId,
            shippingMethodId: shippingMethodId,
            addressID: addressId,
            buyerProtection: enableBuyerProtection)
            .map { $0 }
//        return paymentService.createPayment(orderId: id, paymentMethod: paymentMethod, paymentMethodId: methodId).map { $0 }
    }

    private func didPay(_ threadId: UUID) {
        trackPay { [weak self] _ in
            guard let self = self else { return }
            if self.isBuyNow {
                self.loadChat(threadId)
            }
            self.coordinator.dismiss()
            self.delegate?.didFinishTransaction(input: self.paymentInput, successful: true)
        }
    }

    private func loadChat(_ threadId: UUID) {
        coordinator.openChatThread(threadID: threadId)
    }
}

// MARK: - AddEditAddressViewControllerDelegate

extension PaymentViewModel: AddEditAddressViewControllerDelegate {
    func addEditAddressViewController(didDelete _: LegacyAddressInput) {}

    func addEditAddressViewController(didSave address: LegacyAddressInput) {
        guard address.id == nil else { return }
        guard let id = userService.current?.merchantId else { assertionFailure(); return }
        merchantService.addAddress(id: id, address: address)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] address in
                guard let self = self else { return }
                var addresses = self.outputs._addresses.value
                addresses.append(DeliveryCellViewModel(address: address, bag: self.bag))
                self.outputs._addresses.accept(addresses)
                if addresses.count == 1 {
                    self.selectedAddressId.accept(address.id)
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.crashReporter.log(error: error)
                self.coordinator.showError(error)
            }).disposed(by: bag)
    }

    func addressSelected(_ model: DeliveryCellViewModel) {
        selectedAddressId.accept(model.id)
    }
}

extension PaymentViewModel {
    
    func trackPay(completion: @escaping (Bool) -> Void) {
        // Segment.io
        guard let order = order.value else { return completion(false) }

//        let bidPrice = order.bidAmount
//        let shippingCost = order.shippingCost
//        let transportType: TransportType = order.deliveryMethod == .pickup ? .pickUp : .delivery
//        let deliveryPrice = transportType != .pickUp ? shippingCost : 0
//        let fee = order.buyerFeeInclVat
//        serviceProvider.eventTracking.trackPay(adID: order.productId,
//                                                     productCost: bidPrice ?? 0,
//                                                     transportType: transportType,
//                                                     shippingCost: deliveryPrice,
//                                                     transactionCost: fee,
//                                                     whoppahFee: fee,
//                                                     totalCheckoutPrice: order.totalInclVat,
//                                                     isBuyNow: isBuyNow)

        apolloService.fetch(query: GraphQL.ProductQuery(id: order.productId), cache: .fetchIgnoringCacheData)
            .subscribe(onNext: { data in
                guard let product = data.data?.product else {
                    completion(false)
                    return
                }
                
                let createOrder = order as? GraphQL.CreateOrderMutation.Data.CreateOrder
                
                let item: [String: Any] = [
                    AnalyticsParameterItemID: product.id.description,
                    AnalyticsParameterItemName: product.title,
                    AnalyticsParameterItemCategory: product.categories.map({ $0.title }).joined(separator: "/"),
                    AnalyticsParameterItemVariant: createOrder?.purchaseType.rawValue ?? "N/A",
                    AnalyticsParameterItemBrand: product.brand?.title ?? "",
                    AnalyticsParameterPrice: createOrder?.subtotalInclVat ?? 0,
                    AnalyticsParameterQuantity: 1
                ]

                var purchaseParams: [String: Any] = [
                    AnalyticsParameterTransactionID: order.id.description,
                    AnalyticsParameterAffiliation: "Whoppah iOS",
                    AnalyticsParameterCurrency: "EUR",
                    AnalyticsParameterValue: order.totalInclVat,
                    AnalyticsParameterShipping: createOrder?.shippingInclVat ?? 0,
                    "purchase_type": createOrder?.purchaseType.rawValue ?? "N/A",
                    AnalyticsParameterPaymentType: order.payment?.paymentMethod ?? "",
                    AnalyticsParameterShippingTier: order.deliveryMethod.rawValue == "PICKUP" ? "pickup" : order.shippingMethodInfo,
                    AnalyticsParameterCoupon: ""
                ]
                
                purchaseParams[AnalyticsParameterItems] = [item]
                
                Analytics.logEvent(AnalyticsEventPurchase, parameters: purchaseParams)

                completion(true)
            }, onError: { _ in
                completion(false)
            }).disposed(by: bag)
    }
}
