//
//  CreateAdDescriptionViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 15/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver

class CreateAdDescriptionViewModel: CreateAdViewModelBase {
    let coordinator: CreateAdDescriptionCoordinator
    private let bag = DisposeBag()

    struct Inputs {
        let title = PublishSubject<String>()
        let description = PublishSubject<String>()
    }

    struct Outputs {
        let title = BehaviorSubject<TextFieldText>(value: TextFieldText(title: ""))
        let titleLimitsText = BehaviorSubject<String>(value: "")
        let description = BehaviorSubject<TextFieldText>(value: TextFieldText(title: ""))
        let descriptionLimitsText = BehaviorSubject<String>(value: "")
        var nextEnabled: Observable<Bool> { _nextEnabled.asObservable() }
        fileprivate let _nextEnabled = BehaviorRelay<Bool>(value: false)
    }

    var title: String {
        R.string.localizable.createAdDescriptionTitle()
    }

    var inputs = Inputs()
    let outputs = Outputs()

    init(coordinator: CreateAdDescriptionCoordinator) {
        self.coordinator = coordinator
        super.init(coordinator: coordinator)

        inputs.title.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            let strippedText = String(text.prefix(ProductConfig.titleMaxLength))
            self.outputs.title.onNext(TextFieldText(title: strippedText))
            self.outputs.titleLimitsText.onNext("\(strippedText.count) / \(ProductConfig.titleMaxLength)")
        }).disposed(by: bag)

        inputs.description.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            let strippedText = String(text.prefix(ProductConfig.descriptionMaxLength))
            self.outputs.description.onNext(TextFieldText(title: strippedText))
            self.outputs.descriptionLimitsText.onNext("\(strippedText.count) / \(ProductConfig.descriptionMaxLength)")
        }).disposed(by: bag)

        guard let adTemplate = adCreator.template else { return }
        outputs.title.onNext(TextFieldText(title: adTemplate.title ?? ""))

        outputs.description.onNext(TextFieldText(title: adTemplate.description ?? ""))

        Observable.combineLatest(inputs.title, inputs.description)
            .map { value -> Bool in !value.0.isEmpty && !value.1.isEmpty }.bind(to: outputs._nextEnabled).disposed(by: bag)
    }

    func getBulletText() -> [String] {
        let screenBulletTitle = "create-ad-description"
        return BulletText.fetch(forScreen: screenBulletTitle, categories: adCreator.template!.categories)
    }

    func next() {
        adCreator.template?.title = try? outputs.title.value().title
        adCreator.template?.description = try? outputs.description.value().title
        if case let .description(reason) = adCreator.validate(step: .description) {
            switch reason {
            case .title:
                outputs.title.onNext(TextFieldText(error: R.string.localizable.create_ad_main_error_missing_title()))
            case .description:
                outputs.description.onNext(TextFieldText(error: R.string.localizable.create_ad_main_error_missing_description()))
            }
            return
        }
        coordinator.next()
    }

    func onDismiss() {
        eventTracking.createAd.trackBackPressedAdCreation()
    }
}
