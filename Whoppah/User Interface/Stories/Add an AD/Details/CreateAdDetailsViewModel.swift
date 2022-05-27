//
//  CreateAdDetailsViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 21/01/2020.
//  Copyright © 2020 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class CreateAdDetailsViewModel: CreateAdViewModelBase {
    let coordinator: CreateAdDetailsCoordinator

    @Injected var apollo: ApolloService

    private let bag = DisposeBag()
    private var brandRepo: AdAttributeRepository
    private var artistRepo: AdAttributeRepository
    private var materialRepo: AdAttributeRepository

    struct Inputs {
        let width = BehaviorSubject<String?>(value: nil)
        let height = BehaviorSubject<String?>(value: nil)
        let depth = BehaviorSubject<String?>(value: nil)
        let quality = BehaviorSubject<GraphQL.ProductQuality?>(value: nil)
    }

    struct Outputs {
        var width: Observable<String> { _width.asObservable() }
        fileprivate let _width = BehaviorRelay<String>(value: "")

        var height: Observable<String> { _height.asObservable() }
        fileprivate let _height = BehaviorRelay<String>(value: "")

        var depth: Observable<String> { _depth.asObservable() }
        fileprivate let _depth = BehaviorRelay<String>(value: "")

        var brandTitle: Observable<String> { _brandTitle.asObservable() }
        fileprivate let _brandTitle = BehaviorRelay<String>(value: "")

        var brandValue: Observable<String> { _brandValue.asObservable() }
        fileprivate let _brandValue = BehaviorRelay<String>(value: "")

        var materialTitle: Observable<String> { _materialTitle.asObservable() }
        fileprivate let _materialTitle = BehaviorRelay<String>(value: "")

        var nextEnabled: Observable<Bool> { _nextEnabled.asObservable() }
        fileprivate let _nextEnabled = BehaviorRelay<Bool>(value: false)

        var quality: Observable<GraphQL.ProductQuality?> { _quality.asObservable() }
        fileprivate let _quality = BehaviorRelay<GraphQL.ProductQuality?>(value: nil)

        var colors: Observable<[ColorViewModel]> { _colors.asObservable() }
        fileprivate let _colors = BehaviorRelay<[ColorViewModel]>(value: [])
    }

    private var brandOrArtists = BehaviorRelay<[AdAttribute]>(value: [])
    private let selectedMaterials = BehaviorRelay<[AdAttribute]>(value: [])
    private let selectedColors = BehaviorRelay<[Color]>(value: [])

    var inputs = Inputs()
    let outputs = Outputs()

    init(coordinator: CreateAdDetailsCoordinator,
         brandRepo: AdAttributeRepository,
         artistRepo: AdAttributeRepository,
         materialRepo: AdAttributeRepository) {
        self.brandRepo = brandRepo
        self.artistRepo = artistRepo
        self.materialRepo = materialRepo
        self.coordinator = coordinator
        super.init(coordinator: coordinator)

        selectedMaterials.map { materials in
            if materials.isEmpty { return R.string.localizable.createAdDetailsSelectCommon() }
            return materials.compactMap { localizedString(materialTitleKey($0.slug)) }.joined(separator: ", ")
        }.bind(to: outputs._materialTitle).disposed(by: bag)

        reloadColors()

        let dimensionsCheck = Observable.combineLatest(inputs.width.compactMap { $0 },
                                                       inputs.height.compactMap { $0 },
                                                       inputs.depth.compactMap { $0 })
            .map { !$0.0.isEmpty || !$0.1.isEmpty || !$0.2.isEmpty }
        Observable.combineLatest(dimensionsCheck, inputs.quality.compactMap { $0 }, selectedColors, brandOrArtists)
            .map { result -> Bool in
                result.0 && !result.2.isEmpty && !result.3.isEmpty
            }.bind(to: outputs._nextEnabled).disposed(by: bag)
        setupAd()
    }

    func next() {
        guard let quality = outputs._quality.value else { return }
        let width = try? inputs.width.value()
        let height = try? inputs.height.value()
        let depth = try? inputs.depth.value()
        guard width?.isEmpty == false || height?.isEmpty == false || depth?.isEmpty == false else { return }
        guard let template = adCreator.template else { return }
        template.width = [Int(width ?? "")].compactMap { $0 }.first
        template.height = [Int(height ?? "")].compactMap { $0 }.first
        template.depth = [Int(depth ?? "")].compactMap { $0 }.first
        template.quality = quality
        template.colors = selectedColors.value

        guard let adTemplate = adCreator.template else { return }
        let isArt = hasArtCategory(adTemplate.categories)
        if isArt {
            template.brand = nil
            template.artists = brandOrArtists.value
        } else {
            template.brand = brandOrArtists.value.first
            template.artists = []
        }

        if case .details = adCreator.validate(step: .details) {
            return
        }

        coordinator.next()
    }

    func selectBrandOrArtist() {
        guard let template = adCreator.template else { return }
        let isArt = hasArtCategory(template.categories)
        if isArt {
            openArtistSelection()
        } else {
            openBrandSelection()
        }
    }

    func selectMaterial() {
        eventTracking.createAd.trackMaterialClicked()
        let title = R.string.localizable.commonMaterialTitle()
        let viewTitle = R.string.localizable.createAdSelectMaterialTitle()
        let saveButton = R.string.localizable.createAdSelectAttributeDefaultButton()

        let inputs = AdAttributeSelectionViewModel.UIInputs(title: title,
                                                            viewTitle: viewTitle,
                                                            suggestionTitle: nil,
                                                            suggestionDescription: nil,
                                                            suggestionPlaceholder: nil,
                                                            saveButtonText: saveButton,
                                                            unknownSwitchLabel: nil,
                                                            allowSuggestion: false,
                                                            allowUnknown: false,
                                                            maxSelections: 100)

        coordinator.selectAttribute(inputs: inputs,
                                    repo: materialRepo,
                                    selectedAttributes: selectedMaterials.value,
                                    delegate: self)
    }

    func onDismiss() {
        eventTracking.createAd.trackBackPressedAdCreation()
    }

    private func setupAd() {
        guard let template = adCreator.template else { return }

        inputs.quality.bind(to: outputs._quality).disposed(by: bag)
        inputs.quality.onNext(template.quality)

        if let width = template.width {
            outputs._width.accept("\(width)")
        }

        if let height = template.height {
            outputs._height.accept("\(height)")
        }

        if let depth = template.depth {
            outputs._depth.accept("\(depth)")
        }

        selectedColors.accept(template.colors ?? [])
        if hasArtCategory(template.categories) {
            brandOrArtists.accept(template.artists)
        } else {
            brandOrArtists.accept([template.brand].compactMap { $0 })
        }
        updateBrandArtistText()
    }

    private func openBrandSelection() {
        eventTracking.createAd.trackBrandClicked()
        let title = R.string.localizable.commonBrandTitle()
        let viewTitle = R.string.localizable.create_ad_select_brand_screen_title()
        let unknownSwitchLabel = R.string.localizable.createAdSelectBrandUnknownBrand()
        let suggestionTitle = R.string.localizable.createAdSelectBrandSuggestionTitle()
        let suggestionDescription = R.string.localizable.createAdSelectBrandSuggestionDescription()
        let suggestionPlaceholder = R.string.localizable.createAdSelectBrandSuggestionPlaceholder()
        let saveButton = R.string.localizable.createAdSelectBrandSaveButton()

        let inputs = AdAttributeSelectionViewModel.UIInputs(title: title,
                                                            viewTitle: viewTitle,
                                                            suggestionTitle: suggestionTitle,
                                                            suggestionDescription: suggestionDescription,
                                                            suggestionPlaceholder: suggestionPlaceholder,
                                                            saveButtonText: saveButton,
                                                            unknownSwitchLabel: unknownSwitchLabel,
                                                            allowSuggestion: true,
                                                            allowUnknown: true,
                                                            maxSelections: 1)

        let selectedAttributes = brandOrArtists.value.compactMap { $0 as? BrandAttribute }
        coordinator.selectAttribute(inputs: inputs,
                                    repo: brandRepo,
                                    selectedAttributes: selectedAttributes,
                                    delegate: self)
    }

    func openArtistSelection() {
        eventTracking.createAd.trackArtistClicked()

        let title = R.string.localizable.commonArtistTitle()
        let viewTitle = R.string.localizable.create_ad_select_artist_screen_title()
        let unknownSwitchLabel = R.string.localizable.createAdSelectArtistUnknownArtist()
        let suggestionTitle = R.string.localizable.createAdSelectArtistSuggestionTitle()
        let suggestionDescription = R.string.localizable.createAdSelectArtistSuggestionDescription()
        let suggestionPlaceholder = R.string.localizable.createAdSelectArtistSuggestionPlaceholder()
        let saveButton = R.string.localizable.createAdSelectArtistSaveButton()

        let inputs = AdAttributeSelectionViewModel.UIInputs(title: title,
                                                            viewTitle: viewTitle,
                                                            suggestionTitle: suggestionTitle,
                                                            suggestionDescription: suggestionDescription,
                                                            suggestionPlaceholder: suggestionPlaceholder,
                                                            saveButtonText: saveButton,
                                                            unknownSwitchLabel: unknownSwitchLabel,
                                                            allowSuggestion: true,
                                                            allowUnknown: true,
                                                            maxSelections: 1)

        let selectedAttributes = brandOrArtists.value.compactMap { $0 as? Artist }
        coordinator.selectAttribute(inputs: inputs,
                                    repo: artistRepo,
                                    selectedAttributes: selectedAttributes,
                                    delegate: self)
    }

    private func updateBrandArtistText() {
        let brandOrArtistList = brandOrArtists.value
        guard let adTemplate = adCreator.template else { return }

        let isArt = hasArtCategory(adTemplate.categories)
        if isArt {
            let allArtists = brandOrArtistList.map { $0.title }
            if allArtists.isEmpty {
                outputs._brandValue.accept(R.string.localizable.createAdDetailsSelectCommon())
            } else {
                outputs._brandValue.accept(allArtists.joined(separator: ", "))
            }
            outputs._brandTitle.accept(R.string.localizable.create_ad_select_artist_input_artist())
        } else {
            let brand = brandOrArtistList.first
            let title = brand?.title ?? R.string.localizable.createAdDetailsSelectCommon()
            outputs._brandValue.accept(title)
            outputs._brandTitle.accept(R.string.localizable.create_ad_select_brand_input_brand())
        }
    }
}

