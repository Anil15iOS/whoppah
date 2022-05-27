//
//  CreateAdCategorySelectionViewModel.swift
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
import WhoppahDataStore

class CreateAdCategoryView {
    var itemClick = PublishSubject<Void>()
    private let category: WhoppahCore.Category
    fileprivate init(category: WhoppahCore.Category) {
        self.category = category
    }

    var title: Observable<String?> { observedLocalizedString(categoryTitleKey(category.slug)) }
    var image: URL? { category.detailImages.first?.asURL() }
}

class CreateAdCategorySelectionViewModel {
    let coordinator: CreateAdCategorySelectionCoordinator

    @Injected var cache: CacheService
    @Injected var adCreator: ADCreator
    @Injected var eventTracking: EventTrackingService
    private let bag = DisposeBag()

    struct Outputs {
        var topCategories: Observable<[CreateAdCategoryView]> { _topCategories.asObservable() }
        fileprivate let _topCategories = BehaviorRelay<[CreateAdCategoryView]>(value: [])
    }

    let outputs = Outputs()

    init(coordinator: CreateAdCategorySelectionCoordinator) {
        self.coordinator = coordinator
        cache.categoryRepo?.categories.drive(onNext: { result in
            switch result {
            case let .success(data):
                var cells = [CreateAdCategoryView]()
                for category in data?.categories.items ?? [] {
                    let vm = CreateAdCategoryView(category: category)
                    vm.itemClick.subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.adCreator.template?.categories = [category]
                        self.coordinator.next()
                        self.trackCategorySelection(category: category)
                    }).disposed(by: self.bag)
                    cells.append(vm)
                }
                self.outputs._topCategories.accept(cells)
            case let .failure(error):
                self.coordinator.showError(error)
            }
        }).disposed(by: bag)
    }

    func onDismiss() {
        eventTracking.createAd.trackCancelAdCreation()
    }

    func trackCategorySelection(category: GraphQL.GetCategoriesQuery.Data.Category.Item) {
        switch category.slug {
        case "kunst":
            eventTracking.createAd.trackArtCategoryClicked()
        case "meubels":
            eventTracking.createAd.trackFurnitureCategoryClicked()
        case "verlichting":
            eventTracking.createAd.trackLightingCategoryClicked()
        case "woon-decoratie":
            eventTracking.createAd.trackDecorationCategoryClicked()
        default:
            break
        }
    }
}
