//
//  FilterItemSelectionViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 17/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver

private extension String {
    var santizedName: String {
        trim().lowercased()
    }
}

class FilterItemSelectionViewModel {
    @Injected private var cache: CacheService
    
    private let coordinator: FilterItemSelectionCoordinator
    private var filterItems = [FilterAttribute]()
    private let serverFilterItems: [FilterAttribute]
    private let isSearchable: Bool

    struct Inputs {
        var search = PublishSubject<String?>()
    }

    struct Outputs {
        var isLoading: Driver<Bool> { _isLoading.asDriver() }
        var _isLoading = BehaviorRelay<Bool>(value: false)
        var filterCells = BehaviorSubject<[FilterItemCellViewModel]>(value: [])
        var selectedFilterItems = BehaviorSubject<[FilterAttribute]>(value: [])
        var title = BehaviorSubject<String>(value: "")
        var subtitle = BehaviorSubject<String>(value: "")
        var placeholder = BehaviorSubject<String>(value: "")
        var searchBarHidden = BehaviorSubject<Bool>(value: true)
    }

    let outputs = Outputs()
    let inputs = Inputs()
    private let numberSelectionsAllowed: Int
    private let bag = DisposeBag()

    init(coordinator: FilterItemSelectionCoordinator,
         filterItems: [FilterAttribute],
         selectedItems: [FilterAttribute],
         selectionsAllowed: Int,
         title: String,
         isSearchable: Bool) {
        self.coordinator = coordinator
        self.filterItems = filterItems.sorted(by: {
            let title0 = $0.title.value ?? ""
            let title1 = $1.title.value ?? ""
            return title0.santizedName < title1.santizedName
        })
        serverFilterItems = self.filterItems
        numberSelectionsAllowed = selectionsAllowed
        self.isSearchable = isSearchable

        outputs.selectedFilterItems.onNext(selectedItems)
        outputs.title.onNext(title)
        outputs.subtitle.onNext(R.string.localizable.filter_list_title_single(title.lowerCaseFirstLetter()))
        outputs.placeholder.onNext(R.string.localizable.createAdSelectAttributeSearchPlaceholder())
        outputs.searchBarHidden.onNext(!isSearchable)

        inputs.search.distinctUntilChanged().subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            guard let text = text, !text.isEmpty else {
                self.resetToServer()
                return
            }

            let foundMatches = self.serverFilterItems.filter {
                let title = $0.title.value ?? ""
                return title.santizedName.contains(text.lowercased())
            }
            self.filterItems = foundMatches
            self.updateCells()
        }).disposed(by: bag)

        updateCells()
    }

    private func isSelected(item: FilterAttribute) -> Bool {
        guard let items = try? outputs.selectedFilterItems.value() else { return false }
        return items.contains(where: { $0.slug == item.slug })
    }

    private func updateCells() {
        var cells = [FilterItemCellViewModel]()
        for item in filterItems {
            let vm = FilterItemCellViewModel(attribute: item, bag: bag, selected: isSelected(item: item))
            vm.itemClick.subscribe(onNext: { [weak self] selected in
                guard let self = self else { return }
                guard var items = try? self.outputs.selectedFilterItems.value() else { return }
                if let index = items.firstIndex(where: { $0.slug == item.slug }) {
                    items.remove(at: index)
                } else {
                    if self.numberSelectionsAllowed == 1, !items.isEmpty {
                        items.remove(at: 0)
                    } else if items.count >= self.numberSelectionsAllowed {
                        self.updateCells()
                        return
                    }
                    items.append(selected)
                }
                self.outputs.selectedFilterItems.onNext(items)
                self.updateCells()
            }).disposed(by: bag)
            cells.append(vm)
        }
        outputs.filterCells.onNext(cells)
    }

    private func resetToServer() {
        filterItems = serverFilterItems
        updateCells()
    }

    func dismiss() {
        coordinator.dismiss()
    }
}
