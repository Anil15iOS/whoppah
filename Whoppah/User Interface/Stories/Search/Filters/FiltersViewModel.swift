//
//  FiltersViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 19/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class FiltersViewModel {
    struct NotificationName {
        static let didApplyFilters = Notification.Name("com.whoppah.filters.apply")
        static let didResetFilters = Notification.Name("com.whoppah.filters.reset")
    }

    struct AttributeBlock {
        let displayTitle: String
        let items: [FilterAttribute]
    }

    enum SaveQueryState {
        case saving
        case saved
        case error(Error)
    }

    struct Inputs {
        let attribute = PublishSubject<(title: String, selected: [String], isColor: Bool)>()
        let reset = PublishSubject<Void>()
        let filter = PublishSubject<Void>()
        let save = PublishSubject<Void>()
        let dismiss = PublishSubject<Void>()
    }

    struct Outputs {
        let searchText = PublishSubject<String>()
        let attributes = PublishSubject<[(title: String, selected: [String], isColor: Bool)]>()
        let filterEnabled = PublishSubject<Bool>()
        let save = PublishSubject<SaveQueryState>()
    }

    private let categoryBlock: AttributeBlock?
    private let brandBlock: AttributeBlock?
    private let designerBlock: AttributeBlock?
//    private let artistBlock: AttributeBlock?
    private let styleBlock: AttributeBlock?
    private let colorBlock: AttributeBlock?
    private let materialBlock: AttributeBlock?

    var inputs = Inputs()
    let outputs = Outputs()

    private let bag = DisposeBag()
    private let coordinator: FiltersCoordinator
    private let query: GraphQL.SearchQuery.Data
    
    @Injected fileprivate var search: SearchService
    @Injected fileprivate var eventTrackingService: EventTrackingService
    @Injected fileprivate var userService: WhoppahCore.LegacyUserService

    init(coordinator: FiltersCoordinator, query: GraphQL.SearchQuery.Data) {
        self.coordinator = coordinator
        self.query = query

        designerBlock = FiltersViewModel.getAttributeBlock(query: query, type: .designer, displayTitle: R.string.localizable.search_filters_designer())
        brandBlock = FiltersViewModel.getAttributeBlock(query: query, type: .brand, displayTitle: R.string.localizable.search_filters_brand())
//        artistBlock = FiltersViewModel.getAttributeBlock(query: query, type: .artist, displayTitle: R.string.localizable.search_filters_artist())
        styleBlock = FiltersViewModel.getAttributeBlock(query: query, type: .style, displayTitle: R.string.localizable.search_filters_style())
        materialBlock = FiltersViewModel.getAttributeBlock(query: query, type: .material, displayTitle: R.string.localizable.search_filters_material_title())
        colorBlock = FiltersViewModel.getAttributeBlock(query: query, type: .color, displayTitle: R.string.localizable.search_filters_color_title())
        categoryBlock = FiltersViewModel.getCategoryBlock(query: query, displayTitle: R.string.localizable.search_filters_category())
        
        updateFilters()
    }

    func load() {
        _ = FiltersViewModel.getAttributeBlock(query: query, type: .color, displayTitle: "")
        updateFilters()
        setupInputs()
    }
        
    func goToSavedSearches() {
        coordinator.dismiss {
            self.coordinator.openSavedSearches()
        }
    }

}

// MARK: - Private

