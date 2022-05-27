//
//  DistanceFilterSelectionViewModel.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import WhoppahCore

class DistanceFilterSelectionViewModel {
    private let coordinator: DistanceFilterSelectionCoordinator
    private var address: LegacyAddressInput? {
        didSet {
            outputs.saveEnabled.onNext(address != nil)
        }
    }

    private var radiusKm: Int
    private let completion: ((address: LegacyAddressInput?, radiusKm: Int)) -> Void
    private let bag = DisposeBag()

    let outputs = Outputs()
    let inputs = Inputs()

    struct Inputs {
        let radius = PublishSubject<Int>()
        let address = PublishSubject<LegacyAddressInput>()
        let save = PublishSubject<Void>()
        let dismiss = PublishSubject<Void>()
    }

    struct Outputs {
        let address = PublishSubject<LegacyAddressInput?>()
        let radius = PublishSubject<Int>()
        let saveEnabled = PublishSubject<Bool>()
    }

    init(coordinator: DistanceFilterSelectionCoordinator,
         address: LegacyAddressInput?,
         radiusKm: Int,
         completion: @escaping (((address: LegacyAddressInput?, radiusKm: Int)) -> Void)) {
        self.coordinator = coordinator
        self.address = address
        self.radiusKm = radiusKm
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

private extension DistanceFilterSelectionViewModel {
    func setupInputs() {
        inputs.address.subscribe(onNext: { [weak self] address in
            self?.address = address
        }).disposed(by: bag)

        inputs.radius.skip(1).distinctUntilChanged().subscribe(onNext: { [weak self] radius in
            self?.radiusKm = radius
            self?.outputs.radius.onNext(radius)
        }).disposed(by: bag)

        inputs.save.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.completion((address: self.address, radiusKm: self.radiusKm))
            self.coordinator.dismiss()
        }).disposed(by: bag)

        inputs.dismiss.bind { [weak self] _ in
            self?.coordinator.dismiss()
        }.disposed(by: bag)
    }

    func setupOutputs() {
        outputs.address.onNext(address)
        outputs.radius.onNext(radiusKm)
        outputs.saveEnabled.onNext(address != nil)
    }
}
