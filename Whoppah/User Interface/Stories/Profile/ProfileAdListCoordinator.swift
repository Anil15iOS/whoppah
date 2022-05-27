//
//  ProfileAdListCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 06/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

public class ProfileAdListCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    weak var adDetailsVC: AdDetailsViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(merchant: LegacyMerchantOther,
               listType: ProfileAdListViewModel.ListType,
               delegate: ProfileAdListDelegate?) {
        let vc: ProfileAdListViewController = UIStoryboard.storyboard(storyboard: .profile).instantiateViewController()
        vc.delegate = delegate
        let productRepo = ProductsRepositoryImpl()
        let repo = ProfileAdListRepositoryImpl(productRepo: productRepo)
        vc.viewModel = ProfileAdListViewModel(listType: listType,
                                              coordinator: self,
                                              repo: repo,
                                              merchant: merchant)
        navigationController.pushViewController(vc, animated: true)
    }

    func postAd() {
        let nav = WhoppahNavigationController()
        nav.isNavigationBarHidden = true
        nav.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { nav.modalPresentationStyle = .fullScreen }
        let coordinator = CreateAdOnboardingCoordinatorImpl(navigationController: nav)
        coordinator.start()
        guard let top = navigationController.topViewController else { return }
        top.present(nav, animated: true, completion: nil)
    }

    func openAd(viewModel: AdViewModel) {
        let navigationVC = UINavigationController()
        navigationVC.isNavigationBarHidden = true
        navigationVC.isModalInPresentation = true
        if UIDevice.current.userInterfaceIdiom != .pad { navigationVC.modalPresentationStyle = .fullScreen }
        let coordinator = AdDetailsCoordinator(navigationController: navigationVC)
        coordinator.start(adID: viewModel.product.id)

        guard let top = navigationController.topViewController else { return }
        top.present(navigationVC, animated: true, completion: nil)
    }
}