private extension FiltersViewModel {
    func setupInputs() {
        inputs.attribute.subscribe(onNext: { [weak self] attribute in
            guard let self = self else { return }
            switch attribute.title {
            case R.string.localizable.search_filters_category():
                self.coordinator.openCategoryFilter(delegate: self, categories: self.categoryBlock?.items ?? [])
            case R.string.localizable.search_filters_price_only_title():
                self.coordinator.openPriceFilter(minPrice: self.search.minPrice,
                                                 maxPrice: self.search.maxPrice) { [weak self] minPrice, maxPrice in
                    self?.search.minPrice = minPrice
                    self?.search.maxPrice = maxPrice
                }
            case R.string.localizable.search_filters_brand():
                self.coordinator.openFilterItem(filterItems: self.brandBlock?.items ?? [],
                                                selected: self.search.brands,
                                                selectionsAllowed: 100,
                                                title: R.string.localizable.search_filters_brand(),
                                                isSearchable: true) { [weak self] selected in
                    self?.search.brands = selected
                }
            case R.string.localizable.search_filters_designer():
                self.coordinator.openFilterItem(filterItems: self.designerBlock?.items ?? [],
                                                selected: self.search.designers,
                                                selectionsAllowed: 100,
                                                title: R.string.localizable.search_filters_designer(),
                                                isSearchable: true) { [weak self] selected in
                    self?.search.designers = selected
                }
//            case R.string.localizable.search_filters_artist():
//                self.coordinator.openFilterItem(filterItems: self.artistBlock?.items ?? [],
//                                                selected: self.search.artists,
//                                                selectionsAllowed: 100,
//                                                title: R.string.localizable.search_filters_artist(),
//                                                isSearchable: true) { [weak self] selected in
//                    self?.search.artists = selected
//                }
            case R.string.localizable.search_filters_style():
                self.coordinator.openFilterItem(filterItems: self.styleBlock?.items ?? [],
                                                selected: self.search.styles,
                                                selectionsAllowed: 100,
                                                title: R.string.localizable.search_filters_style(),
                                                isSearchable: false) { [weak self] selected in
                    self?.search.styles = selected
                }
            case R.string.localizable.search_filters_color_title():
                self.coordinator.openColorFilter(colors: self.colorBlock?.items ?? [],
                                                 selected: self.search.colors) { [weak self] selected in
                    self?.search.colors = selected
                }
            case R.string.localizable.search_filters_condition_title():
                self.coordinator.openQualityFilter(selectedQuality: self.search.quality) { [weak self] quality in
                    self?.search.quality = quality
                }
            case R.string.localizable.search_filters_material_title():
                self.coordinator.openFilterItem(filterItems: self.materialBlock?.items ?? [],
                                                selected: self.search.materials,
                                                selectionsAllowed: 100,
                                                title: R.string.localizable.search_filters_material_title(),
                                                isSearchable: false) { [weak self] selected in
                    self?.search.materials = selected
                }
            case R.string.localizable.search_filters_distance_from_you_title():
                self.coordinator.openDistanceFilter(address: self.search.address,
                                                    radiusKm: self.search.radiusKilometres ?? defaultRadiusKm) { [weak self] address, radiusKm in
                    self?.search.address = address
                    self?.search.radiusKilometres = radiusKm
                }
            default:
                break
            }
        }).disposed(by: bag)

        inputs.filter
            .bind { [unowned self] _ in self.filter() }
            .disposed(by: bag)

        inputs.reset
            .bind { [unowned self] _ in self.reset() }
            .disposed(by: bag)

        inputs.save
            .bind { [unowned self] _ in self.save() }
            .disposed(by: bag)

        inputs.dismiss
            .bind { [unowned self] _ in self.coordinator.dismiss() }
            .disposed(by: bag)
    }

