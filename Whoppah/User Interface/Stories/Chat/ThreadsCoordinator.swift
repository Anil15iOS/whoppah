//
//  ThreadsCoordinator.swift
//  Whoppah
//
//  Created by Eddie Long on 12/07/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import WhoppahCore

class ThreadsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let threadsVC: ThreadsViewController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        threadsVC = UIStoryboard.storyboard(storyboard: .chat).instantiateViewController()
        let repo = ThreadsRepositoryImpl()
        threadsVC.viewModel = ThreadsViewModel(coordinator: self, repo: repo)
    }

    func start() {
        navigationController.pushViewController(threadsVC, animated: true)
    }

    func openThreads() {
        navigationController.popToRootViewController(animated: false)
        threadsVC.reloadThreads()
    }

    func openThread(id: UUID) {
        guard let navigationC = navigationController.getTabsVC()?.navigationController else { return }
        let coordinator = ThreadCoordinator(navigationController: navigationC)
        coordinator.start(threadID: id)
    }
}
