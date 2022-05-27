//
//  SearchResultsViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import Resolver
import WhoppahDataStore

class SearchResultsViewModel {
    
    @Injected fileprivate var eventTracking: EventTrackingService
    @Injected fileprivate var search: SearchService
    @Injected fileprivate var user: LegacyUserService
    @Injected fileprivate var apollo: ApolloService
    
    var coordinator: SearchResultsCoordinator!
    private var sortOrder: GraphQL.Ordering? // = .descending
    private var sortType: GraphQL.SearchSort? // = .createdAt

    private let repository: LegacySearchRepository
    private let categoryRepository: CategoryRepository
    private let bag = DisposeBag()

    // Filters
    struct Inputs {
        weak var vm: SearchResultsViewModel!
        var listPresentationMode = ListPresentation.grid {
            didSet {
                vm.outputs.itemList.onNext(.changePresentation(style: listPresentationMode))
            }
        }

        let search = PublishSubject<String>()
    }

    struct Outputs {
        let filters = BehaviorSubject<[FilterCellViewModel]>(value: [])
        let subCategories = BehaviorSubject<[FilterCellViewModel]>(value: [])
        // More items
        var itemList = PublishSubject<ListAction>()
        let search = BehaviorSubject<String?>(value: nil)
        var saving = PublishSubject<Bool>()
        let error = PublishSubject<Error>()
    }

    lazy var inputs = Inputs(vm: self, listPresentationMode: .grid)
    let outputs = Outputs()
    private var _filters = BehaviorRelay<[FilterCellViewModel]>(value: [])
    private var _subCategories = BehaviorRelay<[FilterCellViewModel]>(value: [])
    private var resultData: GraphQL.SearchQuery.Data?
    private var _categories = BehaviorRelay<[GraphQL.GetCategoriesQuery.Data.Category.Item]>(value: [])
    private var _flattenedCategories = BehaviorRelay<[WhoppahCore.Category]>(value: [])

    init(repo: LegacySearchRepository,
         categoryRepo: CategoryRepository,
         sortType: GraphQL.SearchSort? = nil,
         sortOrder: GraphQL.Ordering? = nil) {
        repository = repo
        categoryRepository = categoryRepo
        self.sortType = sortType
        self.sortOrder = sortOrder

        categoryRepository.load(level: 0)
        _filters.bind(to: outputs.filters).disposed(by: bag)
        _subCategories.bind(to: outputs.subCategories).disposed(by: bag)

        categoryRepository.categories
            .map { result -> [GraphQL.GetCategoriesQuery.Data.Category.Item] in
                switch result {
                case let .success(data):
                    guard let data = data else { return [] }
                    return data.categories.items
                case .failure:
                    return []
                }
            }
            .drive(onNext: { [weak self] categories in
                guard let self = self else { return }
                self._categories.accept(categories)
                self._flattenedCategories.accept(self.flattenCategoryList(categories: self._categories.value))
            }).disposed(by: bag)

        _ = repository.items.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(products):
                let initialCount = self.repository.numitems()

                var indexPaths = [IndexPath]()
                for (index, product) in products.elements.enumerated() {
                    indexPaths.append(IndexPath(row: initialCount + index, section: 0))
                    product.productClick.subscribe { [weak self] model in
                        guard let product = model.element else { return }
                        self?.eventTracking.trackClickProduct(ad: product, page: .search)
                        self?.openAd(product: product)
                    }.disposed(by: self.bag)
                }

                if self.repository.pager.currentPage > 1 {
                    self.eventTracking.searchResults.trackSearchScrolled(scrollDepth: self.pager.currentDepth)
                    self.outputs.itemList.onNext(.newRows(rows: indexPaths,
                                                          updater: SearchRepoUpdater(items: products.elements, repo: self.repository)))
                } else {
                    self.repository.applyItems(list: products.elements)
                    self.outputs.itemList.onNext(.reloadAll)
                }
            case let .failure(error):
                self.coordinator.showError(error)
            }
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.coordinator.showError(error)
        }).disposed(by: bag)

        repository.data.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.resultData = data
        }).disposed(by: bag)

        NotificationCenter.default.addObserver(self, selector: #selector(applyFiltersAction(_:)), name: FiltersViewModel.NotificationName.didApplyFilters, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetFiltersAction(_:)), name: FiltersViewModel.NotificationName.didResetFilters, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        updateSearch() // Tell the outside of the search text anyway
        updateFilterCollectionViews(true)
    }

    // MARK: actions

    func openMap() {
        eventTracking.searchResults.trackMapClicked()
        requestLocation {
            self.coordinator.openMap(longitude: self.search.address?.point?.longitude,
                                     latitude: self.search.address?.point?.latitude) {
                self.updateFilterCollectionViews()
                self.updateSearch()
            }
        }
    }

    func showFilters() {
        guard let data = resultData else { return }
        coordinator.showFilters(query: data)
        eventTracking.searchResults.trackFilterClicked()
    }

    func changeMoreItemsPresentation(_ style: ListPresentation) {
        eventTracking.trackListStyleClicked(style: style, page: .search)
        inputs.listPresentationMode = style
    }

    @objc func appDidBecomeActive() {
        updateFilterCollectionViews()
        updateSearch()
    }

    // MARK: Private

    private func openAd(product: WhoppahCore.Product) {
        coordinator.openAd(product: product)
    }

    private func requestLocation(completion: @escaping (() -> Void)) {
        guard search.address != nil else {
            coordinator.askLocation { address in
                self.search.address = address
                completion()
            }
            return
        }

        completion()
    }

    private func updateSearch() {
        outputs.search.onNext(search.searchText)
    }
}

