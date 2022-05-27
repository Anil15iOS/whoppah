//
//  CreateAdShippingViewModel.swift
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
import WhoppahDataStore

enum ShippingOption {
    case existing(method: ShippingMethod)
    case custom(price: PriceInput)
}

class CreateAdShippingViewModel: CreateAdViewModelBase {
    let coordinator: CreateAdShippingCoordinator

    @Injected private var user: LegacyUserService
    @Injected private var shippingRepo: LegacyShippingMethodsRepository

    private let bag = DisposeBag()
    private var address: LegacyAddress?
    lazy var addressVM: AddressSelectionViewModel! = nil

    struct Inputs {
        let deliveryMethod = PublishSubject<GraphQL.DeliveryMethod>()
    }

    struct Outputs {
        let deliveryMethod = BehaviorSubject<GraphQL.DeliveryMethod?>(value: nil)
        let shipping = BehaviorSubject<ShippingOption?>(value: nil)
        let shippingMethods = BehaviorSubject<[ShippingMethod]>(value: [])

        var currencySymbol: Observable<String> { _currencySymbol.asObservable() }
        fileprivate let _currencySymbol = BehaviorRelay<String>(value: "")

        var hasAddress: Observable<Bool> { _hasAddress.asObservable() }
        fileprivate let _hasAddress = BehaviorRelay<Bool>(value: false)

        var nextEnabled: Observable<Bool> { _nextEnabled.asObservable() }
        fileprivate let _nextEnabled = BehaviorRelay<Bool>(value: false)
    }

    var inputs = Inputs()
    let outputs = Outputs()

    init(coordinator: CreateAdShippingCoordinator) {
        self.coordinator = coordinator
        super.init(coordinator: coordinator)

        guard let template = adCreator.template else { fatalError() }
        address = template.location
        addressVM = AddressSelectionViewModel(selectedAddress: address)

        addressVM.outputs.selectedAddress.subscribe(onNext: { [weak self] address in
            guard let self = self else { return }
            self.address = address
        }).disposed(by: bag)

        addressVM.outputs.selectedAddress
            .debounce(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.loadDeliveryOptions()
            }).disposed(by: bag)

        addressVM.outputs.selectedAddress
            .map { $0 != nil }
            .bind(to: outputs._hasAddress)
            .disposed(by: bag)

        Observable.combineLatest(addressVM.outputs.selectedAddress, outputs.deliveryMethod, outputs.shipping).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            let address = result.0
            let deliveryMethod = result.1
            let shipping = result.2
            var valid = address != nil
            if let method = deliveryMethod {
                valid = valid && (method == .pickup || shipping != nil)
            } else {
                valid = false
            }
            self.outputs._nextEnabled.accept(valid)
        }).disposed(by: bag)

        if let method = template.delivery {
            outputs.deliveryMethod.onNext(method)
            switch method {
            case .pickup:
                outputs.shipping.onNext(nil)
            default:

                if let shipping = template.shippingMethod {
                    if let price = shipping.price {
                        outputs.shipping.onNext(ShippingOption.custom(price: price))
                    } else if let method = shipping.method {
                        outputs.shipping.onNext(ShippingOption.existing(method: method))
                    }
                }
            }
        } else {
            outputs.deliveryMethod.onNext(.pickup)
        }

        inputs.deliveryMethod.subscribe(onNext: { [weak self] method in
            guard let self = self else { return }
            self.outputs.deliveryMethod.onNext(method)

            if let methods = try? self.outputs.shippingMethods.value() {
                guard let first = methods.first(where: { $0.slug != customShippingSlug }) else { return }
                switch method {
                case .delivery, .pickupDelivery:
                    self.outputs.shipping.onNext(ShippingOption.existing(method: first))
                default: break
                }
            }
        }).disposed(by: bag)

        user.active.compactMap { $0?.mainMerchant.currency.text }.bind(to: outputs._currencySymbol).disposed(by: bag)
    }

    private func loadDeliveryOptions() {
        // Use the address country, with a suitable fallback if it's empty or invalid (for any reason)
        let country = address?.country ?? ""
        let match = Country.allCases.first(where: { $0.rawValue == country.uppercased() })
        shippingRepo.load(origin: match?.rawValue ?? Country.netherlands.rawValue, destination: country)
            .subscribe(onNext: { [weak self] methods in
                guard let self = self else { return }
                var filteredMethods = methods.filter { $0.slug != "mailbox" }
                filteredMethods.sort { (first, second) -> Bool in
                    if first.slug == "courier" { return false }
                    return first.price.amount > second.price.amount
                }
                self.outputs.shippingMethods.onNext(filteredMethods.compactMap { $0 as ShippingMethod })
            }).disposed(by: bag)
    }

    func didSelectCustom(price: String?) {
        guard let price = price?.getPrice(), let currency = user.current?.mainMerchant.currency else {
            outputs.shipping.onNext(nil)
            return
        }
        outputs.shipping.onNext(.custom(price: PriceInput(currency: currency, amount: price)))
    }

    // MARK: Actions

    func next() {
        if let address = self.address {
            if let method = try? outputs.deliveryMethod.value() {
                guard let template = adCreator.template else { return }
                let point = address.point
                template.location = address
                switch method {
                case .pickup:
                    template.delivery = .pickup
                    template.shippingMethod = nil
                    eventTracking.createAd.trackDeliveryNextClicked(location: point, deliveryType: GraphQL.DeliveryMethod.pickup.rawValue, cost: 0.0)
                default:
                    template.delivery = method
                    if let shipping = try? outputs.shipping.value() {
                        switch shipping {
                        case let .existing(shippingMethod):

                            eventTracking.createAd.trackDeliveryNextClicked(location: point, deliveryType: method.rawValue, cost: shippingMethod.pricing.amount)
                            template.shippingMethod = ShippingMethodInput(method: shippingMethod, price: nil)
                        case let .custom(price):
                            eventTracking.createAd.trackDeliveryNextClicked(location: point, deliveryType: method.rawValue, cost: price.amount)
                            if let methods = try? outputs.shippingMethods.value(), let customMethod = methods.first(where: { $0.slug == customShippingSlug }) {
                                template.shippingMethod = ShippingMethodInput(method: customMethod, price: price)
                            } else {
                                template.shippingMethod = ShippingMethodInput(method: nil, price: price)
                            }
                        }
                    }
                }
            }
        }

        if case .shipping = adCreator.validate(step: .shipping) {
            return
        }

        coordinator.next()
    }

    func onDismiss() {
        eventTracking.createAd.trackBackPressedAdCreation()
    }
}

// MARK: - DeliverySelectionViewDelegate

extension CreateAdShippingViewModel: DeliverySelectionViewDelegate {
    func deliverySelectionView(didSelectMethod: DeliverySelectionView.SelectedMethod) {
        guard case let .delivery(method) = didSelectMethod else { return }
        outputs.shipping.onNext(.existing(method: method))
    }
}