    func updateFilters() {
        var attributes = [(title: String, selected: [String], isColor: Bool)]()
        var selected: String = ""

        if let text = search.searchText, !text.isEmpty {
            outputs.searchText.onNext(R.string.localizable.search_filters_title(text))
        } else {
            outputs.searchText.onNext(R.string.localizable.search_filters_title_empty())
        }

        if let categoryBlock = categoryBlock {
            let selected = search.categories.compactMap { $0.title.value?.capitalizingFirstLetter() }
            attributes.append((categoryBlock.displayTitle, selected, isColor: false))
        }

        if let minPrice = search.minPrice {
            selected = "\(PriceInput(currency: .eur, amount: minPrice).formattedPrice())"
        }

        if let maxPrice = search.maxPrice {
            if search.minPrice == nil { selected = "\(PriceInput(currency: .eur, amount: 0).formattedPrice())" }
            selected.append(contentsOf: " - \(PriceInput(currency: .eur, amount: maxPrice).formattedPrice())")
        } else if !selected.isEmpty {
            selected = "\(selected) <"
        }
        attributes.append((R.string.localizable.search_filters_price_only_title(),
                           !selected.isEmpty ? [selected] : [],
                           isColor: false))

        if let brandBlock = brandBlock {
            let selected = search.brands.compactMap { $0.title.value?.capitalizingFirstLetter() }
            attributes.append((brandBlock.displayTitle, selected, isColor: false))
        }

        if let designerBlock = designerBlock {
            let selected = search.designers.compactMap { $0.title.value?.capitalizingFirstLetter() }
            attributes.append((designerBlock.displayTitle, selected, isColor: false))
        }

//        if let artistBlock = artistBlock {
//            let selected = search.artists.compactMap { $0.title.value?.capitalizingFirstLetter() }
//            attributes.append((artistBlock.displayTitle, selected, isColor: false))
//        }

        if let styleBlock = styleBlock {
            let selected = search.styles.compactMap { $0.title.value?.capitalizingFirstLetter() }
            attributes.append((styleBlock.displayTitle, selected, isColor: false))
        }

        selected = search.quality?.title() ?? ""
        attributes.append((R.string.localizable.search_filters_condition_title(),
                           !selected.isEmpty ? [selected] : [],
                           isColor: false))

        if let colorBlock = colorBlock {
            let selected = search.colors.compactMap { $0.title.value?.capitalizingFirstLetter() }
            attributes.append((colorBlock.displayTitle, selected, isColor: true))
        }

        if let materialBlock = materialBlock {
            let selected = search.materials.compactMap { $0.title.value?.capitalizingFirstLetter() }
            attributes.append((materialBlock.displayTitle, selected, isColor: false))
        }
        
        selected = search.radiusKilometres != nil ? R.string.localizable.search_filters_distance_km(search.radiusKilometres!) : ""

        outputs.attributes.onNext(attributes)
        outputs.filterEnabled.onNext(search.filtersCount > 0)
    }
    
    func reset() {
        search.removeAllFilters()
        NotificationCenter.default.post(name: NotificationName.didResetFilters, object: nil)
        coordinator.dismiss()
    }

    func filter() {
        eventTrackingService.filter.trackFilterClicked(provider: search)
        NotificationCenter.default.post(name: NotificationName.didApplyFilters, object: nil)
        coordinator.dismiss()
    }

    func save() {
        outputs.save.onNext(.saving)
        userService.saveSearch(search: search.toSavedSearch()).subscribe { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .next:
                self.outputs.save.onNext(.saved)
            case let .error(error):
                self.outputs.save.onNext(.error(error))
            default:
                break
            }
        }.disposed(by: bag)
    }
}

// MARK: - Blocks

private extension FiltersViewModel {
    static func getAttributeBlock(query: GraphQL.SearchQuery.Data,
                                  type: FilterAttributeType,
                                  displayTitle: String) -> AttributeBlock? {
        let attributes = query.search.attributes
        let queryItems = attributes.filter { (attributeList) -> Bool in
            !attributeList.items.filter { (item) -> Bool in
                let attribute = item.attribute
                switch type {
                case .brand:
                    return attribute.asBrand != nil
                case .style:
                    return attribute.asStyle != nil
                case .designer:
                    return attribute.asDesigner != nil
                case .material:
                    return attribute.asMaterial != nil
                case .color:
                    return attribute.asColor != nil
//                case .artist:
//                    return attribute.asArtist != nil
                default:
                    break
                }
                return false
            }.isEmpty
        }

        guard let block = queryItems.first else { return nil }
        guard let filterItems = FiltersViewModel.getFilterItems(block.items, type: type) else { return nil }
        return AttributeBlock(displayTitle: displayTitle, items: filterItems)
    }

    static func getCategoryBlock(query: GraphQL.SearchQuery.Data, displayTitle: String) -> AttributeBlock? {
        let categories = query.search.categories
        guard !categories.items.isEmpty else { return nil }
        guard let filterItems = FiltersViewModel.getCategoryItems(categories.items) else { return nil }
        return AttributeBlock(displayTitle: displayTitle, items: filterItems)
    }
}

// MARK: - Filter Items