extension SearchResultsViewModel {
    func load(loadMissingFilters _: Bool = false) {
        outputs.itemList.onNext(.loadingInitial)
        repository.load(query: search.searchText,
                        filter: search.filterInput,
                        sort: sortType,
                        ordering: sortOrder)
    }

    func loadMore() -> Bool {
        let hasMore = repository.loadMore()
        if !hasMore {
            outputs.itemList.onNext(.endRefresh)
        }
        return hasMore
    }
}

// MARK: Sorting

extension SearchResultsViewModel: SortByDialogDelegate {
    func sortByDialog(_: SortByDialog, didSelectOrder order: GraphQL.Ordering?, sortType type: GraphQL.SearchSort?) {
        applySort(order, type: type)
    }

    func openSortDialog() {
        coordinator.showSortDialog(order: sortOrder, type: sortType, delegate: self)
    }

    private func applySort(_ order: GraphQL.Ordering?, type: GraphQL.SearchSort?) {
        if type == .distance {
            if search.address == nil {
                requestLocation {
                    self.applySort(order, type: type)
                }
                return
            }
        }
        if sortOrder == order, sortType == type {
            return
        }
        sortOrder = order
        sortType = type

        updateFilterCollectionViews()
        load()
    }
}

// MARK: Save

extension SearchResultsViewModel {
    func save(completion: @escaping (() -> Void)) {
        outputs.saving.onNext(true)

        saveSearch(completion: completion)
    }

    private func saveSearch(completion: @escaping (() -> Void)) {
        outputs.saving.onNext(true)

        user.saveSearch(search: search.toSavedSearch()).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.outputs.saving.onNext(false)
            completion()
        }, onError: { [weak self] _ in
            self?.outputs.saving.onNext(false)
        }).disposed(by: bag)
    }
}

// MARK: Search/filters

extension SearchResultsViewModel {
    func applySearch(_ text: String?) {
        search.searchText = text
        if let text = text, !text.isEmpty {
            eventTracking.home.trackSearchPerformed(text: text)
        }
        load()
    }

    func onSearchTextChanged(_ text: String) {
        if text.isEmpty {
            applySearch(nil)
            return
        }
        performAutocomplete(text: text)
    }

    private func performAutocomplete(text _: String) {}

