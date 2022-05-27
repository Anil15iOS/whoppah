//
//  AdAttributeSelectionViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 17/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver

extension AdAttribute {
    var santizedName: String? {
        title.trim().lowercased()
    }
}

class AdAttributeSelectionViewModel {
    struct UIInputs {
        let title: String // screen title
        let viewTitle: String // view title (below nav bar)
        let suggestionTitle: String? // suggestion section title
        let suggestionDescription: String? // suggestion section title
        let suggestionPlaceholder: String?
        let saveButtonText: String?
        let unknownSwitchLabel: String?
        let allowSuggestion: Bool // Whether a user can suggest new items
        let allowUnknown: Bool
        let maxSelections: Int
    }

    private let coordinator: AdAttributeSelectionCoordinator

    private var serverAttributes = [AdAttribute]()
    private var attributes = BehaviorRelay<[AdAttribute]>(value: [])

    private let bag = DisposeBag()
    
    private var _selectedAdAttributes = BehaviorRelay<[AdAttribute]>(value: [])

    var attributeCells: Observable<[AdAttributeCellViewModel]> {
        Observable.combineLatest(_selectedAdAttributes, attributes)
            .map { [weak self] res -> [AdAttributeCellViewModel] in
                guard let self = self else { return [] }
                return res.1.map { attribute -> AdAttributeCellViewModel in
                    let selected = res.0.contains(where: { $0.localizedTitle == attribute.localizedTitle })
                    let cell = AdAttributeCellViewModel(attribute: attribute, selected: selected, allowMulti: self.allowMultiselect) {
                        self.onAttributeSelected(attribute: attribute)
                    }

                    return cell
                }
            }
    }

    struct Inputs {
        let isUnknown = BehaviorSubject<Bool>(value: false)
        let suggestion = BehaviorSubject<String?>(value: nil)
    }

    let inputs = Inputs()

    struct Outputs {
        let title = BehaviorSubject<String>(value: "")

        fileprivate let _canShowSuggestionView = BehaviorRelay<Bool>(value: false)

        var showSuggestionView: Observable<Bool> {
            Observable.combineLatest(_canShowSuggestionView.asObservable(),
                                     _showSuggestionView.asObservable(),
                                     _isUnknown)
                .map { $0.0 && $0.1 && !$0.2 }
        }

        fileprivate let _showSuggestionView = BehaviorRelay<Bool>(value: false)

        var showUnknownView: Observable<Bool> { _showUnknownView.asObservable() }
        fileprivate let _showUnknownView = BehaviorRelay<Bool>(value: false)

        var isUnknown: Observable<Bool> { _isUnknown.asObservable() }
        fileprivate let _isUnknown = BehaviorRelay<Bool>(value: false)

        var suggestion: Observable<String> { _suggestion.asObservable() }
        fileprivate let _suggestion = BehaviorRelay<String>(value: "")

        var screenTitle = BehaviorSubject<String>(value: "")
        var viewTitle = BehaviorSubject<String>(value: "")
        var saveButtonText = BehaviorSubject<String?>(value: "")
        var suggestionTitle = BehaviorSubject<String?>(value: nil)
        var unknownSwitchLabel = BehaviorSubject<String?>(value: nil)
        var suggestionDescription = BehaviorSubject<String?>(value: nil)
        var suggestionPlaceholder = BehaviorSubject<String?>(value: nil)
    }

    let outputs = Outputs()

    var isLoading: Driver<Bool> {
        _isLoading.asDriver()
    }

    var allowMultiselect: Bool {
        uiInputs.maxSelections > 1
    }

    private var _isLoading = BehaviorRelay<Bool>(value: false)

    private let uiInputs: UIInputs
    private let repo: AdAttributeRepository
    private let unknownAttribute = UnknownAttribute()