private extension FiltersViewModel {
    static func getFilterItems(_ items: [GraphQL.SearchQuery.Data.Search.Attribute.Item]?,
                               type: FilterAttributeType) -> [FilterAttribute]? {
        guard let items = items else { return nil }
        var filterItems = [FilterAttribute]()
        for item in items {
            let children = getFilterItemItems(item.items, type: type)
            if let artist = item.attribute.asArtist {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: artist.title, children: children))
            } else if let designer = item.attribute.asDesigner {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: designer.title, children: children))
            } else if let brand = item.attribute.asBrand {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: brand.title, children: children))
            } else if item.attribute.asStyle != nil {
                filterItems.append(FilterAttribute(type: type, slug: item.key, children: children))
            } else if item.attribute.asMaterial != nil {
                filterItems.append(FilterAttribute(type: type, slug: item.key, children: children))
            } else if let color = item.attribute.asColor {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: color.hex, children: children))
            }
        }
        return filterItems
    }

    static func getFilterItemItems(_ items: [GraphQL.SearchQuery.Data.Search.Attribute.Item.Item]?,
                                   type: FilterAttributeType) -> [FilterAttribute]? {
        guard let items = items else { return nil }
        var filterItems = [FilterAttribute]()

        for item in items {
            let children = getFilterItemItemItems(item.items, type: type)
            if let artist = item.attribute.asArtist {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: artist.title, children: children))
            } else if let designer = item.attribute.asDesigner {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: designer.title, children: children))
            } else if let brand = item.attribute.asBrand {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: brand.title, children: children))
            } else if item.attribute.asStyle != nil {
                filterItems.append(FilterAttribute(type: type, slug: item.key, children: children))
            } else if item.attribute.asMaterial != nil {
                filterItems.append(FilterAttribute(type: type, slug: item.key, children: children))
            } else if let color = item.attribute.asColor {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: color.hex, children: children))
            }
        }
        return filterItems
    }

    static func getFilterItemItemItems(_ items: [GraphQL.SearchQuery.Data.Search.Attribute.Item.Item.Item]?,
                                       type: FilterAttributeType) -> [FilterAttribute]? {
        guard let items = items else { return nil }
        var filterItems = [FilterAttribute]()

        for item in items {
            if let artist = item.attribute.asArtist {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: artist.title))
            } else if let designer = item.attribute.asDesigner {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: designer.title))
            } else if let brand = item.attribute.asBrand {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: brand.title))
            } else if item.attribute.asStyle != nil {
                filterItems.append(FilterAttribute(type: type, slug: item.key))
            } else if item.attribute.asMaterial != nil {
                filterItems.append(FilterAttribute(type: type, slug: item.key))
            } else if let color = item.attribute.asColor {
                filterItems.append(FilterAttribute(type: type, slug: item.key, title: color.hex))
            }
        }
        return filterItems
    }
}

// MARK: - Category Items

private extension FiltersViewModel {
    static func getCategoryItems(_ items: [GraphQL.SearchQuery.Data.Search.Category.Item]?) -> [FilterAttribute]? {
        items?.map {
            let children = getCategoryItemsItems($0.items)
            return FilterAttribute(type: .category, slug: $0.slug, children: children)
        } ?? []
    }

    static func getCategoryItemsItems(_ items: [GraphQL.SearchQuery.Data.Search.Category.Item.Item]?) -> [FilterAttribute]? {
        items?.map {
            let children = getCategoryItemItemItems($0.items)
            return FilterAttribute(type: .category, slug: $0.slug, children: children)
        } ?? []
    }

    static func getCategoryItemItemItems(_ items: [GraphQL.SearchQuery.Data.Search.Category.Item.Item.Item]?) -> [FilterAttribute]? {
        items?.map { FilterAttribute(type: .category, slug: $0.slug) } ?? []
    }
}

// MARK: - CategoryFilterSelectionViewControllerDelegate

extension FiltersViewModel: CategoryFilterSelectionViewControllerDelegate {
    func categoryFilterSelectionViewController(didSelectCategories categories: Set<FilterAttribute>) {
        search.categories = categories
    }
}

// MARK: - SaveQueryState

extension FiltersViewModel.SaveQueryState {
    static func == (lhs: FiltersViewModel.SaveQueryState, rhs: FiltersViewModel.SaveQueryState) -> Bool {
        switch (lhs, rhs) {
        case (.saving, .saving):
            return true
        case (.saved, .saved):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