    func openSearchByPhoto() {
        coordinator.openSearchByPhoto()
    }
}

// MARK: Datasource

extension SearchResultsViewModel {
    var pager: PagedView {
        repository.pager
    }

    func getNumberOfItems() -> Int {
        repository.numitems()
    }

    func getCell(row: Int) -> AdViewModel? {
        repository.getViewModel(atIndex: row)
    }
}

// MARK: Filters

extension SearchResultsViewModel {
    private func updateFilterCollectionViews(_ loadMissingFilters: Bool = false) {
        var filters = [FilterItem]()
        var subCategories = [FilterItem]()

        if search.minPrice != nil || search.maxPrice != nil {
            filters.append(FilterItem.price(min: search.minPrice, max: search.maxPrice))
        }

        if let address = search.address {
            if address.postalCode.isEmpty {
                search.postcode.compactMap { $0 }
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { [weak self] postcode in
                        guard var filters = self?._filters.value else { return }
                        let filterItem = FilterItem.postalCode(code: postcode)
                        filters.append(FilterCellViewModel(item: filterItem, style: .deletable))
                        self?._filters.accept(filters)

                    }).disposed(by: bag)
            } else {
                filters.append(FilterItem.postalCode(code: address.postalCode))
            }
        }

        if let radius = search.radiusKilometres {
            filters.append(FilterItem.radius(value: radius))
        }

        if let quality = search.quality {
            filters.append(FilterItem.quality(value: quality))
        }

        for category in search.categories {
            filters.append(FilterItem.category(category: category))
        }

        let categorySlugs = Set<String>(search.categories.map { $0.slug })
        let flattenedCategories = _flattenedCategories.value
        let childFilters = calculateChildFilters(flattenedCategories, selectedItemSlugs: categorySlugs)
        subCategories.append(contentsOf: childFilters)

        for brand in search.brands {
            filters.append(FilterItem.filterAttribute(value: brand))
            if brand.title.value == nil, loadMissingFilters {
                loadMissingFilter(filterAttribute: brand) { (data) -> FilterAttribute? in
                    if let title = data.asBrand?.title {
                        let filterAttribute = FilterAttribute(type: .brand, slug: brand.slug, title: title, children: [])
                        if let index = self.search.brands.firstIndex(where: { $0.slug == brand.slug }) {
                            self.search.brands[index] = filterAttribute
                        }
                        return filterAttribute
                    }
                    return nil
                }
            }
        }

//        for artist in search.artists {
//            filters.append(FilterItem.filterAttribute(value: artist))
//            if artist.title.value == nil, loadMissingFilters {
//                loadMissingFilter(filterAttribute: artist) { (data) -> FilterAttribute? in
//                    if let title = data.asArtist?.title {
//                        let filterAttribute = FilterAttribute(type: .artist, slug: artist.slug, title: title, children: [])
//                        if let index = self.search.artists.firstIndex(where: { $0.slug == artist.slug }) {
//                            self.search.artists[index] = filterAttribute
//                        }
//                        return filterAttribute
//                    }
//                    return nil
//                }
//            }
//        }

        for designer in search.designers {
            filters.append(FilterItem.filterAttribute(value: designer))
            if designer.title.value == nil, loadMissingFilters {
                loadMissingFilter(filterAttribute: designer) { (data) -> FilterAttribute? in
                    if let title = data.asDesigner?.title {
                        let filterAttribute = FilterAttribute(type: .designer, slug: designer.slug, title: title, children: [])
                        if let index = self.search.designers.firstIndex(where: { $0.slug == designer.slug }) {
                            self.search.designers[index] = filterAttribute
                        }
                        return filterAttribute
                    }
                    return nil
                }
            }
        }

        for style in search.styles {
            filters.append(FilterItem.filterAttribute(value: style))
        }

        for material in search.materials {
            filters.append(FilterItem.filterAttribute(value: material))
        }

        for color in search.colors {
            filters.append(FilterItem.filterAttribute(value: color))
        }