// MARK: Color

extension CreateAdDetailsViewModel {
    private func reloadColors() {
        apollo.fetch(query: GraphQL.GetAttributesQuery(key: .type, value: "Color")).subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            if let colors = data.data?.attributesByKey.compactMap({ $0.asColor }) {
                let existingColors = self.adCreator.template?.colors ?? []
                self.selectedColors.accept(existingColors)
                let viewModels = colors.map { (color) -> ColorViewModel in
                    let selected = existingColors.contains(where: { $0.id == color.id })
                    return ColorViewModel(color: color, selected: selected)
                }.sorted { $0.hex > $1.hex }
                self.outputs._colors.accept(viewModels.removingDuplicates())
            }
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.coordinator.showError(error)
        }).disposed(by: bag)
    }

    func colorSelected(vm: ColorViewModel) {
        if case let ColorViewModel.BackingData.color(color) = vm.data {
            var colors = selectedColors.value
            if vm.selected {
                colors.append(color)
            } else {
                colors = colors.filter { $0.id != color.id }
            }

            selectedColors.accept(colors)
        }
    }
}

// MARK: - AdAttributeSelectionViewControllerDelegate

extension CreateAdDetailsViewModel: AdAttributeSelectionViewControllerDelegate {
    func adAttributeSelectionViewController(didSelect attributes: [AdAttribute], ofType type: AttributeType) {
        switch type {
        case .brands:
            brandOrArtists.accept(attributes)
            if let brand = attributes.first as? BrandAttribute {
                eventTracking.createAd.trackBrandSaveClicked(brand: brand.slug)
            }

            updateBrandArtistText()
        case .artists:
            brandOrArtists.accept(attributes)
            if let artist = attributes.first as? Artist {
                eventTracking.createAd.trackArtistSaveClicked(artist: artist.slug)
            }
            updateBrandArtistText()
        case .materials:
            selectedMaterials.accept(attributes.compactMap { $0 as? Material })
            eventTracking.createAd.trackMaterialSaveClicked(materials: attributes)
        default: break
        }
    }
}
