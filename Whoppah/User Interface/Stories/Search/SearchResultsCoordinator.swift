//
//  SearchResultsCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 16/08/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import Resolver
import WhoppahDataStore
import WhoppahModel

class SearchResultsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    @Injected private var cacheService: CacheService

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let searchViewController = SearchViewHostingController(searchInput: .init(),
                                                               parentNavigationController: navigationController)
        navigationController.pushViewController(searchViewController, animated: true)
    }

    func start(input: SearchProductsInput) {
        let searchViewController = SearchViewHostingController(searchInput: input,
                                                               parentNavigationController: navigationController)
        navigationController.pushViewController(searchViewController, animated: true)
    }

    func showFilters(query: GraphQL.SearchQuery.Data) {
        let coordinator = FiltersCoordinator(navigationController: navigationController)
        coordinator.startModal(query: query)
    }

    func showSortDialog(order: GraphQL.Ordering?, type: GraphQL.SearchSort?, delegate: SortByDialogDelegate) {
        guard let top = navigationController.topViewController else { return }
        let dialog = SortByDialog()
        dialog.delegate = delegate
        dialog.selectedSortOrder = order
        dialog.selectedSortType = type
        top.present(dialog, animated: true, completion: nil)
    }

    func openMap(longitude: Double?,
                 latitude: Double?,
                 completion: @escaping (() -> Void)) {
        let coordinator = MapSearchCoordinator(navigationController: navigationController)
        // Retain filters on exit
        coordinator.start(latitude: latitude, longitude: longitude, clearFiltersOnExit: false, completion: completion)
    }

    func openSearchByPhoto() {
        Navigator().navigate(route: Navigator.Route.searchByPhoto)
    }

    func askLocation(delegate: @escaping AskLocationDialog.LocationSelected) {
        guard let top = navigationController.topViewController else { return }
        let dialog = AskLocationDialog()
        dialog.onLocationSelected = delegate
        top.present(dialog, animated: true, completion: nil)
    }

    func openAd(product: WhoppahCore.Product) {
        Navigator().navigate(route: Navigator.Route.ad(id: product.id))
    }
}