    init(coordinator: AdAttributeSelectionCoordinator,
         selectedAttributes: [AdAttribute],
         repo: AdAttributeRepository,
         uiInputs: UIInputs) {
        self.repo = repo
        self.uiInputs = uiInputs
        self.coordinator = coordinator
        outputs.title.onNext(uiInputs.title)
        outputs.viewTitle.onNext(uiInputs.viewTitle)
        outputs.suggestionTitle.onNext(uiInputs.suggestionTitle)
        outputs.suggestionDescription.onNext(uiInputs.suggestionDescription)
        outputs.suggestionPlaceholder.onNext(uiInputs.suggestionPlaceholder)
        outputs.unknownSwitchLabel.onNext(uiInputs.unknownSwitchLabel)
        outputs.saveButtonText.onNext(uiInputs.saveButtonText)

        outputs._showUnknownView.accept(uiInputs.allowUnknown)
        outputs._canShowSuggestionView.accept(uiInputs.allowSuggestion)

        inputs.isUnknown
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] unknown in
                guard let self = self, uiInputs.allowUnknown else { return }
                self.attributes.accept(unknown ? [] : self.serverAttributes)
                if unknown {
                    self.outputs._showSuggestionView.accept(false)
                    self._selectedAdAttributes.accept([self.unknownAttribute])
                } else {
                    self._selectedAdAttributes.accept([])
                }
            }).disposed(by: bag)

        inputs.suggestion
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] suggestion in
                guard let self = self else { return }
                let customAttribute = CustomAttribute(title: suggestion)
                self._selectedAdAttributes.accept([customAttribute])
            }).disposed(by: bag)

        _selectedAdAttributes.accept(selectedAttributes)
    }

    func loadAttributes(completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        _isLoading.accept(true)
        repo.loadAttributes().subscribe(onNext: { [weak self] (attributes: [AdAttribute]) in
            guard let self = self else { return }
            self._isLoading.accept(false)
            let sortedFilteredAttributes = attributes.filter { !$0.santizedName!.isEmpty }
                .sorted(by: { $0.localizedTitle < $1.localizedTitle })
            self.serverAttributes = sortedFilteredAttributes
            self.resetToServerAttributes()
            if let existingFirstAttribute = self._selectedAdAttributes.value.first {
                let isUnknown = existingFirstAttribute.localizedTitle == self.unknownAttribute.localizedTitle
                self.outputs._isUnknown.accept(isUnknown)
                self.inputs.isUnknown.onNext(isUnknown)
                let isCustom = existingFirstAttribute.slug == uniqueCustomAttributeSlug
                if isCustom {
                    self.outputs._showSuggestionView.accept(true)
                    self.outputs._suggestion.accept(existingFirstAttribute.localizedTitle)
                }
            } else {
                self.outputs._isUnknown.accept(false)
            }

            completion(.success(()))
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.coordinator.showError(error)
            completion(.failure(error))
        }).disposed(by: bag)
    }

    func dismiss() {
        coordinator.dismiss()
    }

    func save(completion: @escaping (([AdAttribute], AttributeType) -> Void)) {
        completion(_selectedAdAttributes.value, repo.type)
        coordinator.dismiss()
    }

    func onFilterTextChanged(_ text: String) {
        guard !text.isEmpty else {
            resetToServerAttributes()
            return
        }

        let foundMatches = serverAttributes.filter { $0.santizedName!.contains(text.lowercased()) }
        guard !foundMatches.isEmpty else {
            let exactMatches = foundMatches.filter { $0.santizedName! == text.lowercased() }
            if exactMatches.isEmpty {
                outputs._showSuggestionView.accept(true)
            } else {
                outputs._showSuggestionView.accept(false)
            }

            if !uiInputs.allowSuggestion {
                // No matches - just an empty list
                attributes.accept([])
            }
            return
        }

        // Add the custom item if there's no exact match
        let exactMatches = foundMatches.filter { $0.santizedName! == text.lowercased() }
        outputs._showSuggestionView.accept(exactMatches.isEmpty)
        attributes.accept(foundMatches)
        _selectedAdAttributes.accept([])
    }

    private func resetToServerAttributes() {
        outputs._showSuggestionView.accept(false)
        attributes.accept(serverAttributes)
    }

    func onAttributeSelected(indexPath: IndexPath) {
        let attribute = attributes.value[indexPath.row]
        onAttributeSelected(attribute: attribute)
    }

    private func onAttributeSelected(attribute: AdAttribute) {
        // An attribute has been selected - hide the suggestion view
        outputs._suggestion.accept("")
        outputs._showSuggestionView.accept(false)
        // deselect if already selected
        guard uiInputs.maxSelections > 1 else {
            _selectedAdAttributes.accept([attribute])
            return
        }
        var existing = _selectedAdAttributes.value
        if let index = existing.firstIndex(where: { $0.id == attribute.id }) {
            existing.remove(at: index)
        } else {
            guard _selectedAdAttributes.value.count < uiInputs.maxSelections else {
                return
            }
            existing.append(attribute)
        }
        _selectedAdAttributes.accept(existing)
    }

    func sectionTitle(section _: Int) -> String { R.string.localizable.createAdSelectAttributeResultSectionTitle() }
}
