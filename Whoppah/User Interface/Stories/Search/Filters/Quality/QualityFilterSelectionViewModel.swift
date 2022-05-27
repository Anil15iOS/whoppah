//
//  QualityFilterSelectionViewModel.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift
import WhoppahCore
import WhoppahDataStore

class QualityFilterSelectionViewModel {
    private let coordinator: QualityFilterSelectionCoordinator
    private let selectedQuality: GraphQL.ProductQuality?
    private let completion: (GraphQL.ProductQuality) -> Void
    private let bag = DisposeBag()

    let outputs = Outputs()
    let inputs = Inputs()

    struct Inputs {
        let save = PublishSubject<GraphQL.ProductQuality>()
        let dismiss = PublishSubject<Void>()
    }

    struct Outputs {
        let quality = PublishSubject<GraphQL.ProductQuality?>()
    }

    init(coordinator: QualityFilterSelectionCoordinator,
         selectedQuality: GraphQL.ProductQuality?,
         completion: @escaping ((GraphQL.ProductQuality) -> Void)) {
        self.coordinator = coordinator
        self.selectedQuality = selectedQuality
        self.completion = completion
    }

    func load() {
        setupInputs()
        setupOutputs()
    }
}

// MARK: - Private

private extension QualityFilterSelectionViewModel {
    func setupInputs() {
        inputs.save.bind { [unowned self] quality in
            self.completion(quality)
            self.coordinator.dismiss()
        }.disposed(by: bag)

        inputs.dismiss.bind { [unowned self] _ in
            self.coordinator.dismiss()
        }.disposed(by: bag)
    }

    func setupOutputs() {
        outputs.quality.onNext(selectedQuality)
    }
}
