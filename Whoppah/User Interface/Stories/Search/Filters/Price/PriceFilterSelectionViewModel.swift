//
//  PriceFilterSelectionViewModel.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import WhoppahCore

class PriceFilterSelectionViewModel {
    private let coordinator: PriceFilterSelectionCoordinator
    private var minPrice: Money?
    private var maxPrice: Money?
    private let completion: ((minPrice: Money?, maxPrice: Money?)) -> Void
    private let bag = DisposeBag()

    let outputs = Outputs()
    let inputs = Inputs()

    struct Inputs {
        let minPrice = PublishSubject<String?>()
        let maxPrice = PublishSubject<String?>()
        let save = PublishSubject<Void>()
        let dismiss = PublishSubject<Void>()
    }

    struct Outputs {
        let minPrice = PublishSubject<String?>()
        let maxPrice = PublishSubject<String?>()
        let saveEnabled = PublishSubject<Bool>()
    }

    init(coordinator: PriceFilterSelectionCoordinator,
         minPrice: Money?,
         maxPrice: Money?,
         completion: @escaping (((minPrice: Money?, maxPrice: Money?)) -> Void)) {
        self.coordinator = coordinator
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.completion = completion
    }

    func load() {
        setupInputs()
        setupOutputs()
    }

    func dismiss() {
        coordinator.dismiss()
    }
}

// MARK: - Private

private extension PriceFilterSelectionViewModel {
    var minPriceString: String? {
        guard let minPrice = minPrice else { return nil }
        return String(Int(minPrice))
    }

    var maxPriceString: String? {
        guard let maxPrice = maxPrice else { return nil }
        return String(Int(maxPrice))
    }

    func setupInputs() {
        inputs.dismiss.bind { [unowned self] _ in
            self.coordinator.dismiss()
        }.disposed(by: bag)

        Observable.combineLatest(inputs.minPrice.startWith(minPriceString), inputs.maxPrice.startWith(maxPriceString))
            .subscribe(onNext: { [unowned self] minPriceString, maxPriceString in
                self.minPrice = minPriceString?.getPrice()
                self.maxPrice = maxPriceString?.getPrice()
                let enable = (self.minPrice ?? 0 < self.maxPrice ?? 0) || (self.minPrice != nil && self.maxPrice == nil)
                self.outputs.saveEnabled.onNext(enable)
        }).disposed(by: bag)

        inputs.save.subscribe(onNext: { [unowned self] _ in
            self.completion((minPrice: self.minPrice, maxPrice: self.maxPrice))
            self.coordinator.dismiss()
        }).disposed(by: bag)
    }

    func setupOutputs() {
        if let minPrice = minPrice {
            outputs.minPrice.onNext("\(Int(minPrice))")
        } else {
            outputs.minPrice.onNext(nil)
        }

        if let maxPrice = maxPrice {
            outputs.maxPrice.onNext("\(Int(maxPrice))")
        } else {
            outputs.maxPrice.onNext(nil)
        }
    }
}
