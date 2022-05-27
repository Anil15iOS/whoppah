//
//  CreateAdPriceViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 22/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver

struct AdTotals {
    let price: String
    let vatLabel: String
    let vat: String?
    let whoppahFeeLabel: String
    let whoppahFee: String?
    let total: String
}

func getAdTotals(price: PriceInput, member: LegacyMember) -> AdTotals? {
    let vatRate = member.mainMerchant.vatRate
    let breakdown = getPriceBreakdown(member: member, price: price)
    var feeLabel = ""
    if breakdown.type == .percentage {
        let percentage = breakdown.whoppahPercentage ?? 0.0
        feeLabel = R.string.localizable.create_ad_select_price_merchant_fee(Int(percentage))
    } else {
        feeLabel = R.string.localizable.create_ad_select_price_merchant_fixed_fee()
    }
    let vat = member.mainMerchant.type == .business ? "-\(breakdown.vat.formattedPrice(showFraction: true))" : nil
    let fee = breakdown.whoppahFee.amount > Double.ulpOfOne ? "-\(breakdown.whoppahFee.formattedPrice(showFraction: true))" : nil
    return AdTotals(price: price.formattedPrice(showFraction: true),
                    vatLabel: R.string.localizable.create_ad_select_price_merchant_vat_fee(Int(vatRate)),
                    vat: vat,
                    whoppahFeeLabel: feeLabel,
                    whoppahFee: fee,
                    total: breakdown.total.formattedPrice(showFraction: true))
}

class CreateAdPriceViewModel: CreateAdViewModelBase {
    let coordinator: CreateAdPriceCoordinator
    @Injected var user: LegacyUserService

    private let bag = DisposeBag()
    private var member = BehaviorRelay<LegacyMember?>(value: nil)
    private var price = BehaviorRelay<Double?>(value: nil)

    struct Inputs {
        let allowBid = BehaviorSubject<Bool>(value: false)
        let minBid = BehaviorSubject<String?>(value: nil)
        let price = BehaviorSubject<String?>(value: nil)
    }

    struct Outputs {
        var feeExplanationText: Observable<String> { _feeExplanationText.asObservable() }
        fileprivate let _feeExplanationText = BehaviorRelay<String>(value: "")

        var biddingEnabled: Observable<Bool> { _biddingEnabled.asObservable() }
        fileprivate let _biddingEnabled = BehaviorRelay<Bool>(value: false)

        var currencySymbol: Observable<String> { _currencySymbol.asObservable() }
        fileprivate let _currencySymbol = BehaviorRelay<String>(value: "")

        var showFeeView: Observable<Bool> { _showFeeView.asObservable() }
        fileprivate let _showFeeView = BehaviorRelay<Bool>(value: false)

        var minBid: Observable<TextFieldText> { _minBid.compactMap { $0 }.asObservable() }
        fileprivate let _minBid = BehaviorRelay<TextFieldText?>(value: nil)

        var showVATView: Observable<Bool> { _showVATView.asObservable() }
        fileprivate let _showVATView = BehaviorRelay<Bool>(value: false)

        var price: Observable<TextFieldText> { _price.asObservable() }
        fileprivate let _price = BehaviorRelay<TextFieldText>(value: TextFieldText(type: .text(value: "")))

        var totals: Observable<AdTotals?> { _totals.asObservable() }
        fileprivate let _totals = BehaviorRelay<AdTotals?>(value: nil)

        var nextEnabled: Observable<Bool> { _nextEnabled.asObservable() }
        fileprivate let _nextEnabled = BehaviorRelay<Bool>(value: false)
    }

    var inputs = Inputs()
    let outputs = Outputs()

