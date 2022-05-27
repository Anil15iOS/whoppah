//
//  ColorFilterSelectionViewModel.swift
//  Whoppah
//
//  Created by Jose Camallonga on 02/04/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import RxSwift

class ColorFilterSelectionViewModel {
    private let coordinator: ColorFilterSelectionCoordinator
    private let colors: [FilterAttribute]
    private var selected: [FilterAttribute]
    private let completion: ([FilterAttribute]) -> Void
    private let bag = DisposeBag()

    let outputs = Outputs()
    let inputs = Inputs()

    struct Inputs {
        let save = PublishSubject<Void>()
        let dismiss = PublishSubject<Void>()
    }

    struct Outputs {
        let colors = BehaviorSubject<[ColorViewModel]>(value: [])
        let saveEnabled = PublishSubject<Bool>()
    }

    init(coordinator: ColorFilterSelectionCoordinator,
         colors: [FilterAttribute],
         selected: [FilterAttribute],
         completion: @escaping (([FilterAttribute]) -> Void)) {
        self.coordinator = coordinator
        self.colors = colors
        self.selected = selected
        self.completion = completion
    }

    func load() {
        setupInputs()
        setupOutputs()
    }

    func dismiss() {
        coordinator.dismiss()
    }

    func colorSelected(vm: ColorViewModel) {
        guard case let ColorViewModel.BackingData.filterAttribute(attribute) = vm.data else { return }
        vm.selected ? selected.append(attribute) : selected.removeAll(where: { $0.slug == attribute.slug })
        outputs.saveEnabled.onNext(!selected.isEmpty)
    }
}

// MARK: - Private

private extension ColorFilterSelectionViewModel {
    func setupInputs() {
        inputs.dismiss.bind { [unowned self] _ in
            self.coordinator.dismiss()
        }.disposed(by: bag)

        inputs.save.bind { [unowned self] _ in
            self.completion(self.selected)
            self.coordinator.dismiss()
        }.disposed(by: bag)
    }

    func setupOutputs() {
        let viewModels = colors.map { (attribute) -> ColorViewModel in
            let selected = self.selected.contains(where: { $0.slug == attribute.slug })
            return ColorViewModel(attribute: attribute, selected: selected)
        }.sorted { $0.hex > $1.hex }
        outputs.colors.onNext(viewModels.removingDuplicates())
        outputs.saveEnabled.onNext(!selected.isEmpty)
    }
}
