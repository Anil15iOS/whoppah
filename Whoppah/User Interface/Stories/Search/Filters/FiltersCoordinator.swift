//
//  File.swift
//  Whoppah
//
//  Created by Eddie Long on 19/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import Resolver
import WhoppahDataStore

class FiltersCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    @Injected private var cacheService: CacheService
    @Injected private var searchService: SearchService

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(query: GraphQL.SearchQuery.Data) {
        let vc: FiltersViewController = FiltersViewController(nibName: nil, bundle: nil)
        let viewModel = FiltersViewModel(coordinator: self, query: query)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    func startModal(query: GraphQL.SearchQuery.Data) {
        guard let top = navigationController.topViewController else { return }

        let vc: FiltersViewController = FiltersViewController(nibName: nil, bundle: nil)
        let viewModel = FiltersViewModel(coordinator: self, query: query)
        vc.viewModel = viewModel

        navigationController = SwipeNavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        navigationController.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { navigationController.modalPresentationStyle = .fullScreen }
        top.present(navigationController, animated: true, completion: nil)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        if let top = navigationController.topViewController {
            top.dismiss(animated: true, completion: completion)
        } else {
            navigationController.popViewController(animated: true, completion: completion)
        }
    }
    
    func openSavedSearches() {
        let mySearchesVC: MySearchesViewController = UIStoryboard(storyboard: .myWhoppah).instantiateViewController()
        guard let tabs = navigationController.getTabsVC() else { return }
        tabs.navigationController?.pushViewController(mySearchesVC, animated: true)
    }

    func openFilterItem(filterItems: [FilterAttribute],
                        selected: [FilterAttribute],
                        selectionsAllowed: Int,
                        title: String,
                        isSearchable: Bool,
                        completion: @escaping (([FilterAttribute]) -> Void)) {
        let coordinator = FilterItemSelectionCoordinator(navigationController: navigationController)
        coordinator.start(filterItems: filterItems,
                          selected: selected,
                          selectionsAllowed: selectionsAllowed,
                          title: title,
                          isSearchable: isSearchable,
                          completion: completion)
    }

    func openColorFilter(colors: [FilterAttribute], selected: [FilterAttribute], completion: @escaping (([FilterAttribute]) -> Void)) {
        let coordinator = ColorFilterSelectionCoordinator(navigationController: navigationController)
        coordinator.start(colors: colors, selected: selected, completion: completion)
    }

    func openDistanceFilter(address: LegacyAddressInput?, radiusKm: Int, completion: @escaping (((address: LegacyAddressInput?, radiusKm: Int)) -> Void)) {
        let coordinator = DistanceFilterSelectionCoordinator(navigationController: navigationController)
        coordinator.start(address: address, radiusKm: radiusKm, completion: completion)
    }

    func openPriceFilter(minPrice: Money?, maxPrice: Money?, completion: @escaping (((minPrice: Money?, maxPrice: Money?)) -> Void)) {
        let coordinator = PriceFilterSelectionCoordinator(navigationController: navigationController)
        coordinator.start(minPrice: minPrice, maxPrice: maxPrice, completion: completion)
    }

    func openQualityFilter(selectedQuality: GraphQL.ProductQuality?, completion: @escaping ((GraphQL.ProductQuality) -> Void)) {
        let coordinator = QualityFilterSelectionCoordinator(navigationController: navigationController)
        coordinator.start(selectedQuality: selectedQuality, completion: completion)
    }

    func openCategoryFilter(delegate: CategoryFilterSelectionViewControllerDelegate, categories: [FilterAttribute]) {
        let selected = searchService.categories
        let topLevel = categories.filter {
            guard let products = $0.children, !products.isEmpty else { return false }
            return selected.contains($0) || selected.isEmpty
        }
        guard topLevel.isEmpty else {
            let categorySelectionVC: CategoryFilterSelectionViewController = UIStoryboard(storyboard: .search).instantiateViewController()
            categorySelectionVC.delegate = delegate
            categorySelectionVC.categoryType = .category
            categorySelectionVC.selectedCategories = selected
            categorySelectionVC.attributes = topLevel
            categorySelectionVC.isForceSelectionAvailable = true
            categorySelectionVC.repo = cacheService.categoryRepo
            navigationController.pushViewController(categorySelectionVC, animated: true)
            return
        }

        let secondLevel = categories.filter {
            guard let productTypes = $0.children else { return false }
            return !productTypes.filter {
                $0.children == nil || $0.children?.isEmpty == true
            }.isEmpty
        }
        guard secondLevel.isEmpty else {
            let categorySelectionVC: CategoryFilterSelectionViewController = UIStoryboard(storyboard: .search).instantiateViewController()
            categorySelectionVC.delegate = delegate
            categorySelectionVC.selectedCategories = selected
            categorySelectionVC.categoryType = .product
            categorySelectionVC.attributes = secondLevel
            categorySelectionVC.isForceSelectionAvailable = true
            navigationController.pushViewController(categorySelectionVC, animated: true)
            return
        }

        let bottomLevel = categories.filter { $0.children == nil || $0.children?.isEmpty == true }
        guard bottomLevel.isEmpty else {
            let categorySelectionVC: CategoryFilterSelectionViewController = UIStoryboard(storyboard: .search).instantiateViewController()
            categorySelectionVC.delegate = delegate
            categorySelectionVC.selectedCategories = selected
            categorySelectionVC.categoryType = .productType
            categorySelectionVC.attributes = bottomLevel
            categorySelectionVC.isForceSelectionAvailable = true
            navigationController.pushViewController(categorySelectionVC, animated: true)
            return
        }

        let categorySelectionVC: CategoryFilterSelectionViewController = UIStoryboard(storyboard: .search).instantiateViewController()
        categorySelectionVC.delegate = delegate
        categorySelectionVC.selectedCategories = selected
        categorySelectionVC.categoryType = .productType
        categorySelectionVC.attributes = categories
        categorySelectionVC.isForceSelectionAvailable = true
        categorySelectionVC.repo = cacheService.categoryRepo
        navigationController.pushViewController(categorySelectionVC, animated: true)
    }
}