    init(coordinator: CreateAdPriceCoordinator) {
        self.coordinator = coordinator
        super.init(coordinator: coordinator)
        setupUser()

        inputs.allowBid.bind(to: outputs._biddingEnabled).disposed(by: bag)

        let minBidObs = inputs.allowBid
            .filter { !$0 }

        minBidObs
            .map { _ -> String? in nil }
            .bind(to: inputs.minBid)
            .disposed(by: bag)

        inputs.minBid
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] bidAmount in
                guard let self = self else { return }
                guard let formattedPrice = bidAmount.getPrice() else {
                    let text = TextFieldText(type: .error(message: R.string.localizable.createAdPriceMinBidInvalid()))
                    self.outputs._minBid.accept(text)
                    return
                }
                guard let member = self.member.value else { return }
                let input = PriceInput(currency: member.mainMerchant.currency, amount: formattedPrice)
                let formattedText = input.amount.formatAsSimpleDecimal()
                if let price = self.price.value {
                    if formattedPrice < price * ProductConfig.minimumBidLowestPercentage {
                        let text = TextFieldText(type: .error(message: R.string.localizable.createAdPriceMinBidHigherOnePercentAsking(), text: formattedText))
                        self.outputs._minBid.accept(text)
                    } else if formattedPrice >= price {
                        let text = TextFieldText(type: .error(message: R.string.localizable.createAdPriceMinBidLowerPrice(), text: formattedText))
                        self.outputs._minBid.accept(text)
                    } else {
                        guard let priceText = formattedText else { return }
                        let text = TextFieldText(type: .text(value: priceText))
                        self.outputs._minBid.accept(text)
                    }
                }
            }).disposed(by: bag)

        inputs.price.map { $0?.getPrice() }.bind(to: price).disposed(by: bag)
        Observable.combineLatest(inputs.allowBid.filter { $0 }, inputs.price.map { $0?.getPrice() })
            .subscribe(onNext: { [weak self] result in

                guard let self = self, let member = self.member.value else { return }
                guard let price = result.1 else {
                    self.outputs._minBid.accept(TextFieldText(type: .text(value: "")))
                    return
                }
                let minBidInput = try? self.inputs.minBid.value()
                if minBidInput == nil {
                    let input = PriceInput(currency: member.mainMerchant.currency, amount: price * ProductConfig.minimumBidDefaultPercentage)
                    guard let priceText = input.amount.formatAsSimpleDecimal() else { return }
                    let text = TextFieldText(type: .text(value: priceText))
                    self.outputs._minBid.accept(text)
                    self.inputs.minBid.onNext(priceText)
                }
            }).disposed(by: bag)

        Observable.combineLatest(member.compactMap { $0 }, price)
            .subscribe(onNext: { [weak self] result in
                self?.setUpTransactionFeeFields(user: result.0)
            }).disposed(by: bag)

        Observable.combineLatest(price, inputs.allowBid, inputs.minBid)
            .map { [weak self] result in
                guard let self = self, let price = result.0 else { return false }
                guard self.getPriceInput() != nil else { return false }
                guard self.isValidPrice() else { return false }
                guard result.1 else { return true }
                guard let minBid = result.2?.getPrice() else { return false }
                return minBid >= price * ProductConfig.minimumBidLowestPercentage
            }
            .bind(to: outputs._nextEnabled)
            .disposed(by: bag)

        setupAd()
    }

    func tipText() -> String {
        guard let member = member.value else { return "" }
        guard let template = adCreator.template else { return "" }
        
        if let fee = template.merchantFee ?? member.mainMerchant.fees {
            switch fee.type {
            case .fixed:
                let symbol = member.mainMerchant.currency.text
                return R.string.localizable.createAdPriceTipText("\(symbol)\(fee.amount)")
            case .percentage:
                let feeText = fee.amount.formatAsSimpleDecimal() ?? "\(fee.amount)"
                return R.string.localizable.createAdPriceTipText("\(feeText)%")
            default: break
            }
        }

        return ""
    }

    private func setupUser() {
        user.active.compactMap { $0 }.subscribe(onNext: { [weak self] member in
            guard let self = self else { return }
            self.member.accept(member)
            self.outputs._currencySymbol.accept(member.mainMerchant.currency.text)
            self.setUpTransactionFeeFields(user: member)
        }).disposed(by: bag)
    }

    private func setupAd() {
        guard let template = adCreator.template else { return }
        inputs.allowBid.onNext(template.settings.allowBidding)
        if let minBid = template.settings.minBid, let minBidText = minBid.amount.formatAsSimpleDecimal() {
            inputs.minBid.onNext(minBidText)
            outputs._minBid.accept(TextFieldText(type: .text(value: minBidText)))
        } else {
            inputs.minBid.onNext(nil)
            outputs._minBid.accept(TextFieldText(type: .text(value: "")))
        }
        if let price = template.price, let priceText = price.amount.formatAsSimpleDecimal() {
            inputs.price.onNext(priceText)
        }
    }

    func next() {
        guard isValidPrice(), let priceInput = getPriceInput() else {
            outputs._price.accept(TextFieldText(type: .error(message: "erorr")))
            return
        }
        guard let member = member.value else { return }
        adCreator.template?.price = priceInput
        let allowBidding = try? inputs.allowBid.value()
        var minPrice: PriceInput?
        if let minBid = try? inputs.minBid.value(), let amount = minBid.getPrice() {
            minPrice = PriceInput(currency: member.mainMerchant.currency, amount: amount)
        }
        adCreator.template?.settings = ProductSettingsInput(allowBidding: allowBidding ?? false, allowBuyNow: true, minBid: minPrice)

        if case .price = adCreator.validate(step: .price) {
            return
        }

        coordinator.next()
        eventTracking.createAd.trackPriceNextClicked(price: priceInput.amount)
    }

    private func getPriceInput() -> PriceInput? {
        guard let member = member.value else { return nil }
        guard let price = price.value else { return nil }
        return PriceInput(currency: member.mainMerchant.currency, amount: price)
    }

    func onDismiss() {
        eventTracking.createAd.trackBackPressedAdCreation()
    }

    // MARK: Privates

    private func setUpTransactionFeeFields(user: LegacyMember) {
        let priceInput = getPriceInput()
        let breakdown = getPriceBreakdown(member: user, price: priceInput)

        let showTransactionFeeUI = breakdown.whoppahPercentage ?? 0.0 > Money.ulpOfOne || breakdown.vat.amount > Money.ulpOfOne

        outputs._showFeeView.accept(showTransactionFeeUI)
        outputs._showVATView.accept(user.isProfessional)

        if let fee = user.mainMerchant.fees {
            switch fee.type {
            case .fixed:
                let symbol = user.mainMerchant.currency.text
                outputs._feeExplanationText.accept(R.string.localizable.createAdPriceFeeExplanationText("\(symbol)\(fee.amount)"))
            case .percentage:
                if let feeText = fee.amount.formatAsSimpleDecimal() {
                    outputs._feeExplanationText.accept(R.string.localizable.createAdPriceFeeExplanationText("\(feeText)%"))
                }
            default: break
            }
        }
        updatePriceFields(user: user)
    }

    private func updatePriceFields(user: LegacyMember) {
        let priceInput = getPriceInput()
        guard let price = priceInput else {
            outputs._price.accept(TextFieldText(type: .text(value: "")))
            outputs._totals.accept(nil)
            return
        }

        let priceText = price.amount.formatAsSimpleDecimal() ?? ""
        if isValidPrice() {
            let totals = getAdTotals(price: price, member: user)
            outputs._totals.accept(totals)
            outputs._price.accept(TextFieldText(type: .text(value: priceText)))
        } else {
            outputs._price.accept(TextFieldText(type: .text(value: priceText)))
            outputs._totals.accept(nil)
        }
    }

    private func isValidPrice() -> Bool {
        guard let price = price.value else { return false }
        return price.isValidSellerPrice()
    }
}
