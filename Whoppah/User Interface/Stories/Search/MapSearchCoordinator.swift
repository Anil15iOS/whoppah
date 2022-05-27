//
//  MapSearchCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 09/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore
import WhoppahDataStore

class MapSearchCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(latitude: Double?, longitude: Double?, clearFiltersOnExit: Bool, completion: (() -> Void)? = nil) {
        let vc: MapSearchViewController = UIStoryboard(storyboard: .search).instantiateViewController()
        vc.viewModel = MapSearchViewModel(repo: LegacySearchRepositoryImpl(),
                                          coordinator: self,
                                          latitude: latitude,
                                          longitude: longitude)
        vc.viewModel.removeFiltersOnDismiss = clearFiltersOnExit
        navigationController.pushViewController(viewController: vc, animated: true, completion: completion)
    }

    func openSearchByPhoto() {
        Navigator().navigate(route: Navigator.Route.searchByPhoto)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
    }

    func showFilters(query: GraphQL.SearchQuery.Data) {
        let navigationVC: UINavigationController = UINavigationController()
        navigationVC.isNavigationBarHidden = true
        navigationVC.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { navigationVC.modalPresentationStyle = .fullScreen }
        let filterCoordinator = FiltersCoordinator(navigationController: navigationVC)
        filterCoordinator.start(query: query)
        guard let top = navigationController.topViewController else { return }
        top.present(navigationVC, animated: true, completion: nil)
    }

    func openAd(id: UUID) {
        Navigator().navigate(route: Navigator.Route.ad(id: id))
    }
}