        if search.arReady != nil {
            filters.append(FilterItem.arReady(value: true))
        }

        _filters.accept(filters.map { FilterCellViewModel(item: $0, style: .deletable) })
        _subCategories.accept(subCategories.map { FilterCellViewModel(item: $0, style: .selectable) })
    }

    func removeFilters() {
        _filters.accept([])
        _subCategories.accept([])
        search.removeAllFilters()
        load()
    }

    func removeFilter(atIndex index: Int) {
        let filters = _filters.value
        let filter = filters[index].filter
        let flattenedCategories = _flattenedCategories.value

        switch filter {
        case let .category(category):
            // If removing a leaf category we add the parent of that category
            // However we only do this if there isn't any sibling categories in the selected categories
            // This has the effect of 'navigating' up the category tree when removing categories
            if let foundCategory = flattenedCategories.first(where: { $0.slug == category.slug }), let parent = foundCategory.ancestor {
                var parentMatch = false
                for existing in search.categories.filter({ $0.slug != category.slug }) {
                    if let existingCategory = flattenedCategories.first(where: { $0.slug == existing.slug }) {
                        if existingCategory.ancestor?.slug == foundCategory.ancestor?.slug {
                            parentMatch = true
                        }
                    }
                }

                // No parent exists and the category has a parenty
                if !parentMatch {
                    search.categories.insert(FilterAttribute(type: .category, slug: parent.slug))
                }
            }
        default: break
        }
        removeFilter(filter)
    }

    func addSubcategoryFilter(atIndex index: Int) {
        let filters = _subCategories.value
        let filter = filters[index].filter

        let flattenedCategories = _flattenedCategories.value

        switch filter {
        case let .category(category):
            // If we're adding a sub-category then we remove the parent category
            // If we keep the parent category then the filtering will not worse
            // i.e. having a top category 'furniture' includes all furniture items
            // Adding sofa in as a sub-category does not narrow the search, we'd need to remove the top 'furniture' category
            if let foundCategory = flattenedCategories.first(where: { $0.slug == category.slug }) {
                var parent: WhoppahCore.Category? = foundCategory
                while let item = parent?.ancestor {
                    if let first = search.categories.first(where: { $0.slug == item.slug }) {
                        search.categories.remove(first)
                    }
                    parent = item
                }
            }

            search.categories.insert(FilterAttribute(type: .category, slug: category.slug))

        default:
            assertionFailure("Only categories are currently supported")
        }

        updateFilterCollectionViews()

        load()
    }

    private func removeFilter(_ filter: FilterItem) {
        switch filter {
        case .price:
            search.minPrice = nil
            search.maxPrice = nil
        case .postalCode:
            search.address = nil
            // Postcode is now gone - reset back to default search
            sortType = nil
            sortOrder = nil
        case .radius:
            search.radiusKilometres = nil
        case .quality:
            search.quality = nil
        case let .category(category):
            search.categories.remove(category)
        case let .filterAttribute(value):
            switch value.type {
            case .brand:
                search.brands = search.brands.filter { $0.slug != value.slug }
            case .style:
                search.styles = search.styles.filter { $0.slug != value.slug }
            case .material:
                search.materials = search.materials.filter { $0.slug != value.slug }
            case .color:
                search.colors = search.colors.filter { $0.slug != value.slug }
            case .designer:
                search.designers = search.designers.filter { $0.slug != value.slug }
//            case .artist:
//                search.artists = search.artists.filter { $0.slug != value.slug }
            case .category: assertionFailure("Should not be possible")
            }
        case .arReady:
            search.arReady = nil
        }

        updateFilterCollectionViews()

        load()
    }

    func getFilterWidth(atIndex index: Int) -> CGFloat {
        _filters.value[index].getWidth(includeDelete: true)
    }

    func getSubCategoryfilterWidth(atIndex index: Int) -> CGFloat {
        _subCategories.value[index].getWidth(includeDelete: false)
    }

    @objc func applyFiltersAction(_: Notification) {
        updateFilterCollectionViews()
        load()
    }

    @objc func resetFiltersAction(_: Notification) {
        updateFilterCollectionViews()
        load()
    }

    // MARK: Privates

    private func flattenCategoryList(categories: [WhoppahCore.Category]) -> [WhoppahCore.Category] {
        var flatArray: [WhoppahCore.Category] = []
        categories.forEach { flatArray.append(contentsOf: flattenCategories(category: $0)) }
        return flatArray
    }

    private func flattenCategories(category: WhoppahCore.Category) -> [WhoppahCore.Category] {
        var flatArray: [WhoppahCore.Category] = []
        flatArray.append(category)
        category.children.forEach { flatArray += flattenCategories(category: $0) }
        return flatArray
    }

    private func calculateChildFilters(_ categories: [WhoppahCore.Category], selectedItemSlugs: Set<String>) -> [FilterItem] {
        var filters = [FilterItem]()
        // This is a rather fiddly process
        // Go through all categories that are selected
        for category in categories where selectedItemSlugs.contains(category.slug) {
            // If any of the categories children overlap with the selected slugs then we process the children
            let childSlugs = Set<String>(category.children.map { $0.slug })
            let intersection = selectedItemSlugs.intersection(childSlugs)
            guard intersection.isEmpty else {
                // Recursively process children
                let children = calculateChildFilters(category.children, selectedItemSlugs: selectedItemSlugs)
                if !children.isEmpty {
                    filters.append(contentsOf: children)
                } else {
                    // No children, just add all children of the category (filtering out selected items)
                    let childFilters = category.children
                        .filter { !selectedItemSlugs.contains($0.slug) }
                        .map { FilterItem.category(category: FilterAttribute(type: .category, slug: $0.slug)) }
                    filters.append(contentsOf: childFilters)
                }
                continue
            }

            // No children of the category are selected
            // Check if there are actually any children, if none we just add all siblings
            // Otherwise we add the children
            guard !category.children.isEmpty else {
                // Getting siblings is quite tricky, we need to go up to the parent and then get the parent's children
                if let parent = category.ancestor, let foundCategory = categories.first(where: { $0.slug == parent.slug }) {
                    filters = foundCategory.children
                        .filter { !selectedItemSlugs.contains($0.slug) }
                        .map { FilterItem.category(category: FilterAttribute(type: .category, slug: $0.slug)) }
                }
                continue
            }

            // Category has children, add all non-selected items
            let childFilters = category.children
                .filter { !selectedItemSlugs.contains($0.slug) }
                .map { FilterItem.category(category: FilterAttribute(type: .category, slug: $0.slug)) }
            filters.append(contentsOf: childFilters)
        }
        return filters
    }
}

extension SearchResultsViewModel {
    func trackVideoView(_ ad: AdViewModel) {
        eventTracking.trackVideoViewed(ad: ad.product, isFullScreen: true, page: .search)
    }
}

extension SearchResultsViewModel {
    func loadMissingFilter(filterAttribute: FilterAttribute, attributeHelper: @escaping ((GraphQL.GetAttributeQuery.Data.AttributeByKey) -> FilterAttribute?)) {
        apollo.fetch(query: GraphQL.GetAttributeQuery(key: .slug, value: filterAttribute.slug))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] attribute in
                guard let self = self else { return }
                guard let data = attribute.data?.attributeByKey else { return }
                guard let newAttribute = attributeHelper(data) else { return }

                var filters = self._filters.value
                // Find the item in the filters (it could be removed)
                for i in filters.startIndex ... filters.endIndex {
                    if case let .filterAttribute(attribute) = filters[i].filter {
                        if attribute.slug == filterAttribute.slug {
                            let filterItem = FilterItem.filterAttribute(value: newAttribute)
                            filters[i] = FilterCellViewModel(item: filterItem, style: .deletable)
                            self._filters.accept(filters)
                            break
                        }
                    }
                }
            }).disposed(by: bag)
    }
}
