//
//  HomeCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 23/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import CoreLocation
import Foundation
import WhoppahCore
import WhoppahCoreNext
import Resolver
import WhoppahDataStore
import WhoppahModel

class HomeCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private var viewModel: HomeViewModel?

    init(navigationController: UINavigationController, categoryRepo: WhoppahCore.CategoryRepository) {
        self.navigationController = navigationController
        let homeVC: HomeViewController = UIStoryboard.storyboard(storyboard: .home).instantiateViewController()
        let searchRepo = LegacySearchRepositoryImpl()
        let repository = HomeRepositoryImpl(searchRepository: searchRepo,
                                            categoryRepository: categoryRepo)
        let viewModel = HomeViewModel(repository: repository,
                                      coordinator: self)
        homeVC.viewModel = viewModel
        homeVC.coordinator = self
        navigationController.viewControllers.append(homeVC)
        self.viewModel = viewModel
    }

    func openCreateAd() {
        Navigator().navigate(route: Navigator.Route.createAd)
    }

    func openSearch(input: SearchProductsInput) {
        Navigator().navigate(route: Navigator.Route.search(input: input))
    }

    func openAdDetails(adID: UUID) {
        Navigator().navigate(route: Navigator.Route.ad(id: adID))
    }

    func openSafeShopping() {
        Navigator().navigate(route: Navigator.Route.usp)
    }

    func openLoginSplash() {
        guard let top = navigationController.topViewController else { return }
        guard let tabsVC = top.getTabsVC() else { return }
        tabsVC.openSplashIfNeeded()
    }
    
    func openUpdateAppDialog(_ type: AppUpdateRequirement) {
        let upgradeDialog: UpdateAppDialogHostingController = UpdateAppDialogHostingController()

        upgradeDialog.onOKTapped = {
            let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id1458122175?mt=8")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

            switch type {
            case .nonBlocking:
                upgradeDialog.dismiss(animated: false, completion: nil)
            case .blocking: break
            case .none: break
            }
        }
            
        upgradeDialog.onCloseTapped = {
            upgradeDialog.dismiss(animated: false, completion: nil)
        }

        upgradeDialog.isModalInPresentation = true
        upgradeDialog.modalPresentationStyle = .overFullScreen
        upgradeDialog.view.backgroundColor = .clear
        guard let top = navigationController.topViewController else { return }
        top.present(upgradeDialog, animated: false, completion: nil)
    }

    func askLocation(completed: AskLocationDialog.LocationSelected?) {
        guard let top = navigationController.topViewController else { return }
        let askLocationDialog = AskLocationDialog()
        askLocationDialog.onLocationSelected = completed
        top.present(askLocationDialog, animated: true, completion: nil)
    }

    func openMap(latitude: Double?, longitude: Double?) {
        guard let top = navigationController.topViewController else { return }
        guard let tabsVC = top.getTabsVC() else { return }
        let coordinator = MapSearchCoordinator(navigationController: tabsVC.navigationController!)
        coordinator.start(latitude: latitude, longitude: longitude, clearFiltersOnExit: true)
    }

    func openMap() {
        viewModel?.openMap()
    }

    func openUSP() {
        Navigator().navigate(route: Navigator.Route.usp)
    }
}
